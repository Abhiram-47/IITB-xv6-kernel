
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 6c 11 80       	mov    $0x80116cd0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 30 10 80       	mov    $0x80103030,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 76 10 80       	push   $0x80107680
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 05 47 00 00       	call   80104760 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 76 10 80       	push   $0x80107687
80100097:	50                   	push   %eax
80100098:	e8 93 45 00 00       	call   80104630 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 67 48 00 00       	call   80104950 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 89 47 00 00       	call   801048f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 44 00 00       	call   80104670 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 3f 21 00 00       	call   801022d0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 8e 76 10 80       	push   $0x8010768e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 4d 45 00 00       	call   80104710 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 f7 20 00 00       	jmp    801022d0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 9f 76 10 80       	push   $0x8010769f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 0c 45 00 00       	call   80104710 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 bc 44 00 00       	call   801046d0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 30 47 00 00       	call   80104950 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 82 46 00 00       	jmp    801048f0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 a6 76 10 80       	push   $0x801076a6
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 ab 46 00 00       	call   80104950 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 2e 3d 00 00       	call   80104000 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 b9 36 00 00       	call   801039a0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 f5 45 00 00       	call   801048f0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 9f 45 00 00       	call   801048f0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 32 25 00 00       	call   801028d0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ad 76 10 80       	push   $0x801076ad
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 9b 79 10 80 	movl   $0x8010799b,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 b3 43 00 00       	call   80104780 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 c1 76 10 80       	push   $0x801076c1
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 9c 5d 00 00       	call   801061c0 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 d1 5c 00 00       	call   801061c0 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 c5 5c 00 00       	call   801061c0 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 b9 5c 00 00       	call   801061c0 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 7a 45 00 00       	call   80104ae0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 d5 44 00 00       	call   80104a50 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 c5 76 10 80       	push   $0x801076c5
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 bc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005cb:	e8 80 43 00 00       	call   80104950 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ff 10 80       	push   $0x8010ff20
80100604:	e8 e7 42 00 00       	call   801048f0 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 8e 11 00 00       	call   801017a0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 90 7b 10 80 	movzbl -0x7fef8470(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ff 10 80    	mov    0x8010ff54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ff 10 80       	push   $0x8010ff20
801007d8:	e8 73 41 00 00       	call   80104950 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ff 10 80       	push   $0x8010ff20
801007fb:	e8 f0 40 00 00       	call   801048f0 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf d8 76 10 80       	mov    $0x801076d8,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 df 76 10 80       	push   $0x801076df
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 ff 10 80       	push   $0x8010ff20
801008b3:	e8 98 40 00 00       	call   80104950 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 22                	js     801008e5 <consoleintr+0x45>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 47                	je     8010090f <consoleintr+0x6f>
801008c8:	7f 76                	jg     80100940 <consoleintr+0xa0>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	74 76                	je     80100945 <consoleintr+0xa5>
801008cf:	83 fb 10             	cmp    $0x10,%ebx
801008d2:	0f 85 f8 00 00 00    	jne    801009d0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008d8:	ff d6                	call   *%esi
    switch(c){
801008da:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008df:	89 c3                	mov    %eax,%ebx
801008e1:	85 c0                	test   %eax,%eax
801008e3:	79 de                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e5:	83 ec 0c             	sub    $0xc,%esp
801008e8:	68 20 ff 10 80       	push   $0x8010ff20
801008ed:	e8 fe 3f 00 00       	call   801048f0 <release>
  if(doprocdump) {
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	85 ff                	test   %edi,%edi
801008f7:	0f 85 4b 01 00 00    	jne    80100a48 <consoleintr+0x1a8>
}
801008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100900:	5b                   	pop    %ebx
80100901:	5e                   	pop    %esi
80100902:	5f                   	pop    %edi
80100903:	5d                   	pop    %ebp
80100904:	c3                   	ret
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 f1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010090f:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100914:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010091a:	74 9f                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100924:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
8010092b:	74 8e                	je     801008bb <consoleintr+0x1b>
  if(panicked){
8010092d:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
80100933:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100938:	85 d2                	test   %edx,%edx
8010093a:	74 c9                	je     80100905 <consoleintr+0x65>
8010093c:	fa                   	cli
    for(;;)
8010093d:	eb fe                	jmp    8010093d <consoleintr+0x9d>
8010093f:	90                   	nop
    switch(c){
80100940:	83 fb 7f             	cmp    $0x7f,%ebx
80100943:	75 2b                	jne    80100970 <consoleintr+0xd0>
      if(input.e != input.w){
80100945:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010094a:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100950:	0f 84 65 ff ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
80100956:	83 e8 01             	sub    $0x1,%eax
80100959:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
8010095e:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100963:	85 c0                	test   %eax,%eax
80100965:	0f 84 ce 00 00 00    	je     80100a39 <consoleintr+0x199>
8010096b:	fa                   	cli
    for(;;)
8010096c:	eb fe                	jmp    8010096c <consoleintr+0xcc>
8010096e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100970:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100975:	89 c2                	mov    %eax,%edx
80100977:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
8010097d:	83 fa 7f             	cmp    $0x7f,%edx
80100980:	0f 87 35 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100986:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100998:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
8010099e:	85 c9                	test   %ecx,%ecx
801009a0:	0f 85 ae 00 00 00    	jne    80100a54 <consoleintr+0x1b4>
801009a6:	89 d8                	mov    %ebx,%eax
801009a8:	e8 53 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ad:	83 fb 0a             	cmp    $0xa,%ebx
801009b0:	74 68                	je     80100a1a <consoleintr+0x17a>
801009b2:	83 fb 04             	cmp    $0x4,%ebx
801009b5:	74 63                	je     80100a1a <consoleintr+0x17a>
801009b7:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801009bc:	83 e8 80             	sub    $0xffffff80,%eax
801009bf:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
801009c5:	0f 85 f0 fe ff ff    	jne    801008bb <consoleintr+0x1b>
801009cb:	eb 52                	jmp    80100a1f <consoleintr+0x17f>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009d0:	85 db                	test   %ebx,%ebx
801009d2:	0f 84 e3 fe ff ff    	je     801008bb <consoleintr+0x1b>
801009d8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009dd:	89 c2                	mov    %eax,%edx
801009df:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801009e5:	83 fa 7f             	cmp    $0x7f,%edx
801009e8:	0f 87 cd fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009f1:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009f7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009fa:	83 fb 0d             	cmp    $0xd,%ebx
801009fd:	75 93                	jne    80100992 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ff:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100a05:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	75 44                	jne    80100a54 <consoleintr+0x1b4>
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 e6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a1a:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a27:	68 00 ff 10 80       	push   $0x8010ff00
80100a2c:	e8 bf 37 00 00       	call   801041f0 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 82 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a39:	b8 00 01 00 00       	mov    $0x100,%eax
80100a3e:	e8 bd f9 ff ff       	call   80100400 <consputc.part.0>
80100a43:	e9 73 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
}
80100a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4b:	5b                   	pop    %ebx
80100a4c:	5e                   	pop    %esi
80100a4d:	5f                   	pop    %edi
80100a4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a4f:	e9 7c 38 00 00       	jmp    801042d0 <procdump>
80100a54:	fa                   	cli
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <consoleintr+0x1b5>
80100a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a5e:	00 
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 e8 76 10 80       	push   $0x801076e8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 eb 3c 00 00       	call   80104760 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 b0 	movl   $0x801005b0,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 c2 19 00 00       	call   80102460 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 df 2e 00 00       	call   801039a0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 74 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 a9 15 00 00       	call   80102080 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 30 03 00 00    	je     80100e12 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c7                	mov    %eax,%edi
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	57                   	push   %edi
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	0f 85 01 01 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b0a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b11:	45 4c 46 
80100b14:	0f 85 f1 00 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b1a:	e8 11 68 00 00       	call   80107330 <setupkvm>
80100b1f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b25:	85 c0                	test   %eax,%eax
80100b27:	0f 84 de 00 00 00    	je     80100c0b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b2d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b34:	00 
80100b35:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b3b:	0f 84 a1 02 00 00    	je     80100de2 <exec+0x332>
  sz = 0;
80100b41:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b48:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4b:	31 db                	xor    %ebx,%ebx
80100b4d:	e9 8c 00 00 00       	jmp    80100bde <exec+0x12e>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b5f:	75 6c                	jne    80100bcd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b6d:	0f 82 87 00 00 00    	jb     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b79:	72 7f                	jb     80100bfa <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b7b:	83 ec 04             	sub    $0x4,%esp
80100b7e:	50                   	push   %eax
80100b7f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b85:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b8b:	e8 d0 65 00 00       	call   80107160 <allocuvm>
80100b90:	83 c4 10             	add    $0x10,%esp
80100b93:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	74 5d                	je     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b9d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ba3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba8:	75 50                	jne    80100bfa <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100baa:	83 ec 0c             	sub    $0xc,%esp
80100bad:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bb3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bb9:	57                   	push   %edi
80100bba:	50                   	push   %eax
80100bbb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bc1:	e8 ca 64 00 00       	call   80107090 <loaduvm>
80100bc6:	83 c4 20             	add    $0x20,%esp
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	78 2d                	js     80100bfa <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bcd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bd4:	83 c3 01             	add    $0x1,%ebx
80100bd7:	83 c6 20             	add    $0x20,%esi
80100bda:	39 d8                	cmp    %ebx,%eax
80100bdc:	7e 52                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bde:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100be4:	6a 20                	push   $0x20
80100be6:	56                   	push   %esi
80100be7:	50                   	push   %eax
80100be8:	57                   	push   %edi
80100be9:	e8 c2 0e 00 00       	call   80101ab0 <readi>
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	83 f8 20             	cmp    $0x20,%eax
80100bf4:	0f 84 5e ff ff ff    	je     80100b58 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bfa:	83 ec 0c             	sub    $0xc,%esp
80100bfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c03:	e8 a8 66 00 00       	call   801072b0 <freevm>
  if(ip){
80100c08:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c0b:	83 ec 0c             	sub    $0xc,%esp
80100c0e:	57                   	push   %edi
80100c0f:	e8 1c 0e 00 00       	call   80101a30 <iunlockput>
    end_op();
80100c14:	e8 97 21 00 00       	call   80102db0 <end_op>
80100c19:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c24:	5b                   	pop    %ebx
80100c25:	5e                   	pop    %esi
80100c26:	5f                   	pop    %edi
80100c27:	5d                   	pop    %ebp
80100c28:	c3                   	ret
80100c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c30:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c36:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	57                   	push   %edi
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 5a 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	53                   	push   %ebx
80100c5a:	56                   	push   %esi
80100c5b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c61:	56                   	push   %esi
80100c62:	e8 f9 64 00 00       	call   80107160 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c7                	mov    %eax,%edi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 86 00 00 00    	je     80100cfa <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100c7d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 48 67 00 00       	call   801073d0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8b 10                	mov    (%eax),%edx
80100c90:	85 d2                	test   %edx,%edx
80100c92:	0f 84 56 01 00 00    	je     80100dee <exec+0x33e>
80100c98:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ca1:	eb 23                	jmp    80100cc6 <exec+0x216>
80100ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ca8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cab:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cb2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cbb:	85 d2                	test   %edx,%edx
80100cbd:	74 51                	je     80100d10 <exec+0x260>
    if(argc >= MAXARG)
80100cbf:	83 f8 20             	cmp    $0x20,%eax
80100cc2:	74 36                	je     80100cfa <exec+0x24a>
80100cc4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc6:	83 ec 0c             	sub    $0xc,%esp
80100cc9:	52                   	push   %edx
80100cca:	e8 71 3f 00 00       	call   80104c40 <strlen>
80100ccf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd1:	58                   	pop    %eax
80100cd2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 eb 01             	sub    $0x1,%ebx
80100cd8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cdb:	e8 60 3f 00 00       	call   80104c40 <strlen>
80100ce0:	83 c0 01             	add    $0x1,%eax
80100ce3:	50                   	push   %eax
80100ce4:	ff 34 b7             	push   (%edi,%esi,4)
80100ce7:	53                   	push   %ebx
80100ce8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cee:	e8 ad 68 00 00       	call   801075a0 <copyout>
80100cf3:	83 c4 20             	add    $0x20,%esp
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	79 ae                	jns    80100ca8 <exec+0x1f8>
    freevm(pgdir);
80100cfa:	83 ec 0c             	sub    $0xc,%esp
80100cfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d03:	e8 a8 65 00 00       	call   801072b0 <freevm>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	e9 0c ff ff ff       	jmp    80100c1c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d10:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d17:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d1d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d23:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d26:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d29:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d30:	00 00 00 00 
  ustack[1] = argc;
80100d34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d3a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d41:	ff ff ff 
  ustack[1] = argc;
80100d44:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d4c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4e:	29 d0                	sub    %edx,%eax
80100d50:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d56:	56                   	push   %esi
80100d57:	51                   	push   %ecx
80100d58:	53                   	push   %ebx
80100d59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d5f:	e8 3c 68 00 00       	call   801075a0 <copyout>
80100d64:	83 c4 10             	add    $0x10,%esp
80100d67:	85 c0                	test   %eax,%eax
80100d69:	78 8f                	js     80100cfa <exec+0x24a>
  for(last=s=path; *s; s++)
80100d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d6e:	8b 55 08             	mov    0x8(%ebp),%edx
80100d71:	0f b6 00             	movzbl (%eax),%eax
80100d74:	84 c0                	test   %al,%al
80100d76:	74 17                	je     80100d8f <exec+0x2df>
80100d78:	89 d1                	mov    %edx,%ecx
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	83 ec 04             	sub    $0x4,%esp
80100d92:	6a 10                	push   $0x10
80100d94:	52                   	push   %edx
80100d95:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100d9b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d9e:	50                   	push   %eax
80100d9f:	e8 5c 3e 00 00       	call   80104c00 <safestrcpy>
  curproc->pgdir = pgdir;
80100da4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100daa:	89 f0                	mov    %esi,%eax
80100dac:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100daf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100db1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db4:	89 c1                	mov    %eax,%ecx
80100db6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbc:	8b 40 18             	mov    0x18(%eax),%eax
80100dbf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc2:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dc8:	89 0c 24             	mov    %ecx,(%esp)
80100dcb:	e8 30 61 00 00       	call   80106f00 <switchuvm>
  freevm(oldpgdir);
80100dd0:	89 34 24             	mov    %esi,(%esp)
80100dd3:	e8 d8 64 00 00       	call   801072b0 <freevm>
  return 0;
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	31 c0                	xor    %eax,%eax
80100ddd:	e9 3f fe ff ff       	jmp    80100c21 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de2:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100de7:	31 f6                	xor    %esi,%esi
80100de9:	e9 5a fe ff ff       	jmp    80100c48 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100dee:	be 10 00 00 00       	mov    $0x10,%esi
80100df3:	ba 04 00 00 00       	mov    $0x4,%edx
80100df8:	b8 03 00 00 00       	mov    $0x3,%eax
80100dfd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e04:	00 00 00 
80100e07:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e0d:	e9 17 ff ff ff       	jmp    80100d29 <exec+0x279>
    end_op();
80100e12:	e8 99 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100e17:	83 ec 0c             	sub    $0xc,%esp
80100e1a:	68 f0 76 10 80       	push   $0x801076f0
80100e1f:	e8 8c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e24:	83 c4 10             	add    $0x10,%esp
80100e27:	e9 f0 fd ff ff       	jmp    80100c1c <exec+0x16c>
80100e2c:	66 90                	xchg   %ax,%ax
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e36:	68 fc 76 10 80       	push   $0x801076fc
80100e3b:	68 60 ff 10 80       	push   $0x8010ff60
80100e40:	e8 1b 39 00 00       	call   80104760 <initlock>
}
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	c9                   	leave
80100e49:	c3                   	ret
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e5c:	68 60 ff 10 80       	push   $0x8010ff60
80100e61:	e8 ea 3a 00 00       	call   80104950 <acquire>
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	eb 10                	jmp    80100e7b <filealloc+0x2b>
80100e6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e79:	74 25                	je     80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 60 ff 10 80       	push   $0x8010ff60
80100e91:	e8 5a 3a 00 00       	call   801048f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e96:	89 d8                	mov    %ebx,%eax
      return f;
80100e98:	83 c4 10             	add    $0x10,%esp
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave
80100e9f:	c3                   	ret
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ea3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ea5:	68 60 ff 10 80       	push   $0x8010ff60
80100eaa:	e8 41 3a 00 00       	call   801048f0 <release>
}
80100eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80100eb1:	83 c4 10             	add    $0x10,%esp
}
80100eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb7:	c9                   	leave
80100eb8:	c3                   	ret
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 10             	sub    $0x10,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eca:	68 60 ff 10 80       	push   $0x8010ff60
80100ecf:	e8 7c 3a 00 00       	call   80104950 <acquire>
  if(f->ref < 1)
80100ed4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 1a                	jle    80100ef8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ede:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ee4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ee7:	68 60 ff 10 80       	push   $0x8010ff60
80100eec:	e8 ff 39 00 00       	call   801048f0 <release>
  return f;
}
80100ef1:	89 d8                	mov    %ebx,%eax
80100ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef6:	c9                   	leave
80100ef7:	c3                   	ret
    panic("filedup");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 03 77 10 80       	push   $0x80107703
80100f00:	e8 7b f4 ff ff       	call   80100380 <panic>
80100f05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f0c:	00 
80100f0d:	8d 76 00             	lea    0x0(%esi),%esi

80100f10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 28             	sub    $0x28,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f1c:	68 60 ff 10 80       	push   $0x8010ff60
80100f21:	e8 2a 3a 00 00       	call   80104950 <acquire>
  if(f->ref < 1)
80100f26:	8b 53 04             	mov    0x4(%ebx),%edx
80100f29:	83 c4 10             	add    $0x10,%esp
80100f2c:	85 d2                	test   %edx,%edx
80100f2e:	0f 8e a5 00 00 00    	jle    80100fd9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f34:	83 ea 01             	sub    $0x1,%edx
80100f37:	89 53 04             	mov    %edx,0x4(%ebx)
80100f3a:	75 44                	jne    80100f80 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f3c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f40:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f43:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f4e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f51:	8b 43 10             	mov    0x10(%ebx),%eax
80100f54:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f57:	68 60 ff 10 80       	push   $0x8010ff60
80100f5c:	e8 8f 39 00 00       	call   801048f0 <release>

  if(ff.type == FD_PIPE)
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	83 ff 01             	cmp    $0x1,%edi
80100f67:	74 57                	je     80100fc0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f69:	83 ff 02             	cmp    $0x2,%edi
80100f6c:	74 2a                	je     80100f98 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f71:	5b                   	pop    %ebx
80100f72:	5e                   	pop    %esi
80100f73:	5f                   	pop    %edi
80100f74:	5d                   	pop    %ebp
80100f75:	c3                   	ret
80100f76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f7d:	00 
80100f7e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100f80:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8a:	5b                   	pop    %ebx
80100f8b:	5e                   	pop    %esi
80100f8c:	5f                   	pop    %edi
80100f8d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f8e:	e9 5d 39 00 00       	jmp    801048f0 <release>
80100f93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100f98:	e8 a3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f9d:	83 ec 0c             	sub    $0xc,%esp
80100fa0:	ff 75 e0             	push   -0x20(%ebp)
80100fa3:	e8 28 09 00 00       	call   801018d0 <iput>
    end_op();
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fae:	5b                   	pop    %ebx
80100faf:	5e                   	pop    %esi
80100fb0:	5f                   	pop    %edi
80100fb1:	5d                   	pop    %ebp
    end_op();
80100fb2:	e9 f9 1d 00 00       	jmp    80102db0 <end_op>
80100fb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fbe:	00 
80100fbf:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fc0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fc4:	83 ec 08             	sub    $0x8,%esp
80100fc7:	53                   	push   %ebx
80100fc8:	56                   	push   %esi
80100fc9:	e8 32 25 00 00       	call   80103500 <pipeclose>
80100fce:	83 c4 10             	add    $0x10,%esp
}
80100fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd4:	5b                   	pop    %ebx
80100fd5:	5e                   	pop    %esi
80100fd6:	5f                   	pop    %edi
80100fd7:	5d                   	pop    %ebp
80100fd8:	c3                   	ret
    panic("fileclose");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 0b 77 10 80       	push   $0x8010770b
80100fe1:	e8 9a f3 ff ff       	call   80100380 <panic>
80100fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fed:	00 
80100fee:	66 90                	xchg   %ax,%ax

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 04             	sub    $0x4,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ffd:	75 31                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	ff 73 10             	push   0x10(%ebx)
80101005:	e8 96 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
8010100a:	58                   	pop    %eax
8010100b:	5a                   	pop    %edx
8010100c:	ff 75 0c             	push   0xc(%ebp)
8010100f:	ff 73 10             	push   0x10(%ebx)
80101012:	e8 69 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80101017:	59                   	pop    %ecx
80101018:	ff 73 10             	push   0x10(%ebx)
8010101b:	e8 60 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101023:	83 c4 10             	add    $0x10,%esp
80101026:	31 c0                	xor    %eax,%eax
}
80101028:	c9                   	leave
80101029:	c3                   	ret
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101038:	c9                   	leave
80101039:	c3                   	ret
8010103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010104c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010104f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101052:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101056:	74 60                	je     801010b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101058:	8b 03                	mov    (%ebx),%eax
8010105a:	83 f8 01             	cmp    $0x1,%eax
8010105d:	74 41                	je     801010a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105f:	83 f8 02             	cmp    $0x2,%eax
80101062:	75 5b                	jne    801010bf <fileread+0x7f>
    ilock(f->ip);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	ff 73 10             	push   0x10(%ebx)
8010106a:	e8 31 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010106f:	57                   	push   %edi
80101070:	ff 73 14             	push   0x14(%ebx)
80101073:	56                   	push   %esi
80101074:	ff 73 10             	push   0x10(%ebx)
80101077:	e8 34 0a 00 00       	call   80101ab0 <readi>
8010107c:	83 c4 20             	add    $0x20,%esp
8010107f:	89 c6                	mov    %eax,%esi
80101081:	85 c0                	test   %eax,%eax
80101083:	7e 03                	jle    80101088 <fileread+0x48>
      f->off += r;
80101085:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101088:	83 ec 0c             	sub    $0xc,%esp
8010108b:	ff 73 10             	push   0x10(%ebx)
8010108e:	e8 ed 07 00 00       	call   80101880 <iunlock>
    return r;
80101093:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	89 f0                	mov    %esi,%eax
8010109b:	5b                   	pop    %ebx
8010109c:	5e                   	pop    %esi
8010109d:	5f                   	pop    %edi
8010109e:	5d                   	pop    %ebp
8010109f:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a9:	5b                   	pop    %ebx
801010aa:	5e                   	pop    %esi
801010ab:	5f                   	pop    %edi
801010ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ad:	e9 0e 26 00 00       	jmp    801036c0 <piperead>
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010bd:	eb d7                	jmp    80101096 <fileread+0x56>
  panic("fileread");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 15 77 10 80       	push   $0x80107715
801010c7:	e8 b4 f2 ff ff       	call   80100380 <panic>
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
801010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010e5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ec:	0f 84 bb 00 00 00    	je     801011ad <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010f2:	8b 03                	mov    (%ebx),%eax
801010f4:	83 f8 01             	cmp    $0x1,%eax
801010f7:	0f 84 bf 00 00 00    	je     801011bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	0f 85 c8 00 00 00    	jne    801011ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101109:	31 f6                	xor    %esi,%esi
    while(i < n){
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 30                	jg     8010113f <filewrite+0x6f>
8010110f:	e9 94 00 00 00       	jmp    801011a8 <filewrite+0xd8>
80101114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101118:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010111e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101121:	ff 73 10             	push   0x10(%ebx)
80101124:	e8 57 07 00 00       	call   80101880 <iunlock>
      end_op();
80101129:	e8 82 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	39 c7                	cmp    %eax,%edi
80101136:	75 5c                	jne    80101194 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101138:	01 fe                	add    %edi,%esi
    while(i < n){
8010113a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010113d:	7e 69                	jle    801011a8 <filewrite+0xd8>
      int n1 = n - i;
8010113f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101142:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101147:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101149:	39 c7                	cmp    %eax,%edi
8010114b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010114e:	e8 ed 1b 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 73 10             	push   0x10(%ebx)
80101159:	e8 42 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010115e:	57                   	push   %edi
8010115f:	ff 73 14             	push   0x14(%ebx)
80101162:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101165:	01 f0                	add    %esi,%eax
80101167:	50                   	push   %eax
80101168:	ff 73 10             	push   0x10(%ebx)
8010116b:	e8 40 0a 00 00       	call   80101bb0 <writei>
80101170:	83 c4 20             	add    $0x20,%esp
80101173:	85 c0                	test   %eax,%eax
80101175:	7f a1                	jg     80101118 <filewrite+0x48>
80101177:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010117a:	83 ec 0c             	sub    $0xc,%esp
8010117d:	ff 73 10             	push   0x10(%ebx)
80101180:	e8 fb 06 00 00       	call   80101880 <iunlock>
      end_op();
80101185:	e8 26 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
8010118a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	85 c0                	test   %eax,%eax
80101192:	75 14                	jne    801011a8 <filewrite+0xd8>
        panic("short filewrite");
80101194:	83 ec 0c             	sub    $0xc,%esp
80101197:	68 1e 77 10 80       	push   $0x8010771e
8010119c:	e8 df f1 ff ff       	call   80100380 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ab:	74 05                	je     801011b2 <filewrite+0xe2>
801011ad:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	89 f0                	mov    %esi,%eax
801011b7:	5b                   	pop    %ebx
801011b8:	5e                   	pop    %esi
801011b9:	5f                   	pop    %edi
801011ba:	5d                   	pop    %ebp
801011bb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011bc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c5:	5b                   	pop    %ebx
801011c6:	5e                   	pop    %esi
801011c7:	5f                   	pop    %edi
801011c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011c9:	e9 d2 23 00 00       	jmp    801035a0 <pipewrite>
  panic("filewrite");
801011ce:	83 ec 0c             	sub    $0xc,%esp
801011d1:	68 24 77 10 80       	push   $0x80107724
801011d6:	e8 a5 f1 ff ff       	call   80100380 <panic>
801011db:	66 90                	xchg   %ax,%ax
801011dd:	66 90                	xchg   %ax,%ax
801011df:	90                   	nop

801011e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011e9:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
801011ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011f2:	85 c9                	test   %ecx,%ecx
801011f4:	0f 84 8c 00 00 00    	je     80101286 <balloc+0xa6>
801011fa:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801011fc:	89 f8                	mov    %edi,%eax
801011fe:	83 ec 08             	sub    $0x8,%esp
80101201:	89 fe                	mov    %edi,%esi
80101203:	c1 f8 0c             	sar    $0xc,%eax
80101206:	03 05 cc 25 11 80    	add    0x801125cc,%eax
8010120c:	50                   	push   %eax
8010120d:	ff 75 dc             	push   -0x24(%ebp)
80101210:	e8 bb ee ff ff       	call   801000d0 <bread>
80101215:	83 c4 10             	add    $0x10,%esp
80101218:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010121b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121e:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101223:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101226:	31 c0                	xor    %eax,%eax
80101228:	eb 32                	jmp    8010125c <balloc+0x7c>
8010122a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101230:	89 c1                	mov    %eax,%ecx
80101232:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101237:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010123a:	83 e1 07             	and    $0x7,%ecx
8010123d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010123f:	89 c1                	mov    %eax,%ecx
80101241:	c1 f9 03             	sar    $0x3,%ecx
80101244:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101249:	89 fa                	mov    %edi,%edx
8010124b:	85 df                	test   %ebx,%edi
8010124d:	74 49                	je     80101298 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124f:	83 c0 01             	add    $0x1,%eax
80101252:	83 c6 01             	add    $0x1,%esi
80101255:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010125a:	74 07                	je     80101263 <balloc+0x83>
8010125c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010125f:	39 d6                	cmp    %edx,%esi
80101261:	72 cd                	jb     80101230 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101263:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101266:	83 ec 0c             	sub    $0xc,%esp
80101269:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010126c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101272:	e8 79 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101277:	83 c4 10             	add    $0x10,%esp
8010127a:	3b 3d b4 25 11 80    	cmp    0x801125b4,%edi
80101280:	0f 82 76 ff ff ff    	jb     801011fc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101286:	83 ec 0c             	sub    $0xc,%esp
80101289:	68 2e 77 10 80       	push   $0x8010772e
8010128e:	e8 ed f0 ff ff       	call   80100380 <panic>
80101293:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101298:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010129b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010129e:	09 da                	or     %ebx,%edx
801012a0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012a4:	57                   	push   %edi
801012a5:	e8 76 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
801012aa:	89 3c 24             	mov    %edi,(%esp)
801012ad:	e8 3e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012b2:	58                   	pop    %eax
801012b3:	5a                   	pop    %edx
801012b4:	56                   	push   %esi
801012b5:	ff 75 dc             	push   -0x24(%ebp)
801012b8:	e8 13 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012bd:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012c0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012c2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012c5:	68 00 02 00 00       	push   $0x200
801012ca:	6a 00                	push   $0x0
801012cc:	50                   	push   %eax
801012cd:	e8 7e 37 00 00       	call   80104a50 <memset>
  log_write(bp);
801012d2:	89 1c 24             	mov    %ebx,(%esp)
801012d5:	e8 46 1c 00 00       	call   80102f20 <log_write>
  brelse(bp);
801012da:	89 1c 24             	mov    %ebx,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
}
801012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e5:	89 f0                	mov    %esi,%eax
801012e7:	5b                   	pop    %ebx
801012e8:	5e                   	pop    %esi
801012e9:	5f                   	pop    %edi
801012ea:	5d                   	pop    %ebp
801012eb:	c3                   	ret
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012f4:	31 ff                	xor    %edi,%edi
{
801012f6:	56                   	push   %esi
801012f7:	89 c6                	mov    %eax,%esi
801012f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801012ff:	83 ec 28             	sub    $0x28,%esp
80101302:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101305:	68 60 09 11 80       	push   $0x80110960
8010130a:	e8 41 36 00 00       	call   80104950 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101312:	83 c4 10             	add    $0x10,%esp
80101315:	eb 1b                	jmp    80101332 <iget+0x42>
80101317:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010131e:	00 
8010131f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101320:	39 33                	cmp    %esi,(%ebx)
80101322:	74 6c                	je     80101390 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101324:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010132a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101330:	74 26                	je     80101358 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101332:	8b 43 08             	mov    0x8(%ebx),%eax
80101335:	85 c0                	test   %eax,%eax
80101337:	7f e7                	jg     80101320 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101339:	85 ff                	test   %edi,%edi
8010133b:	75 e7                	jne    80101324 <iget+0x34>
8010133d:	85 c0                	test   %eax,%eax
8010133f:	75 76                	jne    801013b7 <iget+0xc7>
      empty = ip;
80101341:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101343:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101349:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010134f:	75 e1                	jne    80101332 <iget+0x42>
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101358:	85 ff                	test   %edi,%edi
8010135a:	74 79                	je     801013d5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010135c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010135f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101361:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101364:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010136b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101372:	68 60 09 11 80       	push   $0x80110960
80101377:	e8 74 35 00 00       	call   801048f0 <release>

  return ip;
8010137c:	83 c4 10             	add    $0x10,%esp
}
8010137f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101382:	89 f8                	mov    %edi,%eax
80101384:	5b                   	pop    %ebx
80101385:	5e                   	pop    %esi
80101386:	5f                   	pop    %edi
80101387:	5d                   	pop    %ebp
80101388:	c3                   	ret
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 53 04             	cmp    %edx,0x4(%ebx)
80101393:	75 8f                	jne    80101324 <iget+0x34>
      ip->ref++;
80101395:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101398:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010139b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010139d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013a0:	68 60 09 11 80       	push   $0x80110960
801013a5:	e8 46 35 00 00       	call   801048f0 <release>
      return ip;
801013aa:	83 c4 10             	add    $0x10,%esp
}
801013ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b0:	89 f8                	mov    %edi,%eax
801013b2:	5b                   	pop    %ebx
801013b3:	5e                   	pop    %esi
801013b4:	5f                   	pop    %edi
801013b5:	5d                   	pop    %ebp
801013b6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013bd:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013c3:	74 10                	je     801013d5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c5:	8b 43 08             	mov    0x8(%ebx),%eax
801013c8:	85 c0                	test   %eax,%eax
801013ca:	0f 8f 50 ff ff ff    	jg     80101320 <iget+0x30>
801013d0:	e9 68 ff ff ff       	jmp    8010133d <iget+0x4d>
    panic("iget: no inodes");
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	68 44 77 10 80       	push   $0x80107744
801013dd:	e8 9e ef ff ff       	call   80100380 <panic>
801013e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013e9:	00 
801013ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013f0 <bfree>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801013f3:	89 d0                	mov    %edx,%eax
801013f5:	c1 e8 0c             	shr    $0xc,%eax
{
801013f8:	89 e5                	mov    %esp,%ebp
801013fa:	56                   	push   %esi
801013fb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801013fc:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
80101402:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101404:	83 ec 08             	sub    $0x8,%esp
80101407:	50                   	push   %eax
80101408:	51                   	push   %ecx
80101409:	e8 c2 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010140e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101410:	c1 fb 03             	sar    $0x3,%ebx
80101413:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101416:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101418:	83 e1 07             	and    $0x7,%ecx
8010141b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101420:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101426:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101428:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010142d:	85 c1                	test   %eax,%ecx
8010142f:	74 23                	je     80101454 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101431:	f7 d0                	not    %eax
  log_write(bp);
80101433:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101436:	21 c8                	and    %ecx,%eax
80101438:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010143c:	56                   	push   %esi
8010143d:	e8 de 1a 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101442:	89 34 24             	mov    %esi,(%esp)
80101445:	e8 a6 ed ff ff       	call   801001f0 <brelse>
}
8010144a:	83 c4 10             	add    $0x10,%esp
8010144d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101450:	5b                   	pop    %ebx
80101451:	5e                   	pop    %esi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret
    panic("freeing free block");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 54 77 10 80       	push   $0x80107754
8010145c:	e8 1f ef ff ff       	call   80100380 <panic>
80101461:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101468:	00 
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101470 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	89 c6                	mov    %eax,%esi
80101477:	53                   	push   %ebx
80101478:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010147b:	83 fa 0b             	cmp    $0xb,%edx
8010147e:	0f 86 8c 00 00 00    	jbe    80101510 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101484:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101487:	83 fb 7f             	cmp    $0x7f,%ebx
8010148a:	0f 87 a2 00 00 00    	ja     80101532 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101490:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101496:	85 c0                	test   %eax,%eax
80101498:	74 5e                	je     801014f8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010149a:	83 ec 08             	sub    $0x8,%esp
8010149d:	50                   	push   %eax
8010149e:	ff 36                	push   (%esi)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014a5:	83 c4 10             	add    $0x10,%esp
801014a8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ac:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ae:	8b 3b                	mov    (%ebx),%edi
801014b0:	85 ff                	test   %edi,%edi
801014b2:	74 1c                	je     801014d0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	52                   	push   %edx
801014b8:	e8 33 ed ff ff       	call   801001f0 <brelse>
801014bd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c3:	89 f8                	mov    %edi,%eax
801014c5:	5b                   	pop    %ebx
801014c6:	5e                   	pop    %esi
801014c7:	5f                   	pop    %edi
801014c8:	5d                   	pop    %ebp
801014c9:	c3                   	ret
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014d3:	8b 06                	mov    (%esi),%eax
801014d5:	e8 06 fd ff ff       	call   801011e0 <balloc>
      log_write(bp);
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e0:	89 03                	mov    %eax,(%ebx)
801014e2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014e4:	52                   	push   %edx
801014e5:	e8 36 1a 00 00       	call   80102f20 <log_write>
801014ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	eb c2                	jmp    801014b4 <bmap+0x44>
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f8:	8b 06                	mov    (%esi),%eax
801014fa:	e8 e1 fc ff ff       	call   801011e0 <balloc>
801014ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101505:	eb 93                	jmp    8010149a <bmap+0x2a>
80101507:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010150e:	00 
8010150f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101510:	8d 5a 14             	lea    0x14(%edx),%ebx
80101513:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101517:	85 ff                	test   %edi,%edi
80101519:	75 a5                	jne    801014c0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010151b:	8b 00                	mov    (%eax),%eax
8010151d:	e8 be fc ff ff       	call   801011e0 <balloc>
80101522:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101526:	89 c7                	mov    %eax,%edi
}
80101528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152b:	5b                   	pop    %ebx
8010152c:	89 f8                	mov    %edi,%eax
8010152e:	5e                   	pop    %esi
8010152f:	5f                   	pop    %edi
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret
  panic("bmap: out of range");
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	68 67 77 10 80       	push   $0x80107767
8010153a:	e8 41 ee ff ff       	call   80100380 <panic>
8010153f:	90                   	nop

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	push   0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101555:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101558:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 7a 35 00 00       	call   80104ae0 <memmove>
  brelse(bp);
80101566:	83 c4 10             	add    $0x10,%esp
80101569:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 79 ec ff ff       	jmp    801001f0 <brelse>
80101577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157e:	00 
8010157f:	90                   	nop

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 7a 77 10 80       	push   $0x8010777a
80101591:	68 60 09 11 80       	push   $0x80110960
80101596:	e8 c5 31 00 00       	call   80104760 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 81 77 10 80       	push   $0x80107781
801015a8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015af:	e8 7c 30 00 00       	call   80104630 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  bp = bread(dev, 1);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	6a 01                	push   $0x1
801015c4:	ff 75 08             	push   0x8(%ebp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015cc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d4:	6a 1c                	push   $0x1c
801015d6:	50                   	push   %eax
801015d7:	68 b4 25 11 80       	push   $0x801125b4
801015dc:	e8 ff 34 00 00       	call   80104ae0 <memmove>
  brelse(bp);
801015e1:	89 1c 24             	mov    %ebx,(%esp)
801015e4:	e8 07 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e9:	ff 35 cc 25 11 80    	push   0x801125cc
801015ef:	ff 35 c8 25 11 80    	push   0x801125c8
801015f5:	ff 35 c4 25 11 80    	push   0x801125c4
801015fb:	ff 35 c0 25 11 80    	push   0x801125c0
80101601:	ff 35 bc 25 11 80    	push   0x801125bc
80101607:	ff 35 b8 25 11 80    	push   0x801125b8
8010160d:	ff 35 b4 25 11 80    	push   0x801125b4
80101613:	68 a4 7b 10 80       	push   $0x80107ba4
80101618:	e8 93 f0 ff ff       	call   801006b0 <cprintf>
}
8010161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101620:	83 c4 30             	add    $0x30,%esp
80101623:	c9                   	leave
80101624:	c3                   	ret
80101625:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010162c:	00 
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010165d:	00 
8010165e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	6a 40                	push   $0x40
801016a8:	6a 00                	push   $0x0
801016aa:	51                   	push   %ecx
801016ab:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016ae:	e8 9d 33 00 00       	call   80104a50 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 5b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 10 fc ff ff       	jmp    801012f0 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 87 77 10 80       	push   $0x80107787
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 8a 33 00 00       	call   80104ae0 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 c2 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
8010175e:	83 c4 10             	add    $0x10,%esp
80101761:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 09 11 80       	push   $0x80110960
8010177f:	e8 cc 31 00 00       	call   80104950 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010178f:	e8 5c 31 00 00       	call   801048f0 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave
8010179a:	c3                   	ret
8010179b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 a9 2e 00 00       	call   80104670 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret
801017d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017df:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 a3 32 00 00       	call   80104ae0 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 9f 77 10 80       	push   $0x8010779f
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 99 77 10 80       	push   $0x80107799
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010187b:	00 
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 78 2e 00 00       	call   80104710 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 1c 2e 00 00       	jmp    801046d0 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 ae 77 10 80       	push   $0x801077ae
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018c8:	00 
801018c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 8b 2d 00 00       	call   80104670 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 d1 2d 00 00       	call   801046d0 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101906:	e8 45 30 00 00       	call   80104950 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 cb 2f 00 00       	jmp    801048f0 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 09 11 80       	push   $0x80110960
80101930:	e8 1b 30 00 00       	call   80104950 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010193f:	e8 ac 2f 00 00       	call   801048f0 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 df                	mov    %ebx,%edi
8010195a:	89 cb                	mov    %ecx,%ebx
8010195c:	eb 09                	jmp    80101967 <iput+0x97>
8010195e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 de                	cmp    %ebx,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 07                	mov    (%edi),%eax
8010196f:	e8 7c fa ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	89 fb                	mov    %edi,%ebx
80101982:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101985:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010198b:	85 c0                	test   %eax,%eax
8010198d:	75 2d                	jne    801019bc <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101992:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101999:	53                   	push   %ebx
8010199a:	e8 51 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199f:	31 c0                	xor    %eax,%eax
801019a1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a5:	89 1c 24             	mov    %ebx,(%esp)
801019a8:	e8 43 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ad:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b4:	83 c4 10             	add    $0x10,%esp
801019b7:	e9 3a ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019bc:	83 ec 08             	sub    $0x8,%esp
801019bf:	50                   	push   %eax
801019c0:	ff 33                	push   (%ebx)
801019c2:	e8 09 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019c7:	83 c4 10             	add    $0x10,%esp
801019ca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019cd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019d6:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d9:	89 cf                	mov    %ecx,%edi
801019db:	eb 0a                	jmp    801019e7 <iput+0x117>
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 fe                	cmp    %edi,%esi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 fc f9 ff ff       	call   801013f0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019f9:	83 ec 0c             	sub    $0xc,%esp
801019fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ff:	50                   	push   %eax
80101a00:	e8 eb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a05:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0b:	8b 03                	mov    (%ebx),%eax
80101a0d:	e8 de f9 ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1c:	00 00 00 
80101a1f:	e9 6b ff ff ff       	jmp    8010198f <iput+0xbf>
80101a24:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a2b:	00 
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 c8 2c 00 00       	call   80104710 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 71 2c 00 00       	call   801046d0 <releasesleep>
  iput(ip);
80101a5f:	83 c4 10             	add    $0x10,%esp
80101a62:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 ae 77 10 80       	push   $0x801077ae
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret
80101aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 75 08             	mov    0x8(%ebp),%esi
80101abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101abf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101ac7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101aca:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101acd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101ad0:	0f 84 aa 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101ad9:	8b 56 58             	mov    0x58(%esi),%edx
80101adc:	39 fa                	cmp    %edi,%edx
80101ade:	0f 82 bd 00 00 00    	jb     80101ba1 <readi+0xf1>
80101ae4:	89 f9                	mov    %edi,%ecx
80101ae6:	31 db                	xor    %ebx,%ebx
80101ae8:	01 c1                	add    %eax,%ecx
80101aea:	0f 92 c3             	setb   %bl
80101aed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101af0:	0f 82 ab 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101af6:	89 d3                	mov    %edx,%ebx
80101af8:	29 fb                	sub    %edi,%ebx
80101afa:	39 ca                	cmp    %ecx,%edx
80101afc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	85 c0                	test   %eax,%eax
80101b01:	74 73                	je     80101b76 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 fa                	mov    %edi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 51 f9 ff ff       	call   80101470 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f8                	mov    %edi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 f3                	sub    %esi,%ebx
80101b3d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b43:	39 d9                	cmp    %ebx,%ecx
80101b45:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b48:	83 c4 0c             	add    $0xc,%esp
80101b4b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4c:	01 de                	add    %ebx,%esi
80101b4e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b50:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 84 2f 00 00       	call   80104ae0 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b6d:	83 c4 10             	add    $0x10,%esp
80101b70:	39 de                	cmp    %ebx,%esi
80101b72:	72 9c                	jb     80101b10 <readi+0x60>
80101b74:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b79:	5b                   	pop    %ebx
80101b7a:	5e                   	pop    %esi
80101b7b:	5f                   	pop    %edi
80101b7c:	5d                   	pop    %ebp
80101b7d:	c3                   	ret
80101b7e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101b84:	66 83 fa 09          	cmp    $0x9,%dx
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80101b91:	85 d2                	test   %edx,%edx
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e2                	jmp    *%edx
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb ce                	jmp    80101b76 <readi+0xc6>
80101ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101baf:	00 

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bbf:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bca:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bcd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101bd0:	0f 84 ba 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd6:	39 78 58             	cmp    %edi,0x58(%eax)
80101bd9:	0f 82 ea 00 00 00    	jb     80101cc9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bdf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101be2:	89 f2                	mov    %esi,%edx
80101be4:	01 fa                	add    %edi,%edx
80101be6:	0f 82 dd 00 00 00    	jb     80101cc9 <writei+0x119>
80101bec:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101bf2:	0f 87 d1 00 00 00    	ja     80101cc9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf8:	85 f6                	test   %esi,%esi
80101bfa:	0f 84 85 00 00 00    	je     80101c85 <writei+0xd5>
80101c00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c13:	89 fa                	mov    %edi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f0                	mov    %esi,%eax
80101c1a:	e8 51 f8 ff ff       	call   80101470 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 36                	push   (%esi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c2d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c30:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f8                	mov    %edi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 d3                	sub    %edx,%ebx
80101c40:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c42:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c46:	39 d9                	cmp    %ebx,%ecx
80101c48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c4b:	83 c4 0c             	add    $0xc,%esp
80101c4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c51:	ff 75 dc             	push   -0x24(%ebp)
80101c54:	50                   	push   %eax
80101c55:	e8 86 2e 00 00       	call   80104ae0 <memmove>
    log_write(bp);
80101c5a:	89 34 24             	mov    %esi,(%esp)
80101c5d:	e8 be 12 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101c62:	89 34 24             	mov    %esi,(%esp)
80101c65:	e8 86 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c6a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c70:	83 c4 10             	add    $0x10,%esp
80101c73:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c76:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c79:	39 d8                	cmp    %ebx,%eax
80101c7b:	72 93                	jb     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c80:	39 78 58             	cmp    %edi,0x58(%eax)
80101c83:	72 33                	jb     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
80101c8f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 2f                	ja     80101cc9 <writei+0x119>
80101c9a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 24                	je     80101cc9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101cb8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cbe:	50                   	push   %eax
80101cbf:	e8 2c fa ff ff       	call   801016f0 <iupdate>
80101cc4:	83 c4 10             	add    $0x10,%esp
80101cc7:	eb bc                	jmp    80101c85 <writei+0xd5>
      return -1;
80101cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cce:	eb b8                	jmp    80101c88 <writei+0xd8>

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 6d 2e 00 00       	call   80104b50 <strncmp>
}
80101ce3:	c9                   	leave
80101ce4:	c3                   	ret
80101ce5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cec:	00 
80101ced:	8d 76 00             	lea    0x0(%esi),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 8e fd ff ff       	call   80101ab0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 0e 2e 00 00       	call   80104b50 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret
80101d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 79 f5 ff ff       	call   801012f0 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 c8 77 10 80       	push   $0x801077c8
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 b6 77 10 80       	push   $0x801077b6
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 9e 01 00 00    	je     80101f58 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 e1 1b 00 00       	call   801039a0 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 09 11 80       	push   $0x80110960
80101dca:	e8 81 2b 00 00       	call   80104950 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dda:	e8 11 2b 00 00       	call   801048f0 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
80101e32:	89 fb                	mov    %edi,%ebx
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 a4 2c 00 00       	call   80104ae0 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 47 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 b7 00 00 00    	jne    80101f1e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 f7 00 00 00    	je     80101f6e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
80101e85:	83 c4 10             	add    $0x10,%esp
80101e88:	89 c7                	mov    %eax,%edi
80101e8a:	85 c0                	test   %eax,%eax
80101e8c:	0f 84 8c 00 00 00    	je     80101f1e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e92:	83 ec 0c             	sub    $0xc,%esp
80101e95:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101e98:	51                   	push   %ecx
80101e99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101e9c:	e8 6f 28 00 00       	call   80104710 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 02 01 00 00    	je     80101fae <namex+0x20e>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e f7 00 00 00    	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101eb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	51                   	push   %ecx
80101ebe:	e8 0d 28 00 00       	call   801046d0 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101ec6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101ec8:	e8 03 fa ff ff       	call   801018d0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101edb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 f0 2b 00 00       	call   80104ae0 <memmove>
    name[len] = 0;
80101ef0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 01 00             	movb   $0x0,(%ecx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 93 00 00 00    	jne    80101f9e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f1e:	83 ec 0c             	sub    $0xc,%esp
80101f21:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f24:	53                   	push   %ebx
80101f25:	e8 e6 27 00 00       	call   80104710 <holdingsleep>
80101f2a:	83 c4 10             	add    $0x10,%esp
80101f2d:	85 c0                	test   %eax,%eax
80101f2f:	74 7d                	je     80101fae <namex+0x20e>
80101f31:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f34:	85 c9                	test   %ecx,%ecx
80101f36:	7e 76                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f38:	83 ec 0c             	sub    $0xc,%esp
80101f3b:	53                   	push   %ebx
80101f3c:	e8 8f 27 00 00       	call   801046d0 <releasesleep>
  iput(ip);
80101f41:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f44:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f46:	e8 85 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f4b:	83 c4 10             	add    $0x10,%esp
}
80101f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f51:	89 f0                	mov    %esi,%eax
80101f53:	5b                   	pop    %ebx
80101f54:	5e                   	pop    %esi
80101f55:	5f                   	pop    %edi
80101f56:	5d                   	pop    %ebp
80101f57:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101f58:	ba 01 00 00 00       	mov    $0x1,%edx
80101f5d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f62:	e8 89 f3 ff ff       	call   801012f0 <iget>
80101f67:	89 c6                	mov    %eax,%esi
80101f69:	e9 7d fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f74:	53                   	push   %ebx
80101f75:	e8 96 27 00 00       	call   80104710 <holdingsleep>
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	85 c0                	test   %eax,%eax
80101f7f:	74 2d                	je     80101fae <namex+0x20e>
80101f81:	8b 7e 08             	mov    0x8(%esi),%edi
80101f84:	85 ff                	test   %edi,%edi
80101f86:	7e 26                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	53                   	push   %ebx
80101f8c:	e8 3f 27 00 00       	call   801046d0 <releasesleep>
}
80101f91:	83 c4 10             	add    $0x10,%esp
}
80101f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f97:	89 f0                	mov    %esi,%eax
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5f                   	pop    %edi
80101f9c:	5d                   	pop    %ebp
80101f9d:	c3                   	ret
    iput(ip);
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	56                   	push   %esi
      return 0;
80101fa2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fa4:	e8 27 f9 ff ff       	call   801018d0 <iput>
    return 0;
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	eb a0                	jmp    80101f4e <namex+0x1ae>
    panic("iunlock");
80101fae:	83 ec 0c             	sub    $0xc,%esp
80101fb1:	68 ae 77 10 80       	push   $0x801077ae
80101fb6:	e8 c5 e3 ff ff       	call   80100380 <panic>
80101fbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101fc0 <dirlink>:
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	83 ec 20             	sub    $0x20,%esp
80101fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fcc:	6a 00                	push   $0x0
80101fce:	ff 75 0c             	push   0xc(%ebp)
80101fd1:	53                   	push   %ebx
80101fd2:	e8 19 fd ff ff       	call   80101cf0 <dirlookup>
80101fd7:	83 c4 10             	add    $0x10,%esp
80101fda:	85 c0                	test   %eax,%eax
80101fdc:	75 67                	jne    80102045 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fde:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fe1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fe4:	85 ff                	test   %edi,%edi
80101fe6:	74 29                	je     80102011 <dirlink+0x51>
80101fe8:	31 ff                	xor    %edi,%edi
80101fea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fed:	eb 09                	jmp    80101ff8 <dirlink+0x38>
80101fef:	90                   	nop
80101ff0:	83 c7 10             	add    $0x10,%edi
80101ff3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ff6:	73 19                	jae    80102011 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff8:	6a 10                	push   $0x10
80101ffa:	57                   	push   %edi
80101ffb:	56                   	push   %esi
80101ffc:	53                   	push   %ebx
80101ffd:	e8 ae fa ff ff       	call   80101ab0 <readi>
80102002:	83 c4 10             	add    $0x10,%esp
80102005:	83 f8 10             	cmp    $0x10,%eax
80102008:	75 4e                	jne    80102058 <dirlink+0x98>
    if(de.inum == 0)
8010200a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010200f:	75 df                	jne    80101ff0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102011:	83 ec 04             	sub    $0x4,%esp
80102014:	8d 45 da             	lea    -0x26(%ebp),%eax
80102017:	6a 0e                	push   $0xe
80102019:	ff 75 0c             	push   0xc(%ebp)
8010201c:	50                   	push   %eax
8010201d:	e8 7e 2b 00 00       	call   80104ba0 <strncpy>
  de.inum = inum;
80102022:	8b 45 10             	mov    0x10(%ebp),%eax
80102025:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102029:	6a 10                	push   $0x10
8010202b:	57                   	push   %edi
8010202c:	56                   	push   %esi
8010202d:	53                   	push   %ebx
8010202e:	e8 7d fb ff ff       	call   80101bb0 <writei>
80102033:	83 c4 20             	add    $0x20,%esp
80102036:	83 f8 10             	cmp    $0x10,%eax
80102039:	75 2a                	jne    80102065 <dirlink+0xa5>
  return 0;
8010203b:	31 c0                	xor    %eax,%eax
}
8010203d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102040:	5b                   	pop    %ebx
80102041:	5e                   	pop    %esi
80102042:	5f                   	pop    %edi
80102043:	5d                   	pop    %ebp
80102044:	c3                   	ret
    iput(ip);
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	50                   	push   %eax
80102049:	e8 82 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010204e:	83 c4 10             	add    $0x10,%esp
80102051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102056:	eb e5                	jmp    8010203d <dirlink+0x7d>
      panic("dirlink read");
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	68 d7 77 10 80       	push   $0x801077d7
80102060:	e8 1b e3 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	68 42 7a 10 80       	push   $0x80107a42
8010206d:	e8 0e e3 ff ff       	call   80100380 <panic>
80102072:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102079:	00 
8010207a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102080 <namei>:

struct inode*
namei(char *path)
{
80102080:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102081:	31 d2                	xor    %edx,%edx
{
80102083:	89 e5                	mov    %esp,%ebp
80102085:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010208e:	e8 0d fd ff ff       	call   80101da0 <namex>
}
80102093:	c9                   	leave
80102094:	c3                   	ret
80102095:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010209c:	00 
8010209d:	8d 76 00             	lea    0x0(%esi),%esi

801020a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020a0:	55                   	push   %ebp
  return namex(path, 1, name);
801020a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020af:	e9 ec fc ff ff       	jmp    80101da0 <namex>
801020b4:	66 90                	xchg   %ax,%ax
801020b6:	66 90                	xchg   %ax,%ax
801020b8:	66 90                	xchg   %ax,%ax
801020ba:	66 90                	xchg   %ax,%ax
801020bc:	66 90                	xchg   %ax,%ax
801020be:	66 90                	xchg   %ax,%ax

801020c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020c9:	85 c0                	test   %eax,%eax
801020cb:	0f 84 b4 00 00 00    	je     80102185 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020d1:	8b 70 08             	mov    0x8(%eax),%esi
801020d4:	89 c3                	mov    %eax,%ebx
801020d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020dc:	0f 87 96 00 00 00    	ja     80102178 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020ee:	00 
801020ef:	90                   	nop
801020f0:	89 ca                	mov    %ecx,%edx
801020f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f3:	83 e0 c0             	and    $0xffffffc0,%eax
801020f6:	3c 40                	cmp    $0x40,%al
801020f8:	75 f6                	jne    801020f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020fa:	31 ff                	xor    %edi,%edi
801020fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102101:	89 f8                	mov    %edi,%eax
80102103:	ee                   	out    %al,(%dx)
80102104:	b8 01 00 00 00       	mov    $0x1,%eax
80102109:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010210e:	ee                   	out    %al,(%dx)
8010210f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102114:	89 f0                	mov    %esi,%eax
80102116:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102117:	89 f0                	mov    %esi,%eax
80102119:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010211e:	c1 f8 08             	sar    $0x8,%eax
80102121:	ee                   	out    %al,(%dx)
80102122:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102127:	89 f8                	mov    %edi,%eax
80102129:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010212a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010212e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102133:	c1 e0 04             	shl    $0x4,%eax
80102136:	83 e0 10             	and    $0x10,%eax
80102139:	83 c8 e0             	or     $0xffffffe0,%eax
8010213c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010213d:	f6 03 04             	testb  $0x4,(%ebx)
80102140:	75 16                	jne    80102158 <idestart+0x98>
80102142:	b8 20 00 00 00       	mov    $0x20,%eax
80102147:	89 ca                	mov    %ecx,%edx
80102149:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010214a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010214d:	5b                   	pop    %ebx
8010214e:	5e                   	pop    %esi
8010214f:	5f                   	pop    %edi
80102150:	5d                   	pop    %ebp
80102151:	c3                   	ret
80102152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102158:	b8 30 00 00 00       	mov    $0x30,%eax
8010215d:	89 ca                	mov    %ecx,%edx
8010215f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102160:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102165:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102168:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010216d:	fc                   	cld
8010216e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102173:	5b                   	pop    %ebx
80102174:	5e                   	pop    %esi
80102175:	5f                   	pop    %edi
80102176:	5d                   	pop    %ebp
80102177:	c3                   	ret
    panic("incorrect blockno");
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	68 ed 77 10 80       	push   $0x801077ed
80102180:	e8 fb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	68 e4 77 10 80       	push   $0x801077e4
8010218d:	e8 ee e1 ff ff       	call   80100380 <panic>
80102192:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102199:	00 
8010219a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021a0 <ideinit>:
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021a6:	68 ff 77 10 80       	push   $0x801077ff
801021ab:	68 00 26 11 80       	push   $0x80112600
801021b0:	e8 ab 25 00 00       	call   80104760 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021b5:	58                   	pop    %eax
801021b6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021bb:	5a                   	pop    %edx
801021bc:	83 e8 01             	sub    $0x1,%eax
801021bf:	50                   	push   %eax
801021c0:	6a 0e                	push   $0xe
801021c2:	e8 99 02 00 00       	call   80102460 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ca:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021cf:	90                   	nop
801021d0:	89 ca                	mov    %ecx,%edx
801021d2:	ec                   	in     (%dx),%al
801021d3:	83 e0 c0             	and    $0xffffffc0,%eax
801021d6:	3c 40                	cmp    $0x40,%al
801021d8:	75 f6                	jne    801021d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021df:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021e5:	89 ca                	mov    %ecx,%edx
801021e7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021e8:	84 c0                	test   %al,%al
801021ea:	75 1e                	jne    8010220a <ideinit+0x6a>
801021ec:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801021f1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021fd:	00 
801021fe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102200:	83 e9 01             	sub    $0x1,%ecx
80102203:	74 0f                	je     80102214 <ideinit+0x74>
80102205:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102206:	84 c0                	test   %al,%al
80102208:	74 f6                	je     80102200 <ideinit+0x60>
      havedisk1 = 1;
8010220a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102211:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102214:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102219:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010221e:	ee                   	out    %al,(%dx)
}
8010221f:	c9                   	leave
80102220:	c3                   	ret
80102221:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102228:	00 
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102230 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	57                   	push   %edi
80102234:	56                   	push   %esi
80102235:	53                   	push   %ebx
80102236:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102239:	68 00 26 11 80       	push   $0x80112600
8010223e:	e8 0d 27 00 00       	call   80104950 <acquire>

  if((b = idequeue) == 0){
80102243:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102249:	83 c4 10             	add    $0x10,%esp
8010224c:	85 db                	test   %ebx,%ebx
8010224e:	74 63                	je     801022b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102250:	8b 43 58             	mov    0x58(%ebx),%eax
80102253:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102258:	8b 33                	mov    (%ebx),%esi
8010225a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102260:	75 2f                	jne    80102291 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102262:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102267:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010226e:	00 
8010226f:	90                   	nop
80102270:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102271:	89 c1                	mov    %eax,%ecx
80102273:	83 e1 c0             	and    $0xffffffc0,%ecx
80102276:	80 f9 40             	cmp    $0x40,%cl
80102279:	75 f5                	jne    80102270 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010227b:	a8 21                	test   $0x21,%al
8010227d:	75 12                	jne    80102291 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010227f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102282:	b9 80 00 00 00       	mov    $0x80,%ecx
80102287:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010228c:	fc                   	cld
8010228d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010228f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102291:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102294:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102297:	83 ce 02             	or     $0x2,%esi
8010229a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010229c:	53                   	push   %ebx
8010229d:	e8 4e 1f 00 00       	call   801041f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022a2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	74 05                	je     801022b3 <ideintr+0x83>
    idestart(idequeue);
801022ae:	e8 0d fe ff ff       	call   801020c0 <idestart>
    release(&idelock);
801022b3:	83 ec 0c             	sub    $0xc,%esp
801022b6:	68 00 26 11 80       	push   $0x80112600
801022bb:	e8 30 26 00 00       	call   801048f0 <release>

  release(&idelock);
}
801022c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c3:	5b                   	pop    %ebx
801022c4:	5e                   	pop    %esi
801022c5:	5f                   	pop    %edi
801022c6:	5d                   	pop    %ebp
801022c7:	c3                   	ret
801022c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022cf:	00 

801022d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 10             	sub    $0x10,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022da:	8d 43 0c             	lea    0xc(%ebx),%eax
801022dd:	50                   	push   %eax
801022de:	e8 2d 24 00 00       	call   80104710 <holdingsleep>
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	85 c0                	test   %eax,%eax
801022e8:	0f 84 c3 00 00 00    	je     801023b1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022ee:	8b 03                	mov    (%ebx),%eax
801022f0:	83 e0 06             	and    $0x6,%eax
801022f3:	83 f8 02             	cmp    $0x2,%eax
801022f6:	0f 84 a8 00 00 00    	je     801023a4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022fc:	8b 53 04             	mov    0x4(%ebx),%edx
801022ff:	85 d2                	test   %edx,%edx
80102301:	74 0d                	je     80102310 <iderw+0x40>
80102303:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102308:	85 c0                	test   %eax,%eax
8010230a:	0f 84 87 00 00 00    	je     80102397 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	68 00 26 11 80       	push   $0x80112600
80102318:	e8 33 26 00 00       	call   80104950 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010231d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102322:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102329:	83 c4 10             	add    $0x10,%esp
8010232c:	85 c0                	test   %eax,%eax
8010232e:	74 60                	je     80102390 <iderw+0xc0>
80102330:	89 c2                	mov    %eax,%edx
80102332:	8b 40 58             	mov    0x58(%eax),%eax
80102335:	85 c0                	test   %eax,%eax
80102337:	75 f7                	jne    80102330 <iderw+0x60>
80102339:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010233c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010233e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102344:	74 3a                	je     80102380 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102346:	8b 03                	mov    (%ebx),%eax
80102348:	83 e0 06             	and    $0x6,%eax
8010234b:	83 f8 02             	cmp    $0x2,%eax
8010234e:	74 1b                	je     8010236b <iderw+0x9b>
    sleep(b, &idelock);
80102350:	83 ec 08             	sub    $0x8,%esp
80102353:	68 00 26 11 80       	push   $0x80112600
80102358:	53                   	push   %ebx
80102359:	e8 a2 1c 00 00       	call   80104000 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 c4 10             	add    $0x10,%esp
80102363:	83 e0 06             	and    $0x6,%eax
80102366:	83 f8 02             	cmp    $0x2,%eax
80102369:	75 e5                	jne    80102350 <iderw+0x80>
  }


  release(&idelock);
8010236b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102375:	c9                   	leave
  release(&idelock);
80102376:	e9 75 25 00 00       	jmp    801048f0 <release>
8010237b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102380:	89 d8                	mov    %ebx,%eax
80102382:	e8 39 fd ff ff       	call   801020c0 <idestart>
80102387:	eb bd                	jmp    80102346 <iderw+0x76>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102390:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102395:	eb a5                	jmp    8010233c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102397:	83 ec 0c             	sub    $0xc,%esp
8010239a:	68 2e 78 10 80       	push   $0x8010782e
8010239f:	e8 dc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023a4:	83 ec 0c             	sub    $0xc,%esp
801023a7:	68 19 78 10 80       	push   $0x80107819
801023ac:	e8 cf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023b1:	83 ec 0c             	sub    $0xc,%esp
801023b4:	68 03 78 10 80       	push   $0x80107803
801023b9:	e8 c2 df ff ff       	call   80100380 <panic>
801023be:	66 90                	xchg   %ax,%ax

801023c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023c5:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023cc:	00 c0 fe 
  ioapic->reg = reg;
801023cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023d6:	00 00 00 
  return ioapic->data;
801023d9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023df:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023e8:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023ee:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023f5:	c1 ee 10             	shr    $0x10,%esi
801023f8:	89 f0                	mov    %esi,%eax
801023fa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023fd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102400:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102403:	39 c2                	cmp    %eax,%edx
80102405:	74 16                	je     8010241d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 f8 7b 10 80       	push   $0x80107bf8
8010240f:	e8 9c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102414:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010241a:	83 c4 10             	add    $0x10,%esp
{
8010241d:	ba 10 00 00 00       	mov    $0x10,%edx
80102422:	31 c0                	xor    %eax,%eax
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102428:	89 13                	mov    %edx,(%ebx)
8010242a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010242d:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102433:	83 c0 01             	add    $0x1,%eax
80102436:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010243c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010243f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102442:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102445:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102447:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010244d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102454:	39 c6                	cmp    %eax,%esi
80102456:	7d d0                	jge    80102428 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102458:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245b:	5b                   	pop    %ebx
8010245c:	5e                   	pop    %esi
8010245d:	5d                   	pop    %ebp
8010245e:	c3                   	ret
8010245f:	90                   	nop

80102460 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102460:	55                   	push   %ebp
  ioapic->reg = reg;
80102461:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102467:	89 e5                	mov    %esp,%ebp
80102469:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010246c:	8d 50 20             	lea    0x20(%eax),%edx
8010246f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102473:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102475:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010247e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102481:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102484:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102486:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010248b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010248e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret
80102493:	66 90                	xchg   %ax,%ax
80102495:	66 90                	xchg   %ax,%ax
80102497:	66 90                	xchg   %ax,%ax
80102499:	66 90                	xchg   %ax,%ax
8010249b:	66 90                	xchg   %ax,%ax
8010249d:	66 90                	xchg   %ax,%ax
8010249f:	90                   	nop

801024a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 04             	sub    $0x4,%esp
801024a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024b0:	75 76                	jne    80102528 <kfree+0x88>
801024b2:	81 fb d0 6c 11 80    	cmp    $0x80116cd0,%ebx
801024b8:	72 6e                	jb     80102528 <kfree+0x88>
801024ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024c5:	77 61                	ja     80102528 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024c7:	83 ec 04             	sub    $0x4,%esp
801024ca:	68 00 10 00 00       	push   $0x1000
801024cf:	6a 01                	push   $0x1
801024d1:	53                   	push   %ebx
801024d2:	e8 79 25 00 00       	call   80104a50 <memset>

  if(kmem.use_lock)
801024d7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	85 d2                	test   %edx,%edx
801024e2:	75 1c                	jne    80102500 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024e4:	a1 78 26 11 80       	mov    0x80112678,%eax
801024e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024eb:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801024f0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801024f6:	85 c0                	test   %eax,%eax
801024f8:	75 1e                	jne    80102518 <kfree+0x78>
    release(&kmem.lock);
}
801024fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fd:	c9                   	leave
801024fe:	c3                   	ret
801024ff:	90                   	nop
    acquire(&kmem.lock);
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 40 26 11 80       	push   $0x80112640
80102508:	e8 43 24 00 00       	call   80104950 <acquire>
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	eb d2                	jmp    801024e4 <kfree+0x44>
80102512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102518:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010251f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102522:	c9                   	leave
    release(&kmem.lock);
80102523:	e9 c8 23 00 00       	jmp    801048f0 <release>
    panic("kfree");
80102528:	83 ec 0c             	sub    $0xc,%esp
8010252b:	68 4c 78 10 80       	push   $0x8010784c
80102530:	e8 4b de ff ff       	call   80100380 <panic>
80102535:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010253c:	00 
8010253d:	8d 76 00             	lea    0x0(%esi),%esi

80102540 <freerange>:
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	56                   	push   %esi
80102544:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102545:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102548:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010254b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102551:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102557:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010255d:	39 de                	cmp    %ebx,%esi
8010255f:	72 23                	jb     80102584 <freerange+0x44>
80102561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102571:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102577:	50                   	push   %eax
80102578:	e8 23 ff ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	39 de                	cmp    %ebx,%esi
80102582:	73 e4                	jae    80102568 <freerange+0x28>
}
80102584:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102587:	5b                   	pop    %ebx
80102588:	5e                   	pop    %esi
80102589:	5d                   	pop    %ebp
8010258a:	c3                   	ret
8010258b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102590 <kinit2>:
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	56                   	push   %esi
80102594:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102595:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102598:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010259b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ad:	39 de                	cmp    %ebx,%esi
801025af:	72 23                	jb     801025d4 <kinit2+0x44>
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 d3 fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit2+0x28>
  kmem.use_lock = 1;
801025d4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025db:	00 00 00 
}
801025de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e1:	5b                   	pop    %ebx
801025e2:	5e                   	pop    %esi
801025e3:	5d                   	pop    %ebp
801025e4:	c3                   	ret
801025e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025ec:	00 
801025ed:	8d 76 00             	lea    0x0(%esi),%esi

801025f0 <kinit1>:
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	56                   	push   %esi
801025f4:	53                   	push   %ebx
801025f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025f8:	83 ec 08             	sub    $0x8,%esp
801025fb:	68 52 78 10 80       	push   $0x80107852
80102600:	68 40 26 11 80       	push   $0x80112640
80102605:	e8 56 21 00 00       	call   80104760 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010260a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102610:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102617:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010261a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102620:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102626:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262c:	39 de                	cmp    %ebx,%esi
8010262e:	72 1c                	jb     8010264c <kinit1+0x5c>
    kfree(p);
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102639:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010263f:	50                   	push   %eax
80102640:	e8 5b fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102645:	83 c4 10             	add    $0x10,%esp
80102648:	39 de                	cmp    %ebx,%esi
8010264a:	73 e4                	jae    80102630 <kinit1+0x40>
}
8010264c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010264f:	5b                   	pop    %ebx
80102650:	5e                   	pop    %esi
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret
80102653:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010265a:	00 
8010265b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102660 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	53                   	push   %ebx
80102664:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102667:	a1 74 26 11 80       	mov    0x80112674,%eax
8010266c:	85 c0                	test   %eax,%eax
8010266e:	75 20                	jne    80102690 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102670:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102676:	85 db                	test   %ebx,%ebx
80102678:	74 07                	je     80102681 <kalloc+0x21>
    kmem.freelist = r->next;
8010267a:	8b 03                	mov    (%ebx),%eax
8010267c:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102681:	89 d8                	mov    %ebx,%eax
80102683:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102686:	c9                   	leave
80102687:	c3                   	ret
80102688:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010268f:	00 
    acquire(&kmem.lock);
80102690:	83 ec 0c             	sub    $0xc,%esp
80102693:	68 40 26 11 80       	push   $0x80112640
80102698:	e8 b3 22 00 00       	call   80104950 <acquire>
  r = kmem.freelist;
8010269d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(kmem.use_lock)
801026a3:	a1 74 26 11 80       	mov    0x80112674,%eax
  if(r)
801026a8:	83 c4 10             	add    $0x10,%esp
801026ab:	85 db                	test   %ebx,%ebx
801026ad:	74 08                	je     801026b7 <kalloc+0x57>
    kmem.freelist = r->next;
801026af:	8b 13                	mov    (%ebx),%edx
801026b1:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801026b7:	85 c0                	test   %eax,%eax
801026b9:	74 c6                	je     80102681 <kalloc+0x21>
    release(&kmem.lock);
801026bb:	83 ec 0c             	sub    $0xc,%esp
801026be:	68 40 26 11 80       	push   $0x80112640
801026c3:	e8 28 22 00 00       	call   801048f0 <release>
}
801026c8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801026ca:	83 c4 10             	add    $0x10,%esp
}
801026cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026d0:	c9                   	leave
801026d1:	c3                   	ret
801026d2:	66 90                	xchg   %ax,%ax
801026d4:	66 90                	xchg   %ax,%ax
801026d6:	66 90                	xchg   %ax,%ax
801026d8:	66 90                	xchg   %ax,%ax
801026da:	66 90                	xchg   %ax,%ax
801026dc:	66 90                	xchg   %ax,%ax
801026de:	66 90                	xchg   %ax,%ax

801026e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e0:	ba 64 00 00 00       	mov    $0x64,%edx
801026e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026e6:	a8 01                	test   $0x1,%al
801026e8:	0f 84 c2 00 00 00    	je     801027b0 <kbdgetc+0xd0>
{
801026ee:	55                   	push   %ebp
801026ef:	ba 60 00 00 00       	mov    $0x60,%edx
801026f4:	89 e5                	mov    %esp,%ebp
801026f6:	53                   	push   %ebx
801026f7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801026f8:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
801026fe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102701:	3c e0                	cmp    $0xe0,%al
80102703:	74 5b                	je     80102760 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102705:	89 da                	mov    %ebx,%edx
80102707:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010270a:	84 c0                	test   %al,%al
8010270c:	78 62                	js     80102770 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010270e:	85 d2                	test   %edx,%edx
80102710:	74 09                	je     8010271b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102712:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102715:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102718:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010271b:	0f b6 91 80 7e 10 80 	movzbl -0x7fef8180(%ecx),%edx
  shift ^= togglecode[data];
80102722:	0f b6 81 80 7d 10 80 	movzbl -0x7fef8280(%ecx),%eax
  shift |= shiftcode[data];
80102729:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010272b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010272d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010272f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102735:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102738:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273b:	8b 04 85 60 7d 10 80 	mov    -0x7fef82a0(,%eax,4),%eax
80102742:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102746:	74 0b                	je     80102753 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102748:	8d 50 9f             	lea    -0x61(%eax),%edx
8010274b:	83 fa 19             	cmp    $0x19,%edx
8010274e:	77 48                	ja     80102798 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102750:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102756:	c9                   	leave
80102757:	c3                   	ret
80102758:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010275f:	00 
    shift |= E0ESC;
80102760:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102763:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102765:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010276b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010276e:	c9                   	leave
8010276f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102770:	83 e0 7f             	and    $0x7f,%eax
80102773:	85 d2                	test   %edx,%edx
80102775:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102778:	0f b6 81 80 7e 10 80 	movzbl -0x7fef8180(%ecx),%eax
8010277f:	83 c8 40             	or     $0x40,%eax
80102782:	0f b6 c0             	movzbl %al,%eax
80102785:	f7 d0                	not    %eax
80102787:	21 d8                	and    %ebx,%eax
80102789:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
8010278e:	31 c0                	xor    %eax,%eax
80102790:	eb d9                	jmp    8010276b <kbdgetc+0x8b>
80102792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102798:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010279b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010279e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027a1:	c9                   	leave
      c += 'a' - 'A';
801027a2:	83 f9 1a             	cmp    $0x1a,%ecx
801027a5:	0f 42 c2             	cmovb  %edx,%eax
}
801027a8:	c3                   	ret
801027a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027b5:	c3                   	ret
801027b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027bd:	00 
801027be:	66 90                	xchg   %ax,%ax

801027c0 <kbdintr>:

void
kbdintr(void)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027c6:	68 e0 26 10 80       	push   $0x801026e0
801027cb:	e8 d0 e0 ff ff       	call   801008a0 <consoleintr>
}
801027d0:	83 c4 10             	add    $0x10,%esp
801027d3:	c9                   	leave
801027d4:	c3                   	ret
801027d5:	66 90                	xchg   %ax,%ax
801027d7:	66 90                	xchg   %ax,%ax
801027d9:	66 90                	xchg   %ax,%ax
801027db:	66 90                	xchg   %ax,%ax
801027dd:	66 90                	xchg   %ax,%ax
801027df:	90                   	nop

801027e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027e0:	a1 80 26 11 80       	mov    0x80112680,%eax
801027e5:	85 c0                	test   %eax,%eax
801027e7:	0f 84 c3 00 00 00    	je     801028b0 <lapicinit+0xd0>
  lapic[index] = value;
801027ed:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027f4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102801:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102807:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010280e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102811:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102814:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010281b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102821:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102828:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102835:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102838:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010283b:	8b 50 30             	mov    0x30(%eax),%edx
8010283e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102844:	75 72                	jne    801028b8 <lapicinit+0xd8>
  lapic[index] = value;
80102846:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010284d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102850:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102853:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010285a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102860:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102867:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102874:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102881:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102887:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010288e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102891:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102898:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010289e:	80 e6 10             	and    $0x10,%dh
801028a1:	75 f5                	jne    80102898 <lapicinit+0xb8>
  lapic[index] = value;
801028a3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ad:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028b0:	c3                   	ret
801028b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028b8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028bf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028c2:	8b 50 20             	mov    0x20(%eax),%edx
}
801028c5:	e9 7c ff ff ff       	jmp    80102846 <lapicinit+0x66>
801028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028d0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028d5:	85 c0                	test   %eax,%eax
801028d7:	74 07                	je     801028e0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028d9:	8b 40 20             	mov    0x20(%eax),%eax
801028dc:	c1 e8 18             	shr    $0x18,%eax
801028df:	c3                   	ret
    return 0;
801028e0:	31 c0                	xor    %eax,%eax
}
801028e2:	c3                   	ret
801028e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028ea:	00 
801028eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801028f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 0d                	je     80102906 <lapiceoi+0x16>
  lapic[index] = value;
801028f9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102900:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102903:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102906:	c3                   	ret
80102907:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010290e:	00 
8010290f:	90                   	nop

80102910 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102910:	c3                   	ret
80102911:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102918:	00 
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102920 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102920:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102921:	b8 0f 00 00 00       	mov    $0xf,%eax
80102926:	ba 70 00 00 00       	mov    $0x70,%edx
8010292b:	89 e5                	mov    %esp,%ebp
8010292d:	53                   	push   %ebx
8010292e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102931:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102934:	ee                   	out    %al,(%dx)
80102935:	b8 0a 00 00 00       	mov    $0xa,%eax
8010293a:	ba 71 00 00 00       	mov    $0x71,%edx
8010293f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102940:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102942:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102945:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010294b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010294d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102950:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102952:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102955:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102958:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010295e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102963:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102973:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102976:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102979:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102980:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102986:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102995:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102998:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010299e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ad:	c9                   	leave
801029ae:	c3                   	ret
801029af:	90                   	nop

801029b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029b0:	55                   	push   %ebp
801029b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029b6:	ba 70 00 00 00       	mov    $0x70,%edx
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	57                   	push   %edi
801029be:	56                   	push   %esi
801029bf:	53                   	push   %ebx
801029c0:	83 ec 4c             	sub    $0x4c,%esp
801029c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c4:	ba 71 00 00 00       	mov    $0x71,%edx
801029c9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029cd:	bf 70 00 00 00       	mov    $0x70,%edi
801029d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029d5:	8d 76 00             	lea    0x0(%esi),%esi
801029d8:	31 c0                	xor    %eax,%eax
801029da:	89 fa                	mov    %edi,%edx
801029dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801029e2:	89 ca                	mov    %ecx,%edx
801029e4:	ec                   	in     (%dx),%al
801029e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e8:	89 fa                	mov    %edi,%edx
801029ea:	b8 02 00 00 00       	mov    $0x2,%eax
801029ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f0:	89 ca                	mov    %ecx,%edx
801029f2:	ec                   	in     (%dx),%al
801029f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f6:	89 fa                	mov    %edi,%edx
801029f8:	b8 04 00 00 00       	mov    $0x4,%eax
801029fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fe:	89 ca                	mov    %ecx,%edx
80102a00:	ec                   	in     (%dx),%al
80102a01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a04:	89 fa                	mov    %edi,%edx
80102a06:	b8 07 00 00 00       	mov    $0x7,%eax
80102a0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0c:	89 ca                	mov    %ecx,%edx
80102a0e:	ec                   	in     (%dx),%al
80102a0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a12:	89 fa                	mov    %edi,%edx
80102a14:	b8 08 00 00 00       	mov    $0x8,%eax
80102a19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1a:	89 ca                	mov    %ecx,%edx
80102a1c:	ec                   	in     (%dx),%al
80102a1d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1f:	89 fa                	mov    %edi,%edx
80102a21:	b8 09 00 00 00       	mov    $0x9,%eax
80102a26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a27:	89 ca                	mov    %ecx,%edx
80102a29:	ec                   	in     (%dx),%al
80102a2a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2d:	89 fa                	mov    %edi,%edx
80102a2f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a34:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a35:	89 ca                	mov    %ecx,%edx
80102a37:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a38:	84 c0                	test   %al,%al
80102a3a:	78 9c                	js     801029d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a3c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a40:	89 f2                	mov    %esi,%edx
80102a42:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102a45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 fa                	mov    %edi,%edx
80102a4a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a4d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a51:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102a54:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a57:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a5b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a62:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a65:	31 c0                	xor    %eax,%eax
80102a67:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a68:	89 ca                	mov    %ecx,%edx
80102a6a:	ec                   	in     (%dx),%al
80102a6b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6e:	89 fa                	mov    %edi,%edx
80102a70:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a73:	b8 02 00 00 00       	mov    $0x2,%eax
80102a78:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a79:	89 ca                	mov    %ecx,%edx
80102a7b:	ec                   	in     (%dx),%al
80102a7c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7f:	89 fa                	mov    %edi,%edx
80102a81:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a84:	b8 04 00 00 00       	mov    $0x4,%eax
80102a89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8a:	89 ca                	mov    %ecx,%edx
80102a8c:	ec                   	in     (%dx),%al
80102a8d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a90:	89 fa                	mov    %edi,%edx
80102a92:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a95:	b8 07 00 00 00       	mov    $0x7,%eax
80102a9a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9b:	89 ca                	mov    %ecx,%edx
80102a9d:	ec                   	in     (%dx),%al
80102a9e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa1:	89 fa                	mov    %edi,%edx
80102aa3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa6:	b8 08 00 00 00       	mov    $0x8,%eax
80102aab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aac:	89 ca                	mov    %ecx,%edx
80102aae:	ec                   	in     (%dx),%al
80102aaf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab2:	89 fa                	mov    %edi,%edx
80102ab4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab7:	b8 09 00 00 00       	mov    $0x9,%eax
80102abc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abd:	89 ca                	mov    %ecx,%edx
80102abf:	ec                   	in     (%dx),%al
80102ac0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102acc:	6a 18                	push   $0x18
80102ace:	50                   	push   %eax
80102acf:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ad2:	50                   	push   %eax
80102ad3:	e8 b8 1f 00 00       	call   80104a90 <memcmp>
80102ad8:	83 c4 10             	add    $0x10,%esp
80102adb:	85 c0                	test   %eax,%eax
80102add:	0f 85 f5 fe ff ff    	jne    801029d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ae3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102aea:	89 f0                	mov    %esi,%eax
80102aec:	84 c0                	test   %al,%al
80102aee:	75 78                	jne    80102b68 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102af0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102af3:	89 c2                	mov    %eax,%edx
80102af5:	83 e0 0f             	and    $0xf,%eax
80102af8:	c1 ea 04             	shr    $0x4,%edx
80102afb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102afe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b01:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b04:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b07:	89 c2                	mov    %eax,%edx
80102b09:	83 e0 0f             	and    $0xf,%eax
80102b0c:	c1 ea 04             	shr    $0x4,%edx
80102b0f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b12:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b15:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b18:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b1b:	89 c2                	mov    %eax,%edx
80102b1d:	83 e0 0f             	and    $0xf,%eax
80102b20:	c1 ea 04             	shr    $0x4,%edx
80102b23:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b26:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b29:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b2c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b2f:	89 c2                	mov    %eax,%edx
80102b31:	83 e0 0f             	and    $0xf,%eax
80102b34:	c1 ea 04             	shr    $0x4,%edx
80102b37:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b40:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b43:	89 c2                	mov    %eax,%edx
80102b45:	83 e0 0f             	and    $0xf,%eax
80102b48:	c1 ea 04             	shr    $0x4,%edx
80102b4b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b51:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b57:	89 c2                	mov    %eax,%edx
80102b59:	83 e0 0f             	and    $0xf,%eax
80102b5c:	c1 ea 04             	shr    $0x4,%edx
80102b5f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b62:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b65:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b6b:	89 03                	mov    %eax,(%ebx)
80102b6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b70:	89 43 04             	mov    %eax,0x4(%ebx)
80102b73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b76:	89 43 08             	mov    %eax,0x8(%ebx)
80102b79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b7c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102b7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b82:	89 43 10             	mov    %eax,0x10(%ebx)
80102b85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b88:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102b8b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b95:	5b                   	pop    %ebx
80102b96:	5e                   	pop    %esi
80102b97:	5f                   	pop    %edi
80102b98:	5d                   	pop    %ebp
80102b99:	c3                   	ret
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb2:	31 ff                	xor    %edi,%edi
{
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 f8                	add    %edi,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 e4 26 11 80    	push   0x801126e4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102be4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 d7 1e 00 00       	call   80104ae0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 9f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c11:	89 34 24             	mov    %esi,(%esp)
80102c14:	e8 d7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 cf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c47:	ff 35 d4 26 11 80    	push   0x801126d4
80102c4d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c5d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c65:	85 c0                	test   %eax,%eax
80102c67:	7e 19                	jle    80102c82 <write_head+0x42>
80102c69:	31 d2                	xor    %edx,%edx
80102c6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102c70:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102c77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d0                	cmp    %edx,%eax
80102c80:	75 ee                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	53                   	push   %ebx
80102c86:	e8 25 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c8b:	89 1c 24             	mov    %ebx,(%esp)
80102c8e:	e8 5d d5 ff ff       	call   801001f0 <brelse>
}
80102c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c96:	83 c4 10             	add    $0x10,%esp
80102c99:	c9                   	leave
80102c9a:	c3                   	ret
80102c9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102ca0 <initlog>:
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 2c             	sub    $0x2c,%esp
80102ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102caa:	68 57 78 10 80       	push   $0x80107857
80102caf:	68 a0 26 11 80       	push   $0x801126a0
80102cb4:	e8 a7 1a 00 00       	call   80104760 <initlock>
  readsb(dev, &sb);
80102cb9:	58                   	pop    %eax
80102cba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cbd:	5a                   	pop    %edx
80102cbe:	50                   	push   %eax
80102cbf:	53                   	push   %ebx
80102cc0:	e8 7b e8 ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
80102cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cc8:	59                   	pop    %ecx
  log.dev = dev;
80102cc9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102ccf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102cd7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 eb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ce8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ceb:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102cf1:	85 db                	test   %ebx,%ebx
80102cf3:	7e 1d                	jle    80102d12 <initlog+0x72>
80102cf5:	31 d2                	xor    %edx,%edx
80102cf7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102cfe:	00 
80102cff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d00:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d04:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d3                	cmp    %edx,%ebx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 d5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d20:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d27:	00 00 00 
  write_head(); // clear the log
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
}
80102d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	c9                   	leave
80102d36:	c3                   	ret
80102d37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d3e:	00 
80102d3f:	90                   	nop

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d46:	68 a0 26 11 80       	push   $0x801126a0
80102d4b:	e8 00 1c 00 00       	call   80104950 <acquire>
80102d50:	83 c4 10             	add    $0x10,%esp
80102d53:	eb 18                	jmp    80102d6d <begin_op+0x2d>
80102d55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d58:	83 ec 08             	sub    $0x8,%esp
80102d5b:	68 a0 26 11 80       	push   $0x801126a0
80102d60:	68 a0 26 11 80       	push   $0x801126a0
80102d65:	e8 96 12 00 00       	call   80104000 <sleep>
80102d6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d6d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102d72:	85 c0                	test   %eax,%eax
80102d74:	75 e2                	jne    80102d58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d76:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d7b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102d81:	83 c0 01             	add    $0x1,%eax
80102d84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d8a:	83 fa 1e             	cmp    $0x1e,%edx
80102d8d:	7f c9                	jg     80102d58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d92:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102d97:	68 a0 26 11 80       	push   $0x801126a0
80102d9c:	e8 4f 1b 00 00       	call   801048f0 <release>
      break;
    }
  }
}
80102da1:	83 c4 10             	add    $0x10,%esp
80102da4:	c9                   	leave
80102da5:	c3                   	ret
80102da6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dad:	00 
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	57                   	push   %edi
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102db9:	68 a0 26 11 80       	push   $0x801126a0
80102dbe:	e8 8d 1b 00 00       	call   80104950 <acquire>
  log.outstanding -= 1;
80102dc3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102dc8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102dda:	85 f6                	test   %esi,%esi
80102ddc:	0f 85 22 01 00 00    	jne    80102f04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102de2:	85 db                	test   %ebx,%ebx
80102de4:	0f 85 f6 00 00 00    	jne    80102ee0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dea:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102df1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102df4:	83 ec 0c             	sub    $0xc,%esp
80102df7:	68 a0 26 11 80       	push   $0x801126a0
80102dfc:	e8 ef 1a 00 00       	call   801048f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e01:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e07:	83 c4 10             	add    $0x10,%esp
80102e0a:	85 c9                	test   %ecx,%ecx
80102e0c:	7f 42                	jg     80102e50 <end_op+0xa0>
    acquire(&log.lock);
80102e0e:	83 ec 0c             	sub    $0xc,%esp
80102e11:	68 a0 26 11 80       	push   $0x801126a0
80102e16:	e8 35 1b 00 00       	call   80104950 <acquire>
    log.committing = 0;
80102e1b:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e22:	00 00 00 
    wakeup(&log);
80102e25:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e2c:	e8 bf 13 00 00       	call   801041f0 <wakeup>
    release(&log.lock);
80102e31:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e38:	e8 b3 1a 00 00       	call   801048f0 <release>
80102e3d:	83 c4 10             	add    $0x10,%esp
}
80102e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e43:	5b                   	pop    %ebx
80102e44:	5e                   	pop    %esi
80102e45:	5f                   	pop    %edi
80102e46:	5d                   	pop    %ebp
80102e47:	c3                   	ret
80102e48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e4f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e50:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e64:	e8 67 d2 ff ff       	call   801000d0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102e74:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	e8 4e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 47 1c 00 00       	call   80104ae0 <memmove>
    bwrite(to);  // write the log
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 0f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 47 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 3f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102ec6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102ecd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 34 ff ff ff       	jmp    80102e0e <end_op+0x5e>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 a0 26 11 80       	push   $0x801126a0
80102ee8:	e8 03 13 00 00       	call   801041f0 <wakeup>
  release(&log.lock);
80102eed:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ef4:	e8 f7 19 00 00       	call   801048f0 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret
    panic("log.committing");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 5b 78 10 80       	push   $0x8010785b
80102f0c:	e8 6f d4 ff ff       	call   80100380 <panic>
80102f11:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f18:	00 
80102f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	53                   	push   %ebx
80102f24:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f27:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f30:	83 fa 1d             	cmp    $0x1d,%edx
80102f33:	7f 7d                	jg     80102fb2 <log_write+0x92>
80102f35:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f3a:	83 e8 01             	sub    $0x1,%eax
80102f3d:	39 c2                	cmp    %eax,%edx
80102f3f:	7d 71                	jge    80102fb2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f41:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f46:	85 c0                	test   %eax,%eax
80102f48:	7e 75                	jle    80102fbf <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 a0 26 11 80       	push   $0x801126a0
80102f52:	e8 f9 19 00 00       	call   80104950 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f57:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f5a:	83 c4 10             	add    $0x10,%esp
80102f5d:	31 c0                	xor    %eax,%eax
80102f5f:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f65:	85 d2                	test   %edx,%edx
80102f67:	7f 0e                	jg     80102f77 <log_write+0x57>
80102f69:	eb 15                	jmp    80102f80 <log_write+0x60>
80102f6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f77:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
80102f87:	39 c2                	cmp    %eax,%edx
80102f89:	74 1c                	je     80102fa7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f8b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f91:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102f98:	c9                   	leave
  release(&log.lock);
80102f99:	e9 52 19 00 00       	jmp    801048f0 <release>
80102f9e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fb0:	eb d9                	jmp    80102f8b <log_write+0x6b>
    panic("too big a transaction");
80102fb2:	83 ec 0c             	sub    $0xc,%esp
80102fb5:	68 6a 78 10 80       	push   $0x8010786a
80102fba:	e8 c1 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102fbf:	83 ec 0c             	sub    $0xc,%esp
80102fc2:	68 80 78 10 80       	push   $0x80107880
80102fc7:	e8 b4 d3 ff ff       	call   80100380 <panic>
80102fcc:	66 90                	xchg   %ax,%ax
80102fce:	66 90                	xchg   %ax,%ax

80102fd0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	53                   	push   %ebx
80102fd4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fd7:	e8 a4 09 00 00       	call   80103980 <cpuid>
80102fdc:	89 c3                	mov    %eax,%ebx
80102fde:	e8 9d 09 00 00       	call   80103980 <cpuid>
80102fe3:	83 ec 04             	sub    $0x4,%esp
80102fe6:	53                   	push   %ebx
80102fe7:	50                   	push   %eax
80102fe8:	68 9b 78 10 80       	push   $0x8010789b
80102fed:	e8 be d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102ff2:	e8 c9 2d 00 00       	call   80105dc0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ff7:	e8 24 09 00 00       	call   80103920 <mycpu>
80102ffc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ffe:	b8 01 00 00 00       	mov    $0x1,%eax
80103003:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010300a:	e8 41 0c 00 00       	call   80103c50 <scheduler>
8010300f:	90                   	nop

80103010 <mpenter>:
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103016:	e8 d5 3e 00 00       	call   80106ef0 <switchkvm>
  seginit();
8010301b:	e8 40 3e 00 00       	call   80106e60 <seginit>
  lapicinit();
80103020:	e8 bb f7 ff ff       	call   801027e0 <lapicinit>
  mpmain();
80103025:	e8 a6 ff ff ff       	call   80102fd0 <mpmain>
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <main>:
{
80103030:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103034:	83 e4 f0             	and    $0xfffffff0,%esp
80103037:	ff 71 fc             	push   -0x4(%ecx)
8010303a:	55                   	push   %ebp
8010303b:	89 e5                	mov    %esp,%ebp
8010303d:	53                   	push   %ebx
8010303e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010303f:	83 ec 08             	sub    $0x8,%esp
80103042:	68 00 00 40 80       	push   $0x80400000
80103047:	68 d0 6c 11 80       	push   $0x80116cd0
8010304c:	e8 9f f5 ff ff       	call   801025f0 <kinit1>
  kvmalloc();      // kernel page table
80103051:	e8 5a 43 00 00       	call   801073b0 <kvmalloc>
  mpinit();        // detect other processors
80103056:	e8 85 01 00 00       	call   801031e0 <mpinit>
  lapicinit();     // interrupt controller
8010305b:	e8 80 f7 ff ff       	call   801027e0 <lapicinit>
  seginit();       // segment descriptors
80103060:	e8 fb 3d 00 00       	call   80106e60 <seginit>
  picinit();       // disable pic
80103065:	e8 86 03 00 00       	call   801033f0 <picinit>
  ioapicinit();    // another interrupt controller
8010306a:	e8 51 f3 ff ff       	call   801023c0 <ioapicinit>
  consoleinit();   // console hardware
8010306f:	e8 ec d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103074:	e8 57 30 00 00       	call   801060d0 <uartinit>
  pinit();         // process table
80103079:	e8 82 08 00 00       	call   80103900 <pinit>
  tvinit();        // trap vectors
8010307e:	e8 bd 2c 00 00       	call   80105d40 <tvinit>
  binit();         // buffer cache
80103083:	e8 b8 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103088:	e8 a3 dd ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk 
8010308d:	e8 0e f1 ff ff       	call   801021a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103092:	83 c4 0c             	add    $0xc,%esp
80103095:	68 8a 00 00 00       	push   $0x8a
8010309a:	68 8c b4 10 80       	push   $0x8010b48c
8010309f:	68 00 70 00 80       	push   $0x80007000
801030a4:	e8 37 1a 00 00       	call   80104ae0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030a9:	83 c4 10             	add    $0x10,%esp
801030ac:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030b3:	00 00 00 
801030b6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030bb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801030c0:	76 7e                	jbe    80103140 <main+0x110>
801030c2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801030c7:	eb 20                	jmp    801030e9 <main+0xb9>
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030d0:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030d7:	00 00 00 
801030da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030e0:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030e5:	39 c3                	cmp    %eax,%ebx
801030e7:	73 57                	jae    80103140 <main+0x110>
    if(c == mycpu())  // We've started already.
801030e9:	e8 32 08 00 00       	call   80103920 <mycpu>
801030ee:	39 c3                	cmp    %eax,%ebx
801030f0:	74 de                	je     801030d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030f2:	e8 69 f5 ff ff       	call   80102660 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801030fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103010,0x80006ff8
80103101:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103104:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010310b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010310e:	05 00 10 00 00       	add    $0x1000,%eax
80103113:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103118:	0f b6 03             	movzbl (%ebx),%eax
8010311b:	68 00 70 00 00       	push   $0x7000
80103120:	50                   	push   %eax
80103121:	e8 fa f7 ff ff       	call   80102920 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103126:	83 c4 10             	add    $0x10,%esp
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103130:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103136:	85 c0                	test   %eax,%eax
80103138:	74 f6                	je     80103130 <main+0x100>
8010313a:	eb 94                	jmp    801030d0 <main+0xa0>
8010313c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103140:	83 ec 08             	sub    $0x8,%esp
80103143:	68 00 00 00 8e       	push   $0x8e000000
80103148:	68 00 00 40 80       	push   $0x80400000
8010314d:	e8 3e f4 ff ff       	call   80102590 <kinit2>
  userinit();      // first user process
80103152:	e8 79 08 00 00       	call   801039d0 <userinit>
  mpmain();        // finish this processor's setup
80103157:	e8 74 fe ff ff       	call   80102fd0 <mpmain>
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103165:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010316b:	53                   	push   %ebx
  e = addr+len;
8010316c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010316f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103172:	39 de                	cmp    %ebx,%esi
80103174:	72 10                	jb     80103186 <mpsearch1+0x26>
80103176:	eb 50                	jmp    801031c8 <mpsearch1+0x68>
80103178:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010317f:	00 
80103180:	89 fe                	mov    %edi,%esi
80103182:	39 df                	cmp    %ebx,%edi
80103184:	73 42                	jae    801031c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103186:	83 ec 04             	sub    $0x4,%esp
80103189:	8d 7e 10             	lea    0x10(%esi),%edi
8010318c:	6a 04                	push   $0x4
8010318e:	68 af 78 10 80       	push   $0x801078af
80103193:	56                   	push   %esi
80103194:	e8 f7 18 00 00       	call   80104a90 <memcmp>
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	85 c0                	test   %eax,%eax
8010319e:	75 e0                	jne    80103180 <mpsearch1+0x20>
801031a0:	89 f2                	mov    %esi,%edx
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031a8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031ab:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031b0:	39 fa                	cmp    %edi,%edx
801031b2:	75 f4                	jne    801031a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b4:	84 c0                	test   %al,%al
801031b6:	75 c8                	jne    80103180 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bb:	89 f0                	mov    %esi,%eax
801031bd:	5b                   	pop    %ebx
801031be:	5e                   	pop    %esi
801031bf:	5f                   	pop    %edi
801031c0:	5d                   	pop    %ebp
801031c1:	c3                   	ret
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031cb:	31 f6                	xor    %esi,%esi
}
801031cd:	5b                   	pop    %ebx
801031ce:	89 f0                	mov    %esi,%eax
801031d0:	5e                   	pop    %esi
801031d1:	5f                   	pop    %edi
801031d2:	5d                   	pop    %ebp
801031d3:	c3                   	ret
801031d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031db:	00 
801031dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801031e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031f7:	c1 e0 08             	shl    $0x8,%eax
801031fa:	09 d0                	or     %edx,%eax
801031fc:	c1 e0 04             	shl    $0x4,%eax
801031ff:	75 1b                	jne    8010321c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103201:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103208:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010320f:	c1 e0 08             	shl    $0x8,%eax
80103212:	09 d0                	or     %edx,%eax
80103214:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103217:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010321c:	ba 00 04 00 00       	mov    $0x400,%edx
80103221:	e8 3a ff ff ff       	call   80103160 <mpsearch1>
80103226:	89 c3                	mov    %eax,%ebx
80103228:	85 c0                	test   %eax,%eax
8010322a:	0f 84 58 01 00 00    	je     80103388 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103230:	8b 73 04             	mov    0x4(%ebx),%esi
80103233:	85 f6                	test   %esi,%esi
80103235:	0f 84 3d 01 00 00    	je     80103378 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010323b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010323e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103244:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103247:	6a 04                	push   $0x4
80103249:	68 b4 78 10 80       	push   $0x801078b4
8010324e:	50                   	push   %eax
8010324f:	e8 3c 18 00 00       	call   80104a90 <memcmp>
80103254:	83 c4 10             	add    $0x10,%esp
80103257:	85 c0                	test   %eax,%eax
80103259:	0f 85 19 01 00 00    	jne    80103378 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010325f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103266:	3c 01                	cmp    $0x1,%al
80103268:	74 08                	je     80103272 <mpinit+0x92>
8010326a:	3c 04                	cmp    $0x4,%al
8010326c:	0f 85 06 01 00 00    	jne    80103378 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103272:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103279:	66 85 d2             	test   %dx,%dx
8010327c:	74 22                	je     801032a0 <mpinit+0xc0>
8010327e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103281:	89 f0                	mov    %esi,%eax
  sum = 0;
80103283:	31 d2                	xor    %edx,%edx
80103285:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103288:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010328f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103292:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103294:	39 f8                	cmp    %edi,%eax
80103296:	75 f0                	jne    80103288 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103298:	84 d2                	test   %dl,%dl
8010329a:	0f 85 d8 00 00 00    	jne    80103378 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032a0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801032a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801032ac:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032b1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032b8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801032be:	01 d7                	add    %edx,%edi
801032c0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801032c2:	bf 01 00 00 00       	mov    $0x1,%edi
801032c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032ce:	00 
801032cf:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d0:	39 d0                	cmp    %edx,%eax
801032d2:	73 19                	jae    801032ed <mpinit+0x10d>
    switch(*p){
801032d4:	0f b6 08             	movzbl (%eax),%ecx
801032d7:	80 f9 02             	cmp    $0x2,%cl
801032da:	0f 84 80 00 00 00    	je     80103360 <mpinit+0x180>
801032e0:	77 6e                	ja     80103350 <mpinit+0x170>
801032e2:	84 c9                	test   %cl,%cl
801032e4:	74 3a                	je     80103320 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032e6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e9:	39 d0                	cmp    %edx,%eax
801032eb:	72 e7                	jb     801032d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032ed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801032f0:	85 ff                	test   %edi,%edi
801032f2:	0f 84 dd 00 00 00    	je     801033d5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032f8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801032fc:	74 15                	je     80103313 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032fe:	b8 70 00 00 00       	mov    $0x70,%eax
80103303:	ba 22 00 00 00       	mov    $0x22,%edx
80103308:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103309:	ba 23 00 00 00       	mov    $0x23,%edx
8010330e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010330f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103312:	ee                   	out    %al,(%dx)
  }
}
80103313:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103316:	5b                   	pop    %ebx
80103317:	5e                   	pop    %esi
80103318:	5f                   	pop    %edi
80103319:	5d                   	pop    %ebp
8010331a:	c3                   	ret
8010331b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103320:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103326:	83 f9 07             	cmp    $0x7,%ecx
80103329:	7f 19                	jg     80103344 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010332b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103331:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103335:	83 c1 01             	add    $0x1,%ecx
80103338:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010333e:	88 9e a0 27 11 80    	mov    %bl,-0x7feed860(%esi)
      p += sizeof(struct mpproc);
80103344:	83 c0 14             	add    $0x14,%eax
      continue;
80103347:	eb 87                	jmp    801032d0 <mpinit+0xf0>
80103349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103350:	83 e9 03             	sub    $0x3,%ecx
80103353:	80 f9 01             	cmp    $0x1,%cl
80103356:	76 8e                	jbe    801032e6 <mpinit+0x106>
80103358:	31 ff                	xor    %edi,%edi
8010335a:	e9 71 ff ff ff       	jmp    801032d0 <mpinit+0xf0>
8010335f:	90                   	nop
      ioapicid = ioapic->apicno;
80103360:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103364:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103367:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010336d:	e9 5e ff ff ff       	jmp    801032d0 <mpinit+0xf0>
80103372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103378:	83 ec 0c             	sub    $0xc,%esp
8010337b:	68 b9 78 10 80       	push   $0x801078b9
80103380:	e8 fb cf ff ff       	call   80100380 <panic>
80103385:	8d 76 00             	lea    0x0(%esi),%esi
{
80103388:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010338d:	eb 0b                	jmp    8010339a <mpinit+0x1ba>
8010338f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103390:	89 f3                	mov    %esi,%ebx
80103392:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103398:	74 de                	je     80103378 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010339a:	83 ec 04             	sub    $0x4,%esp
8010339d:	8d 73 10             	lea    0x10(%ebx),%esi
801033a0:	6a 04                	push   $0x4
801033a2:	68 af 78 10 80       	push   $0x801078af
801033a7:	53                   	push   %ebx
801033a8:	e8 e3 16 00 00       	call   80104a90 <memcmp>
801033ad:	83 c4 10             	add    $0x10,%esp
801033b0:	85 c0                	test   %eax,%eax
801033b2:	75 dc                	jne    80103390 <mpinit+0x1b0>
801033b4:	89 da                	mov    %ebx,%edx
801033b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033bd:	00 
801033be:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801033c0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033c3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033c6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033c8:	39 d6                	cmp    %edx,%esi
801033ca:	75 f4                	jne    801033c0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033cc:	84 c0                	test   %al,%al
801033ce:	75 c0                	jne    80103390 <mpinit+0x1b0>
801033d0:	e9 5b fe ff ff       	jmp    80103230 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033d5:	83 ec 0c             	sub    $0xc,%esp
801033d8:	68 2c 7c 10 80       	push   $0x80107c2c
801033dd:	e8 9e cf ff ff       	call   80100380 <panic>
801033e2:	66 90                	xchg   %ax,%ax
801033e4:	66 90                	xchg   %ax,%ax
801033e6:	66 90                	xchg   %ax,%ax
801033e8:	66 90                	xchg   %ax,%ax
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <picinit>:
801033f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033f5:	ba 21 00 00 00       	mov    $0x21,%edx
801033fa:	ee                   	out    %al,(%dx)
801033fb:	ba a1 00 00 00       	mov    $0xa1,%edx
80103400:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103401:	c3                   	ret
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 0c             	sub    $0xc,%esp
80103419:	8b 75 08             	mov    0x8(%ebp),%esi
8010341c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010341f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103425:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010342b:	e8 20 da ff ff       	call   80100e50 <filealloc>
80103430:	89 06                	mov    %eax,(%esi)
80103432:	85 c0                	test   %eax,%eax
80103434:	0f 84 a5 00 00 00    	je     801034df <pipealloc+0xcf>
8010343a:	e8 11 da ff ff       	call   80100e50 <filealloc>
8010343f:	89 07                	mov    %eax,(%edi)
80103441:	85 c0                	test   %eax,%eax
80103443:	0f 84 84 00 00 00    	je     801034cd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103449:	e8 12 f2 ff ff       	call   80102660 <kalloc>
8010344e:	89 c3                	mov    %eax,%ebx
80103450:	85 c0                	test   %eax,%eax
80103452:	0f 84 a0 00 00 00    	je     801034f8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103458:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010345f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103462:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103465:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010346c:	00 00 00 
  p->nwrite = 0;
8010346f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103476:	00 00 00 
  p->nread = 0;
80103479:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103480:	00 00 00 
  initlock(&p->lock, "pipe");
80103483:	68 d1 78 10 80       	push   $0x801078d1
80103488:	50                   	push   %eax
80103489:	e8 d2 12 00 00       	call   80104760 <initlock>
  (*f0)->type = FD_PIPE;
8010348e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103490:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103493:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103499:	8b 06                	mov    (%esi),%eax
8010349b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010349f:	8b 06                	mov    (%esi),%eax
801034a1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034a5:	8b 06                	mov    (%esi),%eax
801034a7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034aa:	8b 07                	mov    (%edi),%eax
801034ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034b2:	8b 07                	mov    (%edi),%eax
801034b4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034b8:	8b 07                	mov    (%edi),%eax
801034ba:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034be:	8b 07                	mov    (%edi),%eax
801034c0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801034c3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034c8:	5b                   	pop    %ebx
801034c9:	5e                   	pop    %esi
801034ca:	5f                   	pop    %edi
801034cb:	5d                   	pop    %ebp
801034cc:	c3                   	ret
  if(*f0)
801034cd:	8b 06                	mov    (%esi),%eax
801034cf:	85 c0                	test   %eax,%eax
801034d1:	74 1e                	je     801034f1 <pipealloc+0xe1>
    fileclose(*f0);
801034d3:	83 ec 0c             	sub    $0xc,%esp
801034d6:	50                   	push   %eax
801034d7:	e8 34 da ff ff       	call   80100f10 <fileclose>
801034dc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034df:	8b 07                	mov    (%edi),%eax
801034e1:	85 c0                	test   %eax,%eax
801034e3:	74 0c                	je     801034f1 <pipealloc+0xe1>
    fileclose(*f1);
801034e5:	83 ec 0c             	sub    $0xc,%esp
801034e8:	50                   	push   %eax
801034e9:	e8 22 da ff ff       	call   80100f10 <fileclose>
801034ee:	83 c4 10             	add    $0x10,%esp
  return -1;
801034f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034f6:	eb cd                	jmp    801034c5 <pipealloc+0xb5>
  if(*f0)
801034f8:	8b 06                	mov    (%esi),%eax
801034fa:	85 c0                	test   %eax,%eax
801034fc:	75 d5                	jne    801034d3 <pipealloc+0xc3>
801034fe:	eb df                	jmp    801034df <pipealloc+0xcf>

80103500 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	56                   	push   %esi
80103504:	53                   	push   %ebx
80103505:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103508:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010350b:	83 ec 0c             	sub    $0xc,%esp
8010350e:	53                   	push   %ebx
8010350f:	e8 3c 14 00 00       	call   80104950 <acquire>
  if(writable){
80103514:	83 c4 10             	add    $0x10,%esp
80103517:	85 f6                	test   %esi,%esi
80103519:	74 65                	je     80103580 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010351b:	83 ec 0c             	sub    $0xc,%esp
8010351e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103524:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010352b:	00 00 00 
    wakeup(&p->nread);
8010352e:	50                   	push   %eax
8010352f:	e8 bc 0c 00 00       	call   801041f0 <wakeup>
80103534:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103537:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010353d:	85 d2                	test   %edx,%edx
8010353f:	75 0a                	jne    8010354b <pipeclose+0x4b>
80103541:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103547:	85 c0                	test   %eax,%eax
80103549:	74 15                	je     80103560 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010354b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010354e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103551:	5b                   	pop    %ebx
80103552:	5e                   	pop    %esi
80103553:	5d                   	pop    %ebp
    release(&p->lock);
80103554:	e9 97 13 00 00       	jmp    801048f0 <release>
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	53                   	push   %ebx
80103564:	e8 87 13 00 00       	call   801048f0 <release>
    kfree((char*)p);
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010356f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103572:	5b                   	pop    %ebx
80103573:	5e                   	pop    %esi
80103574:	5d                   	pop    %ebp
    kfree((char*)p);
80103575:	e9 26 ef ff ff       	jmp    801024a0 <kfree>
8010357a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103589:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103590:	00 00 00 
    wakeup(&p->nwrite);
80103593:	50                   	push   %eax
80103594:	e8 57 0c 00 00       	call   801041f0 <wakeup>
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	eb 99                	jmp    80103537 <pipeclose+0x37>
8010359e:	66 90                	xchg   %ax,%ax

801035a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	57                   	push   %edi
801035a4:	56                   	push   %esi
801035a5:	53                   	push   %ebx
801035a6:	83 ec 28             	sub    $0x28,%esp
801035a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035ac:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801035af:	53                   	push   %ebx
801035b0:	e8 9b 13 00 00       	call   80104950 <acquire>
  for(i = 0; i < n; i++){
801035b5:	83 c4 10             	add    $0x10,%esp
801035b8:	85 ff                	test   %edi,%edi
801035ba:	0f 8e ce 00 00 00    	jle    8010368e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801035c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801035c9:	89 7d 10             	mov    %edi,0x10(%ebp)
801035cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035cf:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801035d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035d5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035db:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801035ed:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801035f0:	0f 85 b6 00 00 00    	jne    801036ac <pipewrite+0x10c>
801035f6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801035f9:	eb 3b                	jmp    80103636 <pipewrite+0x96>
801035fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103600:	e8 9b 03 00 00       	call   801039a0 <myproc>
80103605:	8b 48 24             	mov    0x24(%eax),%ecx
80103608:	85 c9                	test   %ecx,%ecx
8010360a:	75 34                	jne    80103640 <pipewrite+0xa0>
      wakeup(&p->nread);
8010360c:	83 ec 0c             	sub    $0xc,%esp
8010360f:	56                   	push   %esi
80103610:	e8 db 0b 00 00       	call   801041f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103615:	58                   	pop    %eax
80103616:	5a                   	pop    %edx
80103617:	53                   	push   %ebx
80103618:	57                   	push   %edi
80103619:	e8 e2 09 00 00       	call   80104000 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010361e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103624:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010362a:	83 c4 10             	add    $0x10,%esp
8010362d:	05 00 02 00 00       	add    $0x200,%eax
80103632:	39 c2                	cmp    %eax,%edx
80103634:	75 2a                	jne    80103660 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103636:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010363c:	85 c0                	test   %eax,%eax
8010363e:	75 c0                	jne    80103600 <pipewrite+0x60>
        release(&p->lock);
80103640:	83 ec 0c             	sub    $0xc,%esp
80103643:	53                   	push   %ebx
80103644:	e8 a7 12 00 00       	call   801048f0 <release>
        return -1;
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103651:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103654:	5b                   	pop    %ebx
80103655:	5e                   	pop    %esi
80103656:	5f                   	pop    %edi
80103657:	5d                   	pop    %ebp
80103658:	c3                   	ret
80103659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103660:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103663:	8d 42 01             	lea    0x1(%edx),%eax
80103666:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010366c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010366f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103675:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103678:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010367c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103680:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103683:	39 c1                	cmp    %eax,%ecx
80103685:	0f 85 50 ff ff ff    	jne    801035db <pipewrite+0x3b>
8010368b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010368e:	83 ec 0c             	sub    $0xc,%esp
80103691:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103697:	50                   	push   %eax
80103698:	e8 53 0b 00 00       	call   801041f0 <wakeup>
  release(&p->lock);
8010369d:	89 1c 24             	mov    %ebx,(%esp)
801036a0:	e8 4b 12 00 00       	call   801048f0 <release>
  return n;
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	89 f8                	mov    %edi,%eax
801036aa:	eb a5                	jmp    80103651 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801036af:	eb b2                	jmp    80103663 <pipewrite+0xc3>
801036b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801036b8:	00 
801036b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	57                   	push   %edi
801036c4:	56                   	push   %esi
801036c5:	53                   	push   %ebx
801036c6:	83 ec 18             	sub    $0x18,%esp
801036c9:	8b 75 08             	mov    0x8(%ebp),%esi
801036cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036cf:	56                   	push   %esi
801036d0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036d6:	e8 75 12 00 00       	call   80104950 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036db:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036e1:	83 c4 10             	add    $0x10,%esp
801036e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801036ea:	74 2f                	je     8010371b <piperead+0x5b>
801036ec:	eb 37                	jmp    80103725 <piperead+0x65>
801036ee:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801036f0:	e8 ab 02 00 00       	call   801039a0 <myproc>
801036f5:	8b 40 24             	mov    0x24(%eax),%eax
801036f8:	85 c0                	test   %eax,%eax
801036fa:	0f 85 80 00 00 00    	jne    80103780 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103700:	83 ec 08             	sub    $0x8,%esp
80103703:	56                   	push   %esi
80103704:	53                   	push   %ebx
80103705:	e8 f6 08 00 00       	call   80104000 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103710:	83 c4 10             	add    $0x10,%esp
80103713:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103719:	75 0a                	jne    80103725 <piperead+0x65>
8010371b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103721:	85 d2                	test   %edx,%edx
80103723:	75 cb                	jne    801036f0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103725:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103728:	31 db                	xor    %ebx,%ebx
8010372a:	85 c9                	test   %ecx,%ecx
8010372c:	7f 26                	jg     80103754 <piperead+0x94>
8010372e:	eb 2c                	jmp    8010375c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103730:	8d 48 01             	lea    0x1(%eax),%ecx
80103733:	25 ff 01 00 00       	and    $0x1ff,%eax
80103738:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010373e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103743:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103746:	83 c3 01             	add    $0x1,%ebx
80103749:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374c:	74 0e                	je     8010375c <piperead+0x9c>
8010374e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	75 d4                	jne    80103730 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103765:	50                   	push   %eax
80103766:	e8 85 0a 00 00       	call   801041f0 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 7d 11 00 00       	call   801048f0 <release>
  return i;
80103773:	83 c4 10             	add    $0x10,%esp
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret
      release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103783:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103788:	56                   	push   %esi
80103789:	e8 62 11 00 00       	call   801048f0 <release>
      return -1;
8010378e:	83 c4 10             	add    $0x10,%esp
}
80103791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103794:	89 d8                	mov    %ebx,%eax
80103796:	5b                   	pop    %ebx
80103797:	5e                   	pop    %esi
80103798:	5f                   	pop    %edi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ac:	68 20 2d 11 80       	push   $0x80112d20
801037b1:	e8 9a 11 00 00       	call   80104950 <acquire>
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	eb 17                	jmp    801037d2 <allocproc+0x32>
801037bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801037c6:	81 fb 54 54 11 80    	cmp    $0x80115454,%ebx
801037cc:	0f 84 ae 00 00 00    	je     80103880 <allocproc+0xe0>
    if(p->state == UNUSED)
801037d2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037d5:	85 c0                	test   %eax,%eax
801037d7:	75 e7                	jne    801037c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037d9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->rtime = 0;
  p->wtime = 0;
  p->snapticks = ticks;
  p->priority = 60;

  release(&ptable.lock);
801037de:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037e1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->context_switches_in = 0;
801037e8:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->pid = nextpid++;
801037ef:	8d 50 01             	lea    0x1(%eax),%edx
801037f2:	89 43 10             	mov    %eax,0x10(%ebx)
  p->snapticks = ticks;
801037f5:	a1 60 54 11 80       	mov    0x80115460,%eax
  p->context_switches_out = 0;
801037fa:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103801:	00 00 00 
  p->snapticks = ticks;
80103804:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
  p->rtime = 0;
8010380a:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103811:	00 00 00 
  p->wtime = 0;
80103814:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010381b:	00 00 00 
  p->priority = 60;
8010381e:	c7 83 90 00 00 00 3c 	movl   $0x3c,0x90(%ebx)
80103825:	00 00 00 
  release(&ptable.lock);
80103828:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010382d:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103833:	e8 b8 10 00 00       	call   801048f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103838:	e8 23 ee ff ff       	call   80102660 <kalloc>
8010383d:	83 c4 10             	add    $0x10,%esp
80103840:	89 43 08             	mov    %eax,0x8(%ebx)
80103843:	85 c0                	test   %eax,%eax
80103845:	74 52                	je     80103899 <allocproc+0xf9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103847:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010384d:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103850:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103855:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103858:	c7 40 14 2f 5d 10 80 	movl   $0x80105d2f,0x14(%eax)
  p->context = (struct context*)sp;
8010385f:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103862:	6a 14                	push   $0x14
80103864:	6a 00                	push   $0x0
80103866:	50                   	push   %eax
80103867:	e8 e4 11 00 00       	call   80104a50 <memset>
  p->context->eip = (uint)forkret;
8010386c:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010386f:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103872:	c7 40 10 b0 38 10 80 	movl   $0x801038b0,0x10(%eax)
}
80103879:	89 d8                	mov    %ebx,%eax
8010387b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010387e:	c9                   	leave
8010387f:	c3                   	ret
  release(&ptable.lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103883:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103885:	68 20 2d 11 80       	push   $0x80112d20
8010388a:	e8 61 10 00 00       	call   801048f0 <release>
  return 0;
8010388f:	83 c4 10             	add    $0x10,%esp
}
80103892:	89 d8                	mov    %ebx,%eax
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave
80103898:	c3                   	ret
    p->state = UNUSED;
80103899:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
801038a0:	31 db                	xor    %ebx,%ebx
801038a2:	eb ee                	jmp    80103892 <allocproc+0xf2>
801038a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038ab:	00 
801038ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038b6:	68 20 2d 11 80       	push   $0x80112d20
801038bb:	e8 30 10 00 00       	call   801048f0 <release>

  if (first) {
801038c0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	85 c0                	test   %eax,%eax
801038ca:	75 04                	jne    801038d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038cc:	c9                   	leave
801038cd:	c3                   	ret
801038ce:	66 90                	xchg   %ax,%ax
    first = 0;
801038d0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038d7:	00 00 00 
    iinit(ROOTDEV);
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	6a 01                	push   $0x1
801038df:	e8 9c dc ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
801038e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038eb:	e8 b0 f3 ff ff       	call   80102ca0 <initlog>
}
801038f0:	83 c4 10             	add    $0x10,%esp
801038f3:	c9                   	leave
801038f4:	c3                   	ret
801038f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038fc:	00 
801038fd:	8d 76 00             	lea    0x0(%esi),%esi

80103900 <pinit>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103906:	68 d6 78 10 80       	push   $0x801078d6
8010390b:	68 20 2d 11 80       	push   $0x80112d20
80103910:	e8 4b 0e 00 00       	call   80104760 <initlock>
}
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	c9                   	leave
80103919:	c3                   	ret
8010391a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103920 <mycpu>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	56                   	push   %esi
80103924:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103925:	9c                   	pushf
80103926:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103927:	f6 c4 02             	test   $0x2,%ah
8010392a:	75 46                	jne    80103972 <mycpu+0x52>
  apicid = lapicid();
8010392c:	e8 9f ef ff ff       	call   801028d0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103931:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103937:	85 f6                	test   %esi,%esi
80103939:	7e 2a                	jle    80103965 <mycpu+0x45>
8010393b:	31 d2                	xor    %edx,%edx
8010393d:	eb 08                	jmp    80103947 <mycpu+0x27>
8010393f:	90                   	nop
80103940:	83 c2 01             	add    $0x1,%edx
80103943:	39 f2                	cmp    %esi,%edx
80103945:	74 1e                	je     80103965 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103947:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010394d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103954:	39 c3                	cmp    %eax,%ebx
80103956:	75 e8                	jne    80103940 <mycpu+0x20>
}
80103958:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010395b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103961:	5b                   	pop    %ebx
80103962:	5e                   	pop    %esi
80103963:	5d                   	pop    %ebp
80103964:	c3                   	ret
  panic("unknown apicid\n");
80103965:	83 ec 0c             	sub    $0xc,%esp
80103968:	68 dd 78 10 80       	push   $0x801078dd
8010396d:	e8 0e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103972:	83 ec 0c             	sub    $0xc,%esp
80103975:	68 4c 7c 10 80       	push   $0x80107c4c
8010397a:	e8 01 ca ff ff       	call   80100380 <panic>
8010397f:	90                   	nop

80103980 <cpuid>:
cpuid() {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103986:	e8 95 ff ff ff       	call   80103920 <mycpu>
}
8010398b:	c9                   	leave
  return mycpu()-cpus;
8010398c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103991:	c1 f8 04             	sar    $0x4,%eax
80103994:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010399a:	c3                   	ret
8010399b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801039a0 <myproc>:
myproc(void) {
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
801039a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039a7:	e8 54 0e 00 00       	call   80104800 <pushcli>
  c = mycpu();
801039ac:	e8 6f ff ff ff       	call   80103920 <mycpu>
  p = c->proc;
801039b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039b7:	e8 94 0e 00 00       	call   80104850 <popcli>
}
801039bc:	89 d8                	mov    %ebx,%eax
801039be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039c1:	c9                   	leave
801039c2:	c3                   	ret
801039c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039ca:	00 
801039cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801039d0 <userinit>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
801039d4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039d7:	e8 c4 fd ff ff       	call   801037a0 <allocproc>
801039dc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039de:	a3 54 54 11 80       	mov    %eax,0x80115454
  if((p->pgdir = setupkvm()) == 0)
801039e3:	e8 48 39 00 00       	call   80107330 <setupkvm>
801039e8:	89 43 04             	mov    %eax,0x4(%ebx)
801039eb:	85 c0                	test   %eax,%eax
801039ed:	0f 84 bd 00 00 00    	je     80103ab0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039f3:	83 ec 04             	sub    $0x4,%esp
801039f6:	68 2c 00 00 00       	push   $0x2c
801039fb:	68 60 b4 10 80       	push   $0x8010b460
80103a00:	50                   	push   %eax
80103a01:	e8 0a 36 00 00       	call   80107010 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a06:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a09:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a0f:	6a 4c                	push   $0x4c
80103a11:	6a 00                	push   $0x0
80103a13:	ff 73 18             	push   0x18(%ebx)
80103a16:	e8 35 10 00 00       	call   80104a50 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a1b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a23:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a26:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a2b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a32:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a3d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a41:	8b 43 18             	mov    0x18(%ebx),%eax
80103a44:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a48:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a4c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a4f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a56:	8b 43 18             	mov    0x18(%ebx),%eax
80103a59:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a60:	8b 43 18             	mov    0x18(%ebx),%eax
80103a63:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a6a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a6d:	6a 10                	push   $0x10
80103a6f:	68 06 79 10 80       	push   $0x80107906
80103a74:	50                   	push   %eax
80103a75:	e8 86 11 00 00       	call   80104c00 <safestrcpy>
  p->cwd = namei("/");
80103a7a:	c7 04 24 0f 79 10 80 	movl   $0x8010790f,(%esp)
80103a81:	e8 fa e5 ff ff       	call   80102080 <namei>
80103a86:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a89:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a90:	e8 bb 0e 00 00       	call   80104950 <acquire>
  p->state = RUNNABLE;
80103a95:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a9c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103aa3:	e8 48 0e 00 00       	call   801048f0 <release>
}
80103aa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aab:	83 c4 10             	add    $0x10,%esp
80103aae:	c9                   	leave
80103aaf:	c3                   	ret
    panic("userinit: out of memory?");
80103ab0:	83 ec 0c             	sub    $0xc,%esp
80103ab3:	68 ed 78 10 80       	push   $0x801078ed
80103ab8:	e8 c3 c8 ff ff       	call   80100380 <panic>
80103abd:	8d 76 00             	lea    0x0(%esi),%esi

80103ac0 <growproc>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
80103ac5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ac8:	e8 33 0d 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103acd:	e8 4e fe ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103ad2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad8:	e8 73 0d 00 00       	call   80104850 <popcli>
  sz = curproc->sz;
80103add:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103adf:	85 f6                	test   %esi,%esi
80103ae1:	7f 1d                	jg     80103b00 <growproc+0x40>
  } else if(n < 0){
80103ae3:	75 3b                	jne    80103b20 <growproc+0x60>
  switchuvm(curproc);
80103ae5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ae8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aea:	53                   	push   %ebx
80103aeb:	e8 10 34 00 00       	call   80106f00 <switchuvm>
  return 0;
80103af0:	83 c4 10             	add    $0x10,%esp
80103af3:	31 c0                	xor    %eax,%eax
}
80103af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103af8:	5b                   	pop    %ebx
80103af9:	5e                   	pop    %esi
80103afa:	5d                   	pop    %ebp
80103afb:	c3                   	ret
80103afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	push   0x4(%ebx)
80103b0a:	e8 51 36 00 00       	call   80107160 <allocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 cf                	jne    80103ae5 <growproc+0x25>
      return -1;
80103b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b1b:	eb d8                	jmp    80103af5 <growproc+0x35>
80103b1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b20:	83 ec 04             	sub    $0x4,%esp
80103b23:	01 c6                	add    %eax,%esi
80103b25:	56                   	push   %esi
80103b26:	50                   	push   %eax
80103b27:	ff 73 04             	push   0x4(%ebx)
80103b2a:	e8 51 37 00 00       	call   80107280 <deallocuvm>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	85 c0                	test   %eax,%eax
80103b34:	75 af                	jne    80103ae5 <growproc+0x25>
80103b36:	eb de                	jmp    80103b16 <growproc+0x56>
80103b38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b3f:	00 

80103b40 <fork>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	57                   	push   %edi
80103b44:	56                   	push   %esi
80103b45:	53                   	push   %ebx
80103b46:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b49:	e8 b2 0c 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103b4e:	e8 cd fd ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103b53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b59:	e8 f2 0c 00 00       	call   80104850 <popcli>
  if((np = allocproc()) == 0){
80103b5e:	e8 3d fc ff ff       	call   801037a0 <allocproc>
80103b63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b66:	85 c0                	test   %eax,%eax
80103b68:	0f 84 d6 00 00 00    	je     80103c44 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b6e:	83 ec 08             	sub    $0x8,%esp
80103b71:	ff 33                	push   (%ebx)
80103b73:	89 c7                	mov    %eax,%edi
80103b75:	ff 73 04             	push   0x4(%ebx)
80103b78:	e8 a3 38 00 00       	call   80107420 <copyuvm>
80103b7d:	83 c4 10             	add    $0x10,%esp
80103b80:	89 47 04             	mov    %eax,0x4(%edi)
80103b83:	85 c0                	test   %eax,%eax
80103b85:	0f 84 9a 00 00 00    	je     80103c25 <fork+0xe5>
  np->sz = curproc->sz;
80103b8b:	8b 03                	mov    (%ebx),%eax
80103b8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b90:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b92:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b95:	89 c8                	mov    %ecx,%eax
80103b97:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b9a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b9f:	8b 73 18             	mov    0x18(%ebx),%esi
80103ba2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ba4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ba6:	8b 40 18             	mov    0x18(%eax),%eax
80103ba9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103bb0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bb4:	85 c0                	test   %eax,%eax
80103bb6:	74 13                	je     80103bcb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bb8:	83 ec 0c             	sub    $0xc,%esp
80103bbb:	50                   	push   %eax
80103bbc:	e8 ff d2 ff ff       	call   80100ec0 <filedup>
80103bc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bc4:	83 c4 10             	add    $0x10,%esp
80103bc7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bcb:	83 c6 01             	add    $0x1,%esi
80103bce:	83 fe 10             	cmp    $0x10,%esi
80103bd1:	75 dd                	jne    80103bb0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bd3:	83 ec 0c             	sub    $0xc,%esp
80103bd6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bdc:	e8 8f db ff ff       	call   80101770 <idup>
80103be1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103be7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bea:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bed:	6a 10                	push   $0x10
80103bef:	53                   	push   %ebx
80103bf0:	50                   	push   %eax
80103bf1:	e8 0a 10 00 00       	call   80104c00 <safestrcpy>
  pid = np->pid;
80103bf6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bf9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c00:	e8 4b 0d 00 00       	call   80104950 <acquire>
  np->state = RUNNABLE;
80103c05:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c0c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c13:	e8 d8 0c 00 00       	call   801048f0 <release>
  return pid;
80103c18:	83 c4 10             	add    $0x10,%esp
}
80103c1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c1e:	89 d8                	mov    %ebx,%eax
80103c20:	5b                   	pop    %ebx
80103c21:	5e                   	pop    %esi
80103c22:	5f                   	pop    %edi
80103c23:	5d                   	pop    %ebp
80103c24:	c3                   	ret
    kfree(np->kstack);
80103c25:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c28:	83 ec 0c             	sub    $0xc,%esp
80103c2b:	ff 73 08             	push   0x8(%ebx)
80103c2e:	e8 6d e8 ff ff       	call   801024a0 <kfree>
    np->kstack = 0;
80103c33:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c3a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c3d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c44:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c49:	eb d0                	jmp    80103c1b <fork+0xdb>
80103c4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103c50 <scheduler>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c59:	e8 c2 fc ff ff       	call   80103920 <mycpu>
  c->proc = 0;
80103c5e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c65:	00 00 00 
  struct cpu *c = mycpu();
80103c68:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c6a:	8d 78 04             	lea    0x4(%eax),%edi
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c70:	fb                   	sti
    acquire(&ptable.lock);
80103c71:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c74:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103c79:	68 20 2d 11 80       	push   $0x80112d20
80103c7e:	e8 cd 0c 00 00       	call   80104950 <acquire>
80103c83:	83 c4 10             	add    $0x10,%esp
80103c86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c8d:	00 
80103c8e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103c90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c94:	75 63                	jne    80103cf9 <scheduler+0xa9>
      switchuvm(p);
80103c96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c9f:	53                   	push   %ebx
80103ca0:	e8 5b 32 00 00       	call   80106f00 <switchuvm>
      p->current_slice = p->extra_slice;
80103ca5:	8b 83 98 00 00 00    	mov    0x98(%ebx),%eax
      p->context_switches_in += 1;
80103cab:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)
      p->wtime += ticks - p->snapticks;
80103caf:	8b 15 60 54 11 80    	mov    0x80115460,%edx
      p->state = RUNNING;
80103cb5:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      p->current_slice = p->extra_slice;
80103cbc:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
      p->wtime += ticks - p->snapticks;
80103cc2:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103cc8:	01 d0                	add    %edx,%eax
80103cca:	2b 83 8c 00 00 00    	sub    0x8c(%ebx),%eax
      p->snapticks = ticks;
80103cd0:	89 93 8c 00 00 00    	mov    %edx,0x8c(%ebx)
      p->wtime += ticks - p->snapticks;
80103cd6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
      swtch(&(c->scheduler), p->context);
80103cdc:	58                   	pop    %eax
80103cdd:	5a                   	pop    %edx
80103cde:	ff 73 1c             	push   0x1c(%ebx)
80103ce1:	57                   	push   %edi
80103ce2:	e8 74 0f 00 00       	call   80104c5b <swtch>
      switchkvm();
80103ce7:	e8 04 32 00 00       	call   80106ef0 <switchkvm>
      c->proc = 0;
80103cec:	83 c4 10             	add    $0x10,%esp
80103cef:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cf6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf9:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103cff:	81 fb 54 54 11 80    	cmp    $0x80115454,%ebx
80103d05:	75 89                	jne    80103c90 <scheduler+0x40>
    release(&ptable.lock);
80103d07:	83 ec 0c             	sub    $0xc,%esp
80103d0a:	68 20 2d 11 80       	push   $0x80112d20
80103d0f:	e8 dc 0b 00 00       	call   801048f0 <release>
    sti();
80103d14:	83 c4 10             	add    $0x10,%esp
80103d17:	e9 54 ff ff ff       	jmp    80103c70 <scheduler+0x20>
80103d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d20 <sched>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	56                   	push   %esi
80103d24:	53                   	push   %ebx
  pushcli();
80103d25:	e8 d6 0a 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103d2a:	e8 f1 fb ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103d2f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d35:	e8 16 0b 00 00       	call   80104850 <popcli>
  if(!holding(&ptable.lock))
80103d3a:	83 ec 0c             	sub    $0xc,%esp
80103d3d:	68 20 2d 11 80       	push   $0x80112d20
80103d42:	e8 69 0b 00 00       	call   801048b0 <holding>
80103d47:	83 c4 10             	add    $0x10,%esp
80103d4a:	85 c0                	test   %eax,%eax
80103d4c:	74 56                	je     80103da4 <sched+0x84>
  if(mycpu()->ncli != 1)
80103d4e:	e8 cd fb ff ff       	call   80103920 <mycpu>
80103d53:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d5a:	75 6f                	jne    80103dcb <sched+0xab>
  if(p->state == RUNNING)
80103d5c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d60:	74 5c                	je     80103dbe <sched+0x9e>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d62:	9c                   	pushf
80103d63:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d64:	f6 c4 02             	test   $0x2,%ah
80103d67:	75 48                	jne    80103db1 <sched+0x91>
  intena = mycpu()->intena;
80103d69:	e8 b2 fb ff ff       	call   80103920 <mycpu>
80103d6e:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  p->context_switches_out += 1;
80103d74:	83 83 80 00 00 00 01 	addl   $0x1,0x80(%ebx)
  swtch(&p->context, mycpu()->scheduler);
80103d7b:	83 c3 1c             	add    $0x1c,%ebx
80103d7e:	e8 9d fb ff ff       	call   80103920 <mycpu>
80103d83:	83 ec 08             	sub    $0x8,%esp
80103d86:	ff 70 04             	push   0x4(%eax)
80103d89:	53                   	push   %ebx
80103d8a:	e8 cc 0e 00 00       	call   80104c5b <swtch>
  mycpu()->intena = intena;
80103d8f:	e8 8c fb ff ff       	call   80103920 <mycpu>
}
80103d94:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d97:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103da0:	5b                   	pop    %ebx
80103da1:	5e                   	pop    %esi
80103da2:	5d                   	pop    %ebp
80103da3:	c3                   	ret
    panic("sched ptable.lock");
80103da4:	83 ec 0c             	sub    $0xc,%esp
80103da7:	68 11 79 10 80       	push   $0x80107911
80103dac:	e8 cf c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103db1:	83 ec 0c             	sub    $0xc,%esp
80103db4:	68 3d 79 10 80       	push   $0x8010793d
80103db9:	e8 c2 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103dbe:	83 ec 0c             	sub    $0xc,%esp
80103dc1:	68 2f 79 10 80       	push   $0x8010792f
80103dc6:	e8 b5 c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103dcb:	83 ec 0c             	sub    $0xc,%esp
80103dce:	68 23 79 10 80       	push   $0x80107923
80103dd3:	e8 a8 c5 ff ff       	call   80100380 <panic>
80103dd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ddf:	00 

80103de0 <exit>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
80103de6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103de9:	e8 b2 fb ff ff       	call   801039a0 <myproc>
  if(curproc == initproc)
80103dee:	39 05 54 54 11 80    	cmp    %eax,0x80115454
80103df4:	0f 84 27 01 00 00    	je     80103f21 <exit+0x141>
80103dfa:	89 c3                	mov    %eax,%ebx
80103dfc:	8d 70 28             	lea    0x28(%eax),%esi
80103dff:	8d 78 68             	lea    0x68(%eax),%edi
80103e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e08:	8b 06                	mov    (%esi),%eax
80103e0a:	85 c0                	test   %eax,%eax
80103e0c:	74 12                	je     80103e20 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e0e:	83 ec 0c             	sub    $0xc,%esp
80103e11:	50                   	push   %eax
80103e12:	e8 f9 d0 ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
80103e17:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e1d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e20:	83 c6 04             	add    $0x4,%esi
80103e23:	39 fe                	cmp    %edi,%esi
80103e25:	75 e1                	jne    80103e08 <exit+0x28>
  begin_op();
80103e27:	e8 14 ef ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
80103e2c:	83 ec 0c             	sub    $0xc,%esp
80103e2f:	ff 73 68             	push   0x68(%ebx)
80103e32:	e8 99 da ff ff       	call   801018d0 <iput>
  end_op();
80103e37:	e8 74 ef ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
80103e3c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e43:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e4a:	e8 01 0b 00 00       	call   80104950 <acquire>
  wakeup1(curproc->parent);
80103e4f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e52:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e55:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e5a:	eb 10                	jmp    80103e6c <exit+0x8c>
80103e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e60:	05 9c 00 00 00       	add    $0x9c,%eax
80103e65:	3d 54 54 11 80       	cmp    $0x80115454,%eax
80103e6a:	74 1e                	je     80103e8a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
80103e6c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e70:	75 ee                	jne    80103e60 <exit+0x80>
80103e72:	3b 50 20             	cmp    0x20(%eax),%edx
80103e75:	75 e9                	jne    80103e60 <exit+0x80>
      p->state = RUNNABLE;
80103e77:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e7e:	05 9c 00 00 00       	add    $0x9c,%eax
80103e83:	3d 54 54 11 80       	cmp    $0x80115454,%eax
80103e88:	75 e2                	jne    80103e6c <exit+0x8c>
      p->parent = initproc;
80103e8a:	8b 0d 54 54 11 80    	mov    0x80115454,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e90:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e95:	eb 17                	jmp    80103eae <exit+0xce>
80103e97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e9e:	00 
80103e9f:	90                   	nop
80103ea0:	81 c2 9c 00 00 00    	add    $0x9c,%edx
80103ea6:	81 fa 54 54 11 80    	cmp    $0x80115454,%edx
80103eac:	74 3a                	je     80103ee8 <exit+0x108>
    if(p->parent == curproc){
80103eae:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103eb1:	75 ed                	jne    80103ea0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103eb3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103eb7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103eba:	75 e4                	jne    80103ea0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ebc:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ec1:	eb 11                	jmp    80103ed4 <exit+0xf4>
80103ec3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ec8:	05 9c 00 00 00       	add    $0x9c,%eax
80103ecd:	3d 54 54 11 80       	cmp    $0x80115454,%eax
80103ed2:	74 cc                	je     80103ea0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103ed4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ed8:	75 ee                	jne    80103ec8 <exit+0xe8>
80103eda:	3b 48 20             	cmp    0x20(%eax),%ecx
80103edd:	75 e9                	jne    80103ec8 <exit+0xe8>
      p->state = RUNNABLE;
80103edf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ee6:	eb e0                	jmp    80103ec8 <exit+0xe8>
  curproc->rtime += (ticks - curproc->snapticks);
80103ee8:	8b 15 60 54 11 80    	mov    0x80115460,%edx
80103eee:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
  curproc->state = ZOMBIE;
80103ef4:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  curproc->rtime += (ticks - curproc->snapticks);
80103efb:	01 d0                	add    %edx,%eax
80103efd:	2b 83 8c 00 00 00    	sub    0x8c(%ebx),%eax
  curproc->snapticks = ticks;
80103f03:	89 93 8c 00 00 00    	mov    %edx,0x8c(%ebx)
  curproc->rtime += (ticks - curproc->snapticks);
80103f09:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  sched();
80103f0f:	e8 0c fe ff ff       	call   80103d20 <sched>
  panic("zombie exit");
80103f14:	83 ec 0c             	sub    $0xc,%esp
80103f17:	68 5e 79 10 80       	push   $0x8010795e
80103f1c:	e8 5f c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f21:	83 ec 0c             	sub    $0xc,%esp
80103f24:	68 51 79 10 80       	push   $0x80107951
80103f29:	e8 52 c4 ff ff       	call   80100380 <panic>
80103f2e:	66 90                	xchg   %ax,%ax

80103f30 <yield>:
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	57                   	push   %edi
80103f34:	56                   	push   %esi
80103f35:	53                   	push   %ebx
80103f36:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f39:	68 20 2d 11 80       	push   $0x80112d20
80103f3e:	e8 0d 0a 00 00       	call   80104950 <acquire>
  pushcli();
80103f43:	e8 b8 08 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103f48:	e8 d3 f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103f4d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f53:	e8 f8 08 00 00       	call   80104850 <popcli>
  myproc()->state = RUNNABLE;
80103f58:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  myproc()->rtime += (ticks - myproc()->snapticks);
80103f5f:	8b 1d 60 54 11 80    	mov    0x80115460,%ebx
  pushcli();
80103f65:	e8 96 08 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103f6a:	e8 b1 f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103f6f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f75:	e8 d6 08 00 00       	call   80104850 <popcli>
  myproc()->rtime += (ticks - myproc()->snapticks);
80103f7a:	8b be 8c 00 00 00    	mov    0x8c(%esi),%edi
  pushcli();
80103f80:	e8 7b 08 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103f85:	e8 96 f9 ff ff       	call   80103920 <mycpu>
  myproc()->rtime += (ticks - myproc()->snapticks);
80103f8a:	29 fb                	sub    %edi,%ebx
  p = c->proc;
80103f8c:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f92:	e8 b9 08 00 00       	call   80104850 <popcli>
  myproc()->rtime += (ticks - myproc()->snapticks);
80103f97:	01 9e 88 00 00 00    	add    %ebx,0x88(%esi)
  myproc()->snapticks = ticks;
80103f9d:	8b 35 60 54 11 80    	mov    0x80115460,%esi
  pushcli();
80103fa3:	e8 58 08 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103fa8:	e8 73 f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103fad:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fb3:	e8 98 08 00 00       	call   80104850 <popcli>
  myproc()->snapticks = ticks;
80103fb8:	89 b3 8c 00 00 00    	mov    %esi,0x8c(%ebx)
  pushcli();
80103fbe:	e8 3d 08 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103fc3:	e8 58 f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103fc8:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fce:	e8 7d 08 00 00       	call   80104850 <popcli>
  myproc()->current_slice=0;
80103fd3:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103fda:	00 00 00 
  sched();
80103fdd:	e8 3e fd ff ff       	call   80103d20 <sched>
  release(&ptable.lock);
80103fe2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fe9:	e8 02 09 00 00       	call   801048f0 <release>
}
80103fee:	83 c4 10             	add    $0x10,%esp
80103ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ff4:	5b                   	pop    %ebx
80103ff5:	5e                   	pop    %esi
80103ff6:	5f                   	pop    %edi
80103ff7:	5d                   	pop    %ebp
80103ff8:	c3                   	ret
80103ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104000 <sleep>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	83 ec 0c             	sub    $0xc,%esp
80104009:	8b 7d 08             	mov    0x8(%ebp),%edi
8010400c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010400f:	e8 ec 07 00 00       	call   80104800 <pushcli>
  c = mycpu();
80104014:	e8 07 f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80104019:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010401f:	e8 2c 08 00 00       	call   80104850 <popcli>
  if(p == 0)
80104024:	85 db                	test   %ebx,%ebx
80104026:	0f 84 a9 00 00 00    	je     801040d5 <sleep+0xd5>
  if(lk == 0)
8010402c:	85 f6                	test   %esi,%esi
8010402e:	0f 84 94 00 00 00    	je     801040c8 <sleep+0xc8>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104034:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
8010403a:	74 18                	je     80104054 <sleep+0x54>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010403c:	83 ec 0c             	sub    $0xc,%esp
8010403f:	68 20 2d 11 80       	push   $0x80112d20
80104044:	e8 07 09 00 00       	call   80104950 <acquire>
    release(lk);
80104049:	89 34 24             	mov    %esi,(%esp)
8010404c:	e8 9f 08 00 00       	call   801048f0 <release>
80104051:	83 c4 10             	add    $0x10,%esp
  p->rtime += (ticks - p->snapticks);
80104054:	8b 15 60 54 11 80    	mov    0x80115460,%edx
8010405a:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
  p->chan = chan;
80104060:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104063:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  p->current_slice = 0;
8010406a:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80104071:	00 00 00 
  p->rtime += (ticks - p->snapticks);
80104074:	01 d0                	add    %edx,%eax
80104076:	2b 83 8c 00 00 00    	sub    0x8c(%ebx),%eax
8010407c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  p->snapticks = ticks;
80104082:	89 93 8c 00 00 00    	mov    %edx,0x8c(%ebx)
  sched();
80104088:	e8 93 fc ff ff       	call   80103d20 <sched>
  p->chan = 0;
8010408d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104094:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
8010409a:	74 24                	je     801040c0 <sleep+0xc0>
    release(&ptable.lock);
8010409c:	83 ec 0c             	sub    $0xc,%esp
8010409f:	68 20 2d 11 80       	push   $0x80112d20
801040a4:	e8 47 08 00 00       	call   801048f0 <release>
    acquire(lk);
801040a9:	83 c4 10             	add    $0x10,%esp
801040ac:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040b2:	5b                   	pop    %ebx
801040b3:	5e                   	pop    %esi
801040b4:	5f                   	pop    %edi
801040b5:	5d                   	pop    %ebp
    acquire(lk);
801040b6:	e9 95 08 00 00       	jmp    80104950 <acquire>
801040bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
801040c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040c3:	5b                   	pop    %ebx
801040c4:	5e                   	pop    %esi
801040c5:	5f                   	pop    %edi
801040c6:	5d                   	pop    %ebp
801040c7:	c3                   	ret
    panic("sleep without lk");
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	68 70 79 10 80       	push   $0x80107970
801040d0:	e8 ab c2 ff ff       	call   80100380 <panic>
    panic("sleep");
801040d5:	83 ec 0c             	sub    $0xc,%esp
801040d8:	68 6a 79 10 80       	push   $0x8010796a
801040dd:	e8 9e c2 ff ff       	call   80100380 <panic>
801040e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040e9:	00 
801040ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040f0 <wait>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	56                   	push   %esi
801040f4:	53                   	push   %ebx
  pushcli();
801040f5:	e8 06 07 00 00       	call   80104800 <pushcli>
  c = mycpu();
801040fa:	e8 21 f8 ff ff       	call   80103920 <mycpu>
  p = c->proc;
801040ff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104105:	e8 46 07 00 00       	call   80104850 <popcli>
  acquire(&ptable.lock);
8010410a:	83 ec 0c             	sub    $0xc,%esp
8010410d:	68 20 2d 11 80       	push   $0x80112d20
80104112:	e8 39 08 00 00       	call   80104950 <acquire>
80104117:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010411a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104121:	eb 13                	jmp    80104136 <wait+0x46>
80104123:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104128:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
8010412e:	81 fb 54 54 11 80    	cmp    $0x80115454,%ebx
80104134:	74 1e                	je     80104154 <wait+0x64>
      if(p->parent != curproc)
80104136:	39 73 14             	cmp    %esi,0x14(%ebx)
80104139:	75 ed                	jne    80104128 <wait+0x38>
      if(p->state == ZOMBIE){
8010413b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010413f:	74 37                	je     80104178 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104141:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
      havekids = 1;
80104147:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010414c:	81 fb 54 54 11 80    	cmp    $0x80115454,%ebx
80104152:	75 e2                	jne    80104136 <wait+0x46>
    if(!havekids || curproc->killed){
80104154:	85 c0                	test   %eax,%eax
80104156:	74 76                	je     801041ce <wait+0xde>
80104158:	8b 46 24             	mov    0x24(%esi),%eax
8010415b:	85 c0                	test   %eax,%eax
8010415d:	75 6f                	jne    801041ce <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010415f:	83 ec 08             	sub    $0x8,%esp
80104162:	68 20 2d 11 80       	push   $0x80112d20
80104167:	56                   	push   %esi
80104168:	e8 93 fe ff ff       	call   80104000 <sleep>
    havekids = 0;
8010416d:	83 c4 10             	add    $0x10,%esp
80104170:	eb a8                	jmp    8010411a <wait+0x2a>
80104172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104178:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
8010417b:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010417e:	ff 73 08             	push   0x8(%ebx)
80104181:	e8 1a e3 ff ff       	call   801024a0 <kfree>
        p->kstack = 0;
80104186:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010418d:	5a                   	pop    %edx
8010418e:	ff 73 04             	push   0x4(%ebx)
80104191:	e8 1a 31 00 00       	call   801072b0 <freevm>
        p->pid = 0;
80104196:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010419d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041a4:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041a8:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041af:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041b6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801041bd:	e8 2e 07 00 00       	call   801048f0 <release>
        return pid;
801041c2:	83 c4 10             	add    $0x10,%esp
}
801041c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041c8:	89 f0                	mov    %esi,%eax
801041ca:	5b                   	pop    %ebx
801041cb:	5e                   	pop    %esi
801041cc:	5d                   	pop    %ebp
801041cd:	c3                   	ret
      release(&ptable.lock);
801041ce:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041d1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041d6:	68 20 2d 11 80       	push   $0x80112d20
801041db:	e8 10 07 00 00       	call   801048f0 <release>
      return -1;
801041e0:	83 c4 10             	add    $0x10,%esp
801041e3:	eb e0                	jmp    801041c5 <wait+0xd5>
801041e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801041ec:	00 
801041ed:	8d 76 00             	lea    0x0(%esi),%esi

801041f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	53                   	push   %ebx
801041f4:	83 ec 10             	sub    $0x10,%esp
801041f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041fa:	68 20 2d 11 80       	push   $0x80112d20
801041ff:	e8 4c 07 00 00       	call   80104950 <acquire>
80104204:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104207:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010420c:	eb 0e                	jmp    8010421c <wakeup+0x2c>
8010420e:	66 90                	xchg   %ax,%ax
80104210:	05 9c 00 00 00       	add    $0x9c,%eax
80104215:	3d 54 54 11 80       	cmp    $0x80115454,%eax
8010421a:	74 1e                	je     8010423a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010421c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104220:	75 ee                	jne    80104210 <wakeup+0x20>
80104222:	3b 58 20             	cmp    0x20(%eax),%ebx
80104225:	75 e9                	jne    80104210 <wakeup+0x20>
      p->state = RUNNABLE;
80104227:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010422e:	05 9c 00 00 00       	add    $0x9c,%eax
80104233:	3d 54 54 11 80       	cmp    $0x80115454,%eax
80104238:	75 e2                	jne    8010421c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010423a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104241:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104244:	c9                   	leave
  release(&ptable.lock);
80104245:	e9 a6 06 00 00       	jmp    801048f0 <release>
8010424a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104250 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 10             	sub    $0x10,%esp
80104257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010425a:	68 20 2d 11 80       	push   $0x80112d20
8010425f:	e8 ec 06 00 00       	call   80104950 <acquire>
80104264:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104267:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010426c:	eb 0e                	jmp    8010427c <kill+0x2c>
8010426e:	66 90                	xchg   %ax,%ax
80104270:	05 9c 00 00 00       	add    $0x9c,%eax
80104275:	3d 54 54 11 80       	cmp    $0x80115454,%eax
8010427a:	74 34                	je     801042b0 <kill+0x60>
    if(p->pid == pid){
8010427c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010427f:	75 ef                	jne    80104270 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104281:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104285:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010428c:	75 07                	jne    80104295 <kill+0x45>
        p->state = RUNNABLE;
8010428e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104295:	83 ec 0c             	sub    $0xc,%esp
80104298:	68 20 2d 11 80       	push   $0x80112d20
8010429d:	e8 4e 06 00 00       	call   801048f0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801042a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801042a5:	83 c4 10             	add    $0x10,%esp
801042a8:	31 c0                	xor    %eax,%eax
}
801042aa:	c9                   	leave
801042ab:	c3                   	ret
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801042b0:	83 ec 0c             	sub    $0xc,%esp
801042b3:	68 20 2d 11 80       	push   $0x80112d20
801042b8:	e8 33 06 00 00       	call   801048f0 <release>
}
801042bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801042c0:	83 c4 10             	add    $0x10,%esp
801042c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042c8:	c9                   	leave
801042c9:	c3                   	ret
801042ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042d0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	57                   	push   %edi
801042d4:	56                   	push   %esi
801042d5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801042d8:	53                   	push   %ebx
801042d9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801042de:	83 ec 3c             	sub    $0x3c,%esp
801042e1:	eb 27                	jmp    8010430a <procdump+0x3a>
801042e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801042e8:	83 ec 0c             	sub    $0xc,%esp
801042eb:	68 9b 79 10 80       	push   $0x8010799b
801042f0:	e8 bb c3 ff ff       	call   801006b0 <cprintf>
801042f5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042f8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801042fe:	81 fb c0 54 11 80    	cmp    $0x801154c0,%ebx
80104304:	0f 84 7e 00 00 00    	je     80104388 <procdump+0xb8>
    if(p->state == UNUSED)
8010430a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010430d:	85 c0                	test   %eax,%eax
8010430f:	74 e7                	je     801042f8 <procdump+0x28>
      state = "???";
80104311:	ba 81 79 10 80       	mov    $0x80107981,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104316:	83 f8 05             	cmp    $0x5,%eax
80104319:	77 11                	ja     8010432c <procdump+0x5c>
8010431b:	8b 14 85 80 7f 10 80 	mov    -0x7fef8080(,%eax,4),%edx
      state = "???";
80104322:	b8 81 79 10 80       	mov    $0x80107981,%eax
80104327:	85 d2                	test   %edx,%edx
80104329:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010432c:	53                   	push   %ebx
8010432d:	52                   	push   %edx
8010432e:	ff 73 a4             	push   -0x5c(%ebx)
80104331:	68 85 79 10 80       	push   $0x80107985
80104336:	e8 75 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
8010433b:	83 c4 10             	add    $0x10,%esp
8010433e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104342:	75 a4                	jne    801042e8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104344:	83 ec 08             	sub    $0x8,%esp
80104347:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010434a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010434d:	50                   	push   %eax
8010434e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104351:	8b 40 0c             	mov    0xc(%eax),%eax
80104354:	83 c0 08             	add    $0x8,%eax
80104357:	50                   	push   %eax
80104358:	e8 23 04 00 00       	call   80104780 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010435d:	83 c4 10             	add    $0x10,%esp
80104360:	8b 17                	mov    (%edi),%edx
80104362:	85 d2                	test   %edx,%edx
80104364:	74 82                	je     801042e8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104366:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104369:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010436c:	52                   	push   %edx
8010436d:	68 c1 76 10 80       	push   $0x801076c1
80104372:	e8 39 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104377:	83 c4 10             	add    $0x10,%esp
8010437a:	39 f7                	cmp    %esi,%edi
8010437c:	75 e2                	jne    80104360 <procdump+0x90>
8010437e:	e9 65 ff ff ff       	jmp    801042e8 <procdump+0x18>
80104383:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104388:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010438b:	5b                   	pop    %ebx
8010438c:	5e                   	pop    %esi
8010438d:	5f                   	pop    %edi
8010438e:	5d                   	pop    %ebp
8010438f:	c3                   	ret

80104390 <cscount>:


// LAB 6
void
cscount(int pid)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	53                   	push   %ebx
80104394:	83 ec 10             	sub    $0x10,%esp
80104397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010439a:	68 20 2d 11 80       	push   $0x80112d20
8010439f:	e8 ac 05 00 00       	call   80104950 <acquire>
801043a4:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043a7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801043ac:	eb 0e                	jmp    801043bc <cscount+0x2c>
801043ae:	66 90                	xchg   %ax,%ax
801043b0:	05 9c 00 00 00       	add    $0x9c,%eax
801043b5:	3d 54 54 11 80       	cmp    $0x80115454,%eax
801043ba:	74 34                	je     801043f0 <cscount+0x60>
  {
    if (p->pid == pid)
801043bc:	39 58 10             	cmp    %ebx,0x10(%eax)
801043bf:	75 ef                	jne    801043b0 <cscount+0x20>
    {
      cprintf("\npid [%d] switch in [%d],switch out [%d]\n", p->pid, p->context_switches_in, p->context_switches_out);
801043c1:	ff b0 80 00 00 00    	push   0x80(%eax)
801043c7:	ff 70 7c             	push   0x7c(%eax)
801043ca:	53                   	push   %ebx
801043cb:	68 74 7c 10 80       	push   $0x80107c74
801043d0:	e8 db c2 ff ff       	call   801006b0 <cprintf>
      release(&ptable.lock); // Release the lock before returning
801043d5:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  cprintf("Not found !!!\n");

}
801043d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      release(&ptable.lock); // Release the lock before returning
801043db:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801043e2:	c9                   	leave
      release(&ptable.lock); // Release the lock before returning
801043e3:	e9 08 05 00 00       	jmp    801048f0 <release>
801043e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043ef:	00 
  release(&ptable.lock);
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	68 20 2d 11 80       	push   $0x80112d20
801043f8:	e8 f3 04 00 00       	call   801048f0 <release>
  cprintf("Not found !!!\n");
801043fd:	83 c4 10             	add    $0x10,%esp
}
80104400:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  cprintf("Not found !!!\n");
80104403:	c7 45 08 8e 79 10 80 	movl   $0x8010798e,0x8(%ebp)
}
8010440a:	c9                   	leave
  cprintf("Not found !!!\n");
8010440b:	e9 a0 c2 ff ff       	jmp    801006b0 <cprintf>

80104410 <wait2>:

int
wait2(int *wtime, int *rtime)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	56                   	push   %esi
80104414:	53                   	push   %ebx
  pushcli();
80104415:	e8 e6 03 00 00       	call   80104800 <pushcli>
  c = mycpu();
8010441a:	e8 01 f5 ff ff       	call   80103920 <mycpu>
  p = c->proc;
8010441f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104425:	e8 26 04 00 00       	call   80104850 <popcli>
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
8010442a:	83 ec 0c             	sub    $0xc,%esp
8010442d:	68 20 2d 11 80       	push   $0x80112d20
80104432:	e8 19 05 00 00       	call   80104950 <acquire>
80104437:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010443a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010443c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104441:	eb 13                	jmp    80104456 <wait2+0x46>
80104443:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104448:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
8010444e:	81 fb 54 54 11 80    	cmp    $0x80115454,%ebx
80104454:	74 1e                	je     80104474 <wait2+0x64>
      if(p->parent != curproc)
80104456:	39 73 14             	cmp    %esi,0x14(%ebx)
80104459:	75 ed                	jne    80104448 <wait2+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010445b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010445f:	74 3f                	je     801044a0 <wait2+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104461:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
      havekids = 1;
80104467:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010446c:	81 fb 54 54 11 80    	cmp    $0x80115454,%ebx
80104472:	75 e2                	jne    80104456 <wait2+0x46>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104474:	85 c0                	test   %eax,%eax
80104476:	0f 84 a4 00 00 00    	je     80104520 <wait2+0x110>
8010447c:	8b 46 24             	mov    0x24(%esi),%eax
8010447f:	85 c0                	test   %eax,%eax
80104481:	0f 85 99 00 00 00    	jne    80104520 <wait2+0x110>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104487:	83 ec 08             	sub    $0x8,%esp
8010448a:	68 20 2d 11 80       	push   $0x80112d20
8010448f:	56                   	push   %esi
80104490:	e8 6b fb ff ff       	call   80104000 <sleep>
    havekids = 0;
80104495:	83 c4 10             	add    $0x10,%esp
80104498:	eb a0                	jmp    8010443a <wait2+0x2a>
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        *wtime = p->wtime;
801044a0:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
801044a6:	8b 45 08             	mov    0x8(%ebp),%eax
        kfree(p->kstack);
801044a9:	83 ec 0c             	sub    $0xc,%esp
        *wtime = p->wtime;
801044ac:	89 10                	mov    %edx,(%eax)
        *rtime = p->rtime;
801044ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801044b1:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
801044b7:	89 10                	mov    %edx,(%eax)
        pid = p->pid;
801044b9:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801044bc:	ff 73 08             	push   0x8(%ebx)
801044bf:	e8 dc df ff ff       	call   801024a0 <kfree>
        p->kstack = 0;
801044c4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801044cb:	5a                   	pop    %edx
801044cc:	ff 73 04             	push   0x4(%ebx)
801044cf:	e8 dc 2d 00 00       	call   801072b0 <freevm>
        p->pid = 0;
801044d4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801044db:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801044e2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801044e6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->wtime = 0;
801044ed:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801044f4:	00 00 00 
        p->rtime = 0;
801044f7:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
801044fe:	00 00 00 
        p->state = UNUSED;
80104501:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104508:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010450f:	e8 dc 03 00 00       	call   801048f0 <release>
        return pid;
80104514:	83 c4 10             	add    $0x10,%esp
  }
}
80104517:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010451a:	89 f0                	mov    %esi,%eax
8010451c:	5b                   	pop    %ebx
8010451d:	5e                   	pop    %esi
8010451e:	5d                   	pop    %ebp
8010451f:	c3                   	ret
      release(&ptable.lock);
80104520:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104523:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104528:	68 20 2d 11 80       	push   $0x80112d20
8010452d:	e8 be 03 00 00       	call   801048f0 <release>
      return -1;
80104532:	83 c4 10             	add    $0x10,%esp
80104535:	eb e0                	jmp    80104517 <wait2+0x107>
80104537:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010453e:	00 
8010453f:	90                   	nop

80104540 <set_priority>:


int
set_priority(int pid, int priority)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	53                   	push   %ebx
80104544:	83 ec 10             	sub    $0x10,%esp
80104547:	8b 5d 08             	mov    0x8(%ebp),%ebx

  struct proc* p;
  acquire(&ptable.lock);
8010454a:	68 20 2d 11 80       	push   $0x80112d20
8010454f:	e8 fc 03 00 00       	call   80104950 <acquire>
80104554:	83 c4 10             	add    $0x10,%esp
  
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104557:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010455c:	eb 10                	jmp    8010456e <set_priority+0x2e>
8010455e:	66 90                	xchg   %ax,%ax
80104560:	81 c2 9c 00 00 00    	add    $0x9c,%edx
80104566:	81 fa 54 54 11 80    	cmp    $0x80115454,%edx
8010456c:	74 2a                	je     80104598 <set_priority+0x58>
    if (p->pid == pid) {
8010456e:	39 5a 10             	cmp    %ebx,0x10(%edx)
80104571:	75 ed                	jne    80104560 <set_priority+0x20>
      p->priority = priority;
80104573:	8b 45 0c             	mov    0xc(%ebp),%eax
      release(&ptable.lock);
80104576:	83 ec 0c             	sub    $0xc,%esp
      p->priority = priority;
80104579:	89 82 90 00 00 00    	mov    %eax,0x90(%edx)
      release(&ptable.lock);
8010457f:	68 20 2d 11 80       	push   $0x80112d20
80104584:	e8 67 03 00 00       	call   801048f0 <release>
      return pid;
80104589:	89 d8                	mov    %ebx,%eax
8010458b:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
}
8010458e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104591:	c9                   	leave
80104592:	c3                   	ret
80104593:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104598:	83 ec 0c             	sub    $0xc,%esp
8010459b:	68 20 2d 11 80       	push   $0x80112d20
801045a0:	e8 4b 03 00 00       	call   801048f0 <release>
}
801045a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801045a8:	83 c4 10             	add    $0x10,%esp
801045ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045b0:	c9                   	leave
801045b1:	c3                   	ret
801045b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045b9:	00 
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045c0 <set_quanta>:


int
set_quanta(int pid, int quanta)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p;

  acquire(&ptable.lock);
801045cb:	83 ec 0c             	sub    $0xc,%esp
801045ce:	68 20 2d 11 80       	push   $0x80112d20
801045d3:	e8 78 03 00 00       	call   80104950 <acquire>
  acquire(&tickslock);
801045d8:	c7 04 24 80 54 11 80 	movl   $0x80115480,(%esp)
801045df:	e8 6c 03 00 00       	call   80104950 <acquire>
801045e4:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045e7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801045ec:	eb 0e                	jmp    801045fc <set_quanta+0x3c>
801045ee:	66 90                	xchg   %ax,%ax
801045f0:	05 9c 00 00 00       	add    $0x9c,%eax
801045f5:	3d 54 54 11 80       	cmp    $0x80115454,%eax
801045fa:	74 0b                	je     80104607 <set_quanta+0x47>
  {
    if (p->pid == pid)
801045fc:	39 58 10             	cmp    %ebx,0x10(%eax)
801045ff:	75 ef                	jne    801045f0 <set_quanta+0x30>
    {
      p->extra_slice = quanta;
80104601:	89 b0 98 00 00 00    	mov    %esi,0x98(%eax)
      break;
    }
  }
  release(&ptable.lock);
80104607:	83 ec 0c             	sub    $0xc,%esp
8010460a:	68 20 2d 11 80       	push   $0x80112d20
8010460f:	e8 dc 02 00 00       	call   801048f0 <release>
  release(&tickslock);
80104614:	c7 04 24 80 54 11 80 	movl   $0x80115480,(%esp)
8010461b:	e8 d0 02 00 00       	call   801048f0 <release>

  return quanta;
80104620:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104623:	89 f0                	mov    %esi,%eax
80104625:	5b                   	pop    %ebx
80104626:	5e                   	pop    %esi
80104627:	5d                   	pop    %ebp
80104628:	c3                   	ret
80104629:	66 90                	xchg   %ax,%ax
8010462b:	66 90                	xchg   %ax,%ax
8010462d:	66 90                	xchg   %ax,%ax
8010462f:	90                   	nop

80104630 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	53                   	push   %ebx
80104634:	83 ec 0c             	sub    $0xc,%esp
80104637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010463a:	68 c7 79 10 80       	push   $0x801079c7
8010463f:	8d 43 04             	lea    0x4(%ebx),%eax
80104642:	50                   	push   %eax
80104643:	e8 18 01 00 00       	call   80104760 <initlock>
  lk->name = name;
80104648:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010464b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104651:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104654:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010465b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010465e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104661:	c9                   	leave
80104662:	c3                   	ret
80104663:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010466a:	00 
8010466b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104670 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104678:	8d 73 04             	lea    0x4(%ebx),%esi
8010467b:	83 ec 0c             	sub    $0xc,%esp
8010467e:	56                   	push   %esi
8010467f:	e8 cc 02 00 00       	call   80104950 <acquire>
  while (lk->locked) {
80104684:	8b 13                	mov    (%ebx),%edx
80104686:	83 c4 10             	add    $0x10,%esp
80104689:	85 d2                	test   %edx,%edx
8010468b:	74 16                	je     801046a3 <acquiresleep+0x33>
8010468d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104690:	83 ec 08             	sub    $0x8,%esp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	e8 66 f9 ff ff       	call   80104000 <sleep>
  while (lk->locked) {
8010469a:	8b 03                	mov    (%ebx),%eax
8010469c:	83 c4 10             	add    $0x10,%esp
8010469f:	85 c0                	test   %eax,%eax
801046a1:	75 ed                	jne    80104690 <acquiresleep+0x20>
  }
  lk->locked = 1;
801046a3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801046a9:	e8 f2 f2 ff ff       	call   801039a0 <myproc>
801046ae:	8b 40 10             	mov    0x10(%eax),%eax
801046b1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801046b4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801046b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046ba:	5b                   	pop    %ebx
801046bb:	5e                   	pop    %esi
801046bc:	5d                   	pop    %ebp
  release(&lk->lk);
801046bd:	e9 2e 02 00 00       	jmp    801048f0 <release>
801046c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046c9:	00 
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046d0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
801046d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046d8:	8d 73 04             	lea    0x4(%ebx),%esi
801046db:	83 ec 0c             	sub    $0xc,%esp
801046de:	56                   	push   %esi
801046df:	e8 6c 02 00 00       	call   80104950 <acquire>
  lk->locked = 0;
801046e4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046ea:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801046f1:	89 1c 24             	mov    %ebx,(%esp)
801046f4:	e8 f7 fa ff ff       	call   801041f0 <wakeup>
  release(&lk->lk);
801046f9:	83 c4 10             	add    $0x10,%esp
801046fc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801046ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104702:	5b                   	pop    %ebx
80104703:	5e                   	pop    %esi
80104704:	5d                   	pop    %ebp
  release(&lk->lk);
80104705:	e9 e6 01 00 00       	jmp    801048f0 <release>
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104710 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	57                   	push   %edi
80104714:	31 ff                	xor    %edi,%edi
80104716:	56                   	push   %esi
80104717:	53                   	push   %ebx
80104718:	83 ec 18             	sub    $0x18,%esp
8010471b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010471e:	8d 73 04             	lea    0x4(%ebx),%esi
80104721:	56                   	push   %esi
80104722:	e8 29 02 00 00       	call   80104950 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104727:	8b 03                	mov    (%ebx),%eax
80104729:	83 c4 10             	add    $0x10,%esp
8010472c:	85 c0                	test   %eax,%eax
8010472e:	75 18                	jne    80104748 <holdingsleep+0x38>
  release(&lk->lk);
80104730:	83 ec 0c             	sub    $0xc,%esp
80104733:	56                   	push   %esi
80104734:	e8 b7 01 00 00       	call   801048f0 <release>
  return r;
}
80104739:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010473c:	89 f8                	mov    %edi,%eax
8010473e:	5b                   	pop    %ebx
8010473f:	5e                   	pop    %esi
80104740:	5f                   	pop    %edi
80104741:	5d                   	pop    %ebp
80104742:	c3                   	ret
80104743:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104748:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010474b:	e8 50 f2 ff ff       	call   801039a0 <myproc>
80104750:	39 58 10             	cmp    %ebx,0x10(%eax)
80104753:	0f 94 c0             	sete   %al
80104756:	0f b6 c0             	movzbl %al,%eax
80104759:	89 c7                	mov    %eax,%edi
8010475b:	eb d3                	jmp    80104730 <holdingsleep+0x20>
8010475d:	66 90                	xchg   %ax,%ax
8010475f:	90                   	nop

80104760 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104766:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104769:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010476f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104772:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104779:	5d                   	pop    %ebp
8010477a:	c3                   	ret
8010477b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104780 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	8b 45 08             	mov    0x8(%ebp),%eax
80104787:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010478a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010478d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104792:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104797:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010479c:	76 10                	jbe    801047ae <getcallerpcs+0x2e>
8010479e:	eb 28                	jmp    801047c8 <getcallerpcs+0x48>
801047a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801047a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047ac:	77 1a                	ja     801047c8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801047ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801047b1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801047b4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801047b7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801047b9:	83 f8 0a             	cmp    $0xa,%eax
801047bc:	75 e2                	jne    801047a0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801047be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047c1:	c9                   	leave
801047c2:	c3                   	ret
801047c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801047c8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801047cb:	83 c1 28             	add    $0x28,%ecx
801047ce:	89 ca                	mov    %ecx,%edx
801047d0:	29 c2                	sub    %eax,%edx
801047d2:	83 e2 04             	and    $0x4,%edx
801047d5:	74 11                	je     801047e8 <getcallerpcs+0x68>
    pcs[i] = 0;
801047d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047dd:	83 c0 04             	add    $0x4,%eax
801047e0:	39 c1                	cmp    %eax,%ecx
801047e2:	74 da                	je     801047be <getcallerpcs+0x3e>
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801047e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047ee:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801047f1:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801047f8:	39 c1                	cmp    %eax,%ecx
801047fa:	75 ec                	jne    801047e8 <getcallerpcs+0x68>
801047fc:	eb c0                	jmp    801047be <getcallerpcs+0x3e>
801047fe:	66 90                	xchg   %ax,%ax

80104800 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
80104804:	83 ec 04             	sub    $0x4,%esp
80104807:	9c                   	pushf
80104808:	5b                   	pop    %ebx
  asm volatile("cli");
80104809:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010480a:	e8 11 f1 ff ff       	call   80103920 <mycpu>
8010480f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104815:	85 c0                	test   %eax,%eax
80104817:	74 17                	je     80104830 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104819:	e8 02 f1 ff ff       	call   80103920 <mycpu>
8010481e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104828:	c9                   	leave
80104829:	c3                   	ret
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104830:	e8 eb f0 ff ff       	call   80103920 <mycpu>
80104835:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010483b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104841:	eb d6                	jmp    80104819 <pushcli+0x19>
80104843:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010484a:	00 
8010484b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104850 <popcli>:

void
popcli(void)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104856:	9c                   	pushf
80104857:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104858:	f6 c4 02             	test   $0x2,%ah
8010485b:	75 35                	jne    80104892 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010485d:	e8 be f0 ff ff       	call   80103920 <mycpu>
80104862:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104869:	78 34                	js     8010489f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010486b:	e8 b0 f0 ff ff       	call   80103920 <mycpu>
80104870:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104876:	85 d2                	test   %edx,%edx
80104878:	74 06                	je     80104880 <popcli+0x30>
    sti();
}
8010487a:	c9                   	leave
8010487b:	c3                   	ret
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104880:	e8 9b f0 ff ff       	call   80103920 <mycpu>
80104885:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010488b:	85 c0                	test   %eax,%eax
8010488d:	74 eb                	je     8010487a <popcli+0x2a>
  asm volatile("sti");
8010488f:	fb                   	sti
}
80104890:	c9                   	leave
80104891:	c3                   	ret
    panic("popcli - interruptible");
80104892:	83 ec 0c             	sub    $0xc,%esp
80104895:	68 d2 79 10 80       	push   $0x801079d2
8010489a:	e8 e1 ba ff ff       	call   80100380 <panic>
    panic("popcli");
8010489f:	83 ec 0c             	sub    $0xc,%esp
801048a2:	68 e9 79 10 80       	push   $0x801079e9
801048a7:	e8 d4 ba ff ff       	call   80100380 <panic>
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048b0 <holding>:
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
801048b5:	8b 75 08             	mov    0x8(%ebp),%esi
801048b8:	31 db                	xor    %ebx,%ebx
  pushcli();
801048ba:	e8 41 ff ff ff       	call   80104800 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048bf:	8b 06                	mov    (%esi),%eax
801048c1:	85 c0                	test   %eax,%eax
801048c3:	75 0b                	jne    801048d0 <holding+0x20>
  popcli();
801048c5:	e8 86 ff ff ff       	call   80104850 <popcli>
}
801048ca:	89 d8                	mov    %ebx,%eax
801048cc:	5b                   	pop    %ebx
801048cd:	5e                   	pop    %esi
801048ce:	5d                   	pop    %ebp
801048cf:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801048d0:	8b 5e 08             	mov    0x8(%esi),%ebx
801048d3:	e8 48 f0 ff ff       	call   80103920 <mycpu>
801048d8:	39 c3                	cmp    %eax,%ebx
801048da:	0f 94 c3             	sete   %bl
  popcli();
801048dd:	e8 6e ff ff ff       	call   80104850 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801048e2:	0f b6 db             	movzbl %bl,%ebx
}
801048e5:	89 d8                	mov    %ebx,%eax
801048e7:	5b                   	pop    %ebx
801048e8:	5e                   	pop    %esi
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret
801048eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801048f0 <release>:
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	53                   	push   %ebx
801048f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801048f8:	e8 03 ff ff ff       	call   80104800 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048fd:	8b 03                	mov    (%ebx),%eax
801048ff:	85 c0                	test   %eax,%eax
80104901:	75 15                	jne    80104918 <release+0x28>
  popcli();
80104903:	e8 48 ff ff ff       	call   80104850 <popcli>
    panic("release");
80104908:	83 ec 0c             	sub    $0xc,%esp
8010490b:	68 f0 79 10 80       	push   $0x801079f0
80104910:	e8 6b ba ff ff       	call   80100380 <panic>
80104915:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104918:	8b 73 08             	mov    0x8(%ebx),%esi
8010491b:	e8 00 f0 ff ff       	call   80103920 <mycpu>
80104920:	39 c6                	cmp    %eax,%esi
80104922:	75 df                	jne    80104903 <release+0x13>
  popcli();
80104924:	e8 27 ff ff ff       	call   80104850 <popcli>
  lk->pcs[0] = 0;
80104929:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104930:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104937:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010493c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104942:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104945:	5b                   	pop    %ebx
80104946:	5e                   	pop    %esi
80104947:	5d                   	pop    %ebp
  popcli();
80104948:	e9 03 ff ff ff       	jmp    80104850 <popcli>
8010494d:	8d 76 00             	lea    0x0(%esi),%esi

80104950 <acquire>:
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
80104954:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104957:	e8 a4 fe ff ff       	call   80104800 <pushcli>
  if(holding(lk))
8010495c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010495f:	e8 9c fe ff ff       	call   80104800 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104964:	8b 03                	mov    (%ebx),%eax
80104966:	85 c0                	test   %eax,%eax
80104968:	0f 85 b2 00 00 00    	jne    80104a20 <acquire+0xd0>
  popcli();
8010496e:	e8 dd fe ff ff       	call   80104850 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104973:	b9 01 00 00 00       	mov    $0x1,%ecx
80104978:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010497f:	00 
  while(xchg(&lk->locked, 1) != 0)
80104980:	8b 55 08             	mov    0x8(%ebp),%edx
80104983:	89 c8                	mov    %ecx,%eax
80104985:	f0 87 02             	lock xchg %eax,(%edx)
80104988:	85 c0                	test   %eax,%eax
8010498a:	75 f4                	jne    80104980 <acquire+0x30>
  __sync_synchronize();
8010498c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104991:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104994:	e8 87 ef ff ff       	call   80103920 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104999:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010499c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010499e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049a1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801049a7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801049ac:	77 32                	ja     801049e0 <acquire+0x90>
  ebp = (uint*)v - 2;
801049ae:	89 e8                	mov    %ebp,%eax
801049b0:	eb 14                	jmp    801049c6 <acquire+0x76>
801049b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049b8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801049be:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801049c4:	77 1a                	ja     801049e0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801049c6:	8b 58 04             	mov    0x4(%eax),%ebx
801049c9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801049cd:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801049d0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801049d2:	83 fa 0a             	cmp    $0xa,%edx
801049d5:	75 e1                	jne    801049b8 <acquire+0x68>
}
801049d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049da:	c9                   	leave
801049db:	c3                   	ret
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
801049e4:	83 c1 34             	add    $0x34,%ecx
801049e7:	89 ca                	mov    %ecx,%edx
801049e9:	29 c2                	sub    %eax,%edx
801049eb:	83 e2 04             	and    $0x4,%edx
801049ee:	74 10                	je     80104a00 <acquire+0xb0>
    pcs[i] = 0;
801049f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049f6:	83 c0 04             	add    $0x4,%eax
801049f9:	39 c1                	cmp    %eax,%ecx
801049fb:	74 da                	je     801049d7 <acquire+0x87>
801049fd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104a00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104a06:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104a09:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104a10:	39 c1                	cmp    %eax,%ecx
80104a12:	75 ec                	jne    80104a00 <acquire+0xb0>
80104a14:	eb c1                	jmp    801049d7 <acquire+0x87>
80104a16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a1d:	00 
80104a1e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104a20:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104a23:	e8 f8 ee ff ff       	call   80103920 <mycpu>
80104a28:	39 c3                	cmp    %eax,%ebx
80104a2a:	0f 85 3e ff ff ff    	jne    8010496e <acquire+0x1e>
  popcli();
80104a30:	e8 1b fe ff ff       	call   80104850 <popcli>
    panic("acquire");
80104a35:	83 ec 0c             	sub    $0xc,%esp
80104a38:	68 f8 79 10 80       	push   $0x801079f8
80104a3d:	e8 3e b9 ff ff       	call   80100380 <panic>
80104a42:	66 90                	xchg   %ax,%ax
80104a44:	66 90                	xchg   %ax,%ax
80104a46:	66 90                	xchg   %ax,%ax
80104a48:	66 90                	xchg   %ax,%ax
80104a4a:	66 90                	xchg   %ax,%ax
80104a4c:	66 90                	xchg   %ax,%ax
80104a4e:	66 90                	xchg   %ax,%ax

80104a50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	57                   	push   %edi
80104a54:	8b 55 08             	mov    0x8(%ebp),%edx
80104a57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104a5a:	89 d0                	mov    %edx,%eax
80104a5c:	09 c8                	or     %ecx,%eax
80104a5e:	a8 03                	test   $0x3,%al
80104a60:	75 1e                	jne    80104a80 <memset+0x30>
    c &= 0xFF;
80104a62:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a66:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104a69:	89 d7                	mov    %edx,%edi
80104a6b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104a71:	fc                   	cld
80104a72:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104a74:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104a77:	89 d0                	mov    %edx,%eax
80104a79:	c9                   	leave
80104a7a:	c3                   	ret
80104a7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104a80:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a83:	89 d7                	mov    %edx,%edi
80104a85:	fc                   	cld
80104a86:	f3 aa                	rep stos %al,%es:(%edi)
80104a88:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104a8b:	89 d0                	mov    %edx,%eax
80104a8d:	c9                   	leave
80104a8e:	c3                   	ret
80104a8f:	90                   	nop

80104a90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	8b 75 10             	mov    0x10(%ebp),%esi
80104a97:	8b 45 08             	mov    0x8(%ebp),%eax
80104a9a:	53                   	push   %ebx
80104a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a9e:	85 f6                	test   %esi,%esi
80104aa0:	74 2e                	je     80104ad0 <memcmp+0x40>
80104aa2:	01 c6                	add    %eax,%esi
80104aa4:	eb 14                	jmp    80104aba <memcmp+0x2a>
80104aa6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104aad:	00 
80104aae:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104ab0:	83 c0 01             	add    $0x1,%eax
80104ab3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104ab6:	39 f0                	cmp    %esi,%eax
80104ab8:	74 16                	je     80104ad0 <memcmp+0x40>
    if(*s1 != *s2)
80104aba:	0f b6 08             	movzbl (%eax),%ecx
80104abd:	0f b6 1a             	movzbl (%edx),%ebx
80104ac0:	38 d9                	cmp    %bl,%cl
80104ac2:	74 ec                	je     80104ab0 <memcmp+0x20>
      return *s1 - *s2;
80104ac4:	0f b6 c1             	movzbl %cl,%eax
80104ac7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104ac9:	5b                   	pop    %ebx
80104aca:	5e                   	pop    %esi
80104acb:	5d                   	pop    %ebp
80104acc:	c3                   	ret
80104acd:	8d 76 00             	lea    0x0(%esi),%esi
80104ad0:	5b                   	pop    %ebx
  return 0;
80104ad1:	31 c0                	xor    %eax,%eax
}
80104ad3:	5e                   	pop    %esi
80104ad4:	5d                   	pop    %ebp
80104ad5:	c3                   	ret
80104ad6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104add:	00 
80104ade:	66 90                	xchg   %ax,%ax

80104ae0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	57                   	push   %edi
80104ae4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ae7:	8b 45 10             	mov    0x10(%ebp),%eax
80104aea:	56                   	push   %esi
80104aeb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104aee:	39 d6                	cmp    %edx,%esi
80104af0:	73 26                	jae    80104b18 <memmove+0x38>
80104af2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104af5:	39 ca                	cmp    %ecx,%edx
80104af7:	73 1f                	jae    80104b18 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104af9:	85 c0                	test   %eax,%eax
80104afb:	74 0f                	je     80104b0c <memmove+0x2c>
80104afd:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104b00:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104b04:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104b07:	83 e8 01             	sub    $0x1,%eax
80104b0a:	73 f4                	jae    80104b00 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b0c:	5e                   	pop    %esi
80104b0d:	89 d0                	mov    %edx,%eax
80104b0f:	5f                   	pop    %edi
80104b10:	5d                   	pop    %ebp
80104b11:	c3                   	ret
80104b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104b18:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104b1b:	89 d7                	mov    %edx,%edi
80104b1d:	85 c0                	test   %eax,%eax
80104b1f:	74 eb                	je     80104b0c <memmove+0x2c>
80104b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104b28:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104b29:	39 ce                	cmp    %ecx,%esi
80104b2b:	75 fb                	jne    80104b28 <memmove+0x48>
}
80104b2d:	5e                   	pop    %esi
80104b2e:	89 d0                	mov    %edx,%eax
80104b30:	5f                   	pop    %edi
80104b31:	5d                   	pop    %ebp
80104b32:	c3                   	ret
80104b33:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b3a:	00 
80104b3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104b40 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104b40:	eb 9e                	jmp    80104ae0 <memmove>
80104b42:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b49:	00 
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	53                   	push   %ebx
80104b54:	8b 55 10             	mov    0x10(%ebp),%edx
80104b57:	8b 45 08             	mov    0x8(%ebp),%eax
80104b5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104b5d:	85 d2                	test   %edx,%edx
80104b5f:	75 16                	jne    80104b77 <strncmp+0x27>
80104b61:	eb 2d                	jmp    80104b90 <strncmp+0x40>
80104b63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b68:	3a 19                	cmp    (%ecx),%bl
80104b6a:	75 12                	jne    80104b7e <strncmp+0x2e>
    n--, p++, q++;
80104b6c:	83 c0 01             	add    $0x1,%eax
80104b6f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104b72:	83 ea 01             	sub    $0x1,%edx
80104b75:	74 19                	je     80104b90 <strncmp+0x40>
80104b77:	0f b6 18             	movzbl (%eax),%ebx
80104b7a:	84 db                	test   %bl,%bl
80104b7c:	75 ea                	jne    80104b68 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b7e:	0f b6 00             	movzbl (%eax),%eax
80104b81:	0f b6 11             	movzbl (%ecx),%edx
}
80104b84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b87:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104b88:	29 d0                	sub    %edx,%eax
}
80104b8a:	c3                   	ret
80104b8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104b93:	31 c0                	xor    %eax,%eax
}
80104b95:	c9                   	leave
80104b96:	c3                   	ret
80104b97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b9e:	00 
80104b9f:	90                   	nop

80104ba0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	57                   	push   %edi
80104ba4:	56                   	push   %esi
80104ba5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ba8:	53                   	push   %ebx
80104ba9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104bac:	89 f0                	mov    %esi,%eax
80104bae:	eb 15                	jmp    80104bc5 <strncpy+0x25>
80104bb0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104bb4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104bb7:	83 c0 01             	add    $0x1,%eax
80104bba:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104bbe:	88 48 ff             	mov    %cl,-0x1(%eax)
80104bc1:	84 c9                	test   %cl,%cl
80104bc3:	74 13                	je     80104bd8 <strncpy+0x38>
80104bc5:	89 d3                	mov    %edx,%ebx
80104bc7:	83 ea 01             	sub    $0x1,%edx
80104bca:	85 db                	test   %ebx,%ebx
80104bcc:	7f e2                	jg     80104bb0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104bce:	5b                   	pop    %ebx
80104bcf:	89 f0                	mov    %esi,%eax
80104bd1:	5e                   	pop    %esi
80104bd2:	5f                   	pop    %edi
80104bd3:	5d                   	pop    %ebp
80104bd4:	c3                   	ret
80104bd5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104bd8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104bdb:	83 e9 01             	sub    $0x1,%ecx
80104bde:	85 d2                	test   %edx,%edx
80104be0:	74 ec                	je     80104bce <strncpy+0x2e>
80104be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104be8:	83 c0 01             	add    $0x1,%eax
80104beb:	89 ca                	mov    %ecx,%edx
80104bed:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104bf1:	29 c2                	sub    %eax,%edx
80104bf3:	85 d2                	test   %edx,%edx
80104bf5:	7f f1                	jg     80104be8 <strncpy+0x48>
}
80104bf7:	5b                   	pop    %ebx
80104bf8:	89 f0                	mov    %esi,%eax
80104bfa:	5e                   	pop    %esi
80104bfb:	5f                   	pop    %edi
80104bfc:	5d                   	pop    %ebp
80104bfd:	c3                   	ret
80104bfe:	66 90                	xchg   %ax,%ax

80104c00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	56                   	push   %esi
80104c04:	8b 55 10             	mov    0x10(%ebp),%edx
80104c07:	8b 75 08             	mov    0x8(%ebp),%esi
80104c0a:	53                   	push   %ebx
80104c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104c0e:	85 d2                	test   %edx,%edx
80104c10:	7e 25                	jle    80104c37 <safestrcpy+0x37>
80104c12:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104c16:	89 f2                	mov    %esi,%edx
80104c18:	eb 16                	jmp    80104c30 <safestrcpy+0x30>
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104c20:	0f b6 08             	movzbl (%eax),%ecx
80104c23:	83 c0 01             	add    $0x1,%eax
80104c26:	83 c2 01             	add    $0x1,%edx
80104c29:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c2c:	84 c9                	test   %cl,%cl
80104c2e:	74 04                	je     80104c34 <safestrcpy+0x34>
80104c30:	39 d8                	cmp    %ebx,%eax
80104c32:	75 ec                	jne    80104c20 <safestrcpy+0x20>
    ;
  *s = 0;
80104c34:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104c37:	89 f0                	mov    %esi,%eax
80104c39:	5b                   	pop    %ebx
80104c3a:	5e                   	pop    %esi
80104c3b:	5d                   	pop    %ebp
80104c3c:	c3                   	ret
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi

80104c40 <strlen>:

int
strlen(const char *s)
{
80104c40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c41:	31 c0                	xor    %eax,%eax
{
80104c43:	89 e5                	mov    %esp,%ebp
80104c45:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c48:	80 3a 00             	cmpb   $0x0,(%edx)
80104c4b:	74 0c                	je     80104c59 <strlen+0x19>
80104c4d:	8d 76 00             	lea    0x0(%esi),%esi
80104c50:	83 c0 01             	add    $0x1,%eax
80104c53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c57:	75 f7                	jne    80104c50 <strlen+0x10>
    ;
  return n;
}
80104c59:	5d                   	pop    %ebp
80104c5a:	c3                   	ret

80104c5b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104c63:	55                   	push   %ebp
  pushl %ebx
80104c64:	53                   	push   %ebx
  pushl %esi
80104c65:	56                   	push   %esi
  pushl %edi
80104c66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c69:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104c6b:	5f                   	pop    %edi
  popl %esi
80104c6c:	5e                   	pop    %esi
  popl %ebx
80104c6d:	5b                   	pop    %ebx
  popl %ebp
80104c6e:	5d                   	pop    %ebp
  ret
80104c6f:	c3                   	ret

80104c70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	53                   	push   %ebx
80104c74:	83 ec 04             	sub    $0x4,%esp
80104c77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c7a:	e8 21 ed ff ff       	call   801039a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c7f:	8b 00                	mov    (%eax),%eax
80104c81:	39 c3                	cmp    %eax,%ebx
80104c83:	73 1b                	jae    80104ca0 <fetchint+0x30>
80104c85:	8d 53 04             	lea    0x4(%ebx),%edx
80104c88:	39 d0                	cmp    %edx,%eax
80104c8a:	72 14                	jb     80104ca0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c8f:	8b 13                	mov    (%ebx),%edx
80104c91:	89 10                	mov    %edx,(%eax)
  return 0;
80104c93:	31 c0                	xor    %eax,%eax
}
80104c95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c98:	c9                   	leave
80104c99:	c3                   	ret
80104c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ca5:	eb ee                	jmp    80104c95 <fetchint+0x25>
80104ca7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cae:	00 
80104caf:	90                   	nop

80104cb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	53                   	push   %ebx
80104cb4:	83 ec 04             	sub    $0x4,%esp
80104cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104cba:	e8 e1 ec ff ff       	call   801039a0 <myproc>

  if(addr >= curproc->sz)
80104cbf:	3b 18                	cmp    (%eax),%ebx
80104cc1:	73 2d                	jae    80104cf0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cc6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104cc8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104cca:	39 d3                	cmp    %edx,%ebx
80104ccc:	73 22                	jae    80104cf0 <fetchstr+0x40>
80104cce:	89 d8                	mov    %ebx,%eax
80104cd0:	eb 0d                	jmp    80104cdf <fetchstr+0x2f>
80104cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cd8:	83 c0 01             	add    $0x1,%eax
80104cdb:	39 d0                	cmp    %edx,%eax
80104cdd:	73 11                	jae    80104cf0 <fetchstr+0x40>
    if(*s == 0)
80104cdf:	80 38 00             	cmpb   $0x0,(%eax)
80104ce2:	75 f4                	jne    80104cd8 <fetchstr+0x28>
      return s - *pp;
80104ce4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ce6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ce9:	c9                   	leave
80104cea:	c3                   	ret
80104ceb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104cf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cf8:	c9                   	leave
80104cf9:	c3                   	ret
80104cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d00 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	56                   	push   %esi
80104d04:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d05:	e8 96 ec ff ff       	call   801039a0 <myproc>
80104d0a:	8b 55 08             	mov    0x8(%ebp),%edx
80104d0d:	8b 40 18             	mov    0x18(%eax),%eax
80104d10:	8b 40 44             	mov    0x44(%eax),%eax
80104d13:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d16:	e8 85 ec ff ff       	call   801039a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d1b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d1e:	8b 00                	mov    (%eax),%eax
80104d20:	39 c6                	cmp    %eax,%esi
80104d22:	73 1c                	jae    80104d40 <argint+0x40>
80104d24:	8d 53 08             	lea    0x8(%ebx),%edx
80104d27:	39 d0                	cmp    %edx,%eax
80104d29:	72 15                	jb     80104d40 <argint+0x40>
  *ip = *(int*)(addr);
80104d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d2e:	8b 53 04             	mov    0x4(%ebx),%edx
80104d31:	89 10                	mov    %edx,(%eax)
  return 0;
80104d33:	31 c0                	xor    %eax,%eax
}
80104d35:	5b                   	pop    %ebx
80104d36:	5e                   	pop    %esi
80104d37:	5d                   	pop    %ebp
80104d38:	c3                   	ret
80104d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d45:	eb ee                	jmp    80104d35 <argint+0x35>
80104d47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d4e:	00 
80104d4f:	90                   	nop

80104d50 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	57                   	push   %edi
80104d54:	56                   	push   %esi
80104d55:	53                   	push   %ebx
80104d56:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104d59:	e8 42 ec ff ff       	call   801039a0 <myproc>
80104d5e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d60:	e8 3b ec ff ff       	call   801039a0 <myproc>
80104d65:	8b 55 08             	mov    0x8(%ebp),%edx
80104d68:	8b 40 18             	mov    0x18(%eax),%eax
80104d6b:	8b 40 44             	mov    0x44(%eax),%eax
80104d6e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d71:	e8 2a ec ff ff       	call   801039a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d76:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d79:	8b 00                	mov    (%eax),%eax
80104d7b:	39 c7                	cmp    %eax,%edi
80104d7d:	73 31                	jae    80104db0 <argptr+0x60>
80104d7f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104d82:	39 c8                	cmp    %ecx,%eax
80104d84:	72 2a                	jb     80104db0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d86:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104d89:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d8c:	85 d2                	test   %edx,%edx
80104d8e:	78 20                	js     80104db0 <argptr+0x60>
80104d90:	8b 16                	mov    (%esi),%edx
80104d92:	39 d0                	cmp    %edx,%eax
80104d94:	73 1a                	jae    80104db0 <argptr+0x60>
80104d96:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d99:	01 c3                	add    %eax,%ebx
80104d9b:	39 da                	cmp    %ebx,%edx
80104d9d:	72 11                	jb     80104db0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104da2:	89 02                	mov    %eax,(%edx)
  return 0;
80104da4:	31 c0                	xor    %eax,%eax
}
80104da6:	83 c4 0c             	add    $0xc,%esp
80104da9:	5b                   	pop    %ebx
80104daa:	5e                   	pop    %esi
80104dab:	5f                   	pop    %edi
80104dac:	5d                   	pop    %ebp
80104dad:	c3                   	ret
80104dae:	66 90                	xchg   %ax,%ax
    return -1;
80104db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104db5:	eb ef                	jmp    80104da6 <argptr+0x56>
80104db7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dbe:	00 
80104dbf:	90                   	nop

80104dc0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	56                   	push   %esi
80104dc4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104dc5:	e8 d6 eb ff ff       	call   801039a0 <myproc>
80104dca:	8b 55 08             	mov    0x8(%ebp),%edx
80104dcd:	8b 40 18             	mov    0x18(%eax),%eax
80104dd0:	8b 40 44             	mov    0x44(%eax),%eax
80104dd3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104dd6:	e8 c5 eb ff ff       	call   801039a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ddb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dde:	8b 00                	mov    (%eax),%eax
80104de0:	39 c6                	cmp    %eax,%esi
80104de2:	73 44                	jae    80104e28 <argstr+0x68>
80104de4:	8d 53 08             	lea    0x8(%ebx),%edx
80104de7:	39 d0                	cmp    %edx,%eax
80104de9:	72 3d                	jb     80104e28 <argstr+0x68>
  *ip = *(int*)(addr);
80104deb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104dee:	e8 ad eb ff ff       	call   801039a0 <myproc>
  if(addr >= curproc->sz)
80104df3:	3b 18                	cmp    (%eax),%ebx
80104df5:	73 31                	jae    80104e28 <argstr+0x68>
  *pp = (char*)addr;
80104df7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dfa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104dfc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104dfe:	39 d3                	cmp    %edx,%ebx
80104e00:	73 26                	jae    80104e28 <argstr+0x68>
80104e02:	89 d8                	mov    %ebx,%eax
80104e04:	eb 11                	jmp    80104e17 <argstr+0x57>
80104e06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e0d:	00 
80104e0e:	66 90                	xchg   %ax,%ax
80104e10:	83 c0 01             	add    $0x1,%eax
80104e13:	39 d0                	cmp    %edx,%eax
80104e15:	73 11                	jae    80104e28 <argstr+0x68>
    if(*s == 0)
80104e17:	80 38 00             	cmpb   $0x0,(%eax)
80104e1a:	75 f4                	jne    80104e10 <argstr+0x50>
      return s - *pp;
80104e1c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104e1e:	5b                   	pop    %ebx
80104e1f:	5e                   	pop    %esi
80104e20:	5d                   	pop    %ebp
80104e21:	c3                   	ret
80104e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e28:	5b                   	pop    %ebx
    return -1;
80104e29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e2e:	5e                   	pop    %esi
80104e2f:	5d                   	pop    %ebp
80104e30:	c3                   	ret
80104e31:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e38:	00 
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e40 <syscall>:
[SYS_set_quanta]   sys_set_quanta,
};

void
syscall(void)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	53                   	push   %ebx
80104e44:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104e47:	e8 54 eb ff ff       	call   801039a0 <myproc>
80104e4c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104e4e:	8b 40 18             	mov    0x18(%eax),%eax
80104e51:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e54:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e57:	83 fa 18             	cmp    $0x18,%edx
80104e5a:	77 24                	ja     80104e80 <syscall+0x40>
80104e5c:	8b 14 85 a0 7f 10 80 	mov    -0x7fef8060(,%eax,4),%edx
80104e63:	85 d2                	test   %edx,%edx
80104e65:	74 19                	je     80104e80 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104e67:	ff d2                	call   *%edx
80104e69:	89 c2                	mov    %eax,%edx
80104e6b:	8b 43 18             	mov    0x18(%ebx),%eax
80104e6e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e74:	c9                   	leave
80104e75:	c3                   	ret
80104e76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e7d:	00 
80104e7e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104e80:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e81:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e84:	50                   	push   %eax
80104e85:	ff 73 10             	push   0x10(%ebx)
80104e88:	68 00 7a 10 80       	push   $0x80107a00
80104e8d:	e8 1e b8 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104e92:	8b 43 18             	mov    0x18(%ebx),%eax
80104e95:	83 c4 10             	add    $0x10,%esp
80104e98:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ea2:	c9                   	leave
80104ea3:	c3                   	ret
80104ea4:	66 90                	xchg   %ax,%ax
80104ea6:	66 90                	xchg   %ax,%ax
80104ea8:	66 90                	xchg   %ax,%ax
80104eaa:	66 90                	xchg   %ax,%ax
80104eac:	66 90                	xchg   %ax,%ax
80104eae:	66 90                	xchg   %ax,%ax

80104eb0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	57                   	push   %edi
80104eb4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104eb5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104eb8:	53                   	push   %ebx
80104eb9:	83 ec 34             	sub    $0x34,%esp
80104ebc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104ebf:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ec2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ec5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104ec8:	57                   	push   %edi
80104ec9:	50                   	push   %eax
80104eca:	e8 d1 d1 ff ff       	call   801020a0 <nameiparent>
80104ecf:	83 c4 10             	add    $0x10,%esp
80104ed2:	85 c0                	test   %eax,%eax
80104ed4:	74 5e                	je     80104f34 <create+0x84>
    return 0;
  ilock(dp);
80104ed6:	83 ec 0c             	sub    $0xc,%esp
80104ed9:	89 c3                	mov    %eax,%ebx
80104edb:	50                   	push   %eax
80104edc:	e8 bf c8 ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104ee1:	83 c4 0c             	add    $0xc,%esp
80104ee4:	6a 00                	push   $0x0
80104ee6:	57                   	push   %edi
80104ee7:	53                   	push   %ebx
80104ee8:	e8 03 ce ff ff       	call   80101cf0 <dirlookup>
80104eed:	83 c4 10             	add    $0x10,%esp
80104ef0:	89 c6                	mov    %eax,%esi
80104ef2:	85 c0                	test   %eax,%eax
80104ef4:	74 4a                	je     80104f40 <create+0x90>
    iunlockput(dp);
80104ef6:	83 ec 0c             	sub    $0xc,%esp
80104ef9:	53                   	push   %ebx
80104efa:	e8 31 cb ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80104eff:	89 34 24             	mov    %esi,(%esp)
80104f02:	e8 99 c8 ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f07:	83 c4 10             	add    $0x10,%esp
80104f0a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104f0f:	75 17                	jne    80104f28 <create+0x78>
80104f11:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104f16:	75 10                	jne    80104f28 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f1b:	89 f0                	mov    %esi,%eax
80104f1d:	5b                   	pop    %ebx
80104f1e:	5e                   	pop    %esi
80104f1f:	5f                   	pop    %edi
80104f20:	5d                   	pop    %ebp
80104f21:	c3                   	ret
80104f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104f28:	83 ec 0c             	sub    $0xc,%esp
80104f2b:	56                   	push   %esi
80104f2c:	e8 ff ca ff ff       	call   80101a30 <iunlockput>
    return 0;
80104f31:	83 c4 10             	add    $0x10,%esp
}
80104f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104f37:	31 f6                	xor    %esi,%esi
}
80104f39:	5b                   	pop    %ebx
80104f3a:	89 f0                	mov    %esi,%eax
80104f3c:	5e                   	pop    %esi
80104f3d:	5f                   	pop    %edi
80104f3e:	5d                   	pop    %ebp
80104f3f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104f40:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104f44:	83 ec 08             	sub    $0x8,%esp
80104f47:	50                   	push   %eax
80104f48:	ff 33                	push   (%ebx)
80104f4a:	e8 e1 c6 ff ff       	call   80101630 <ialloc>
80104f4f:	83 c4 10             	add    $0x10,%esp
80104f52:	89 c6                	mov    %eax,%esi
80104f54:	85 c0                	test   %eax,%eax
80104f56:	0f 84 bc 00 00 00    	je     80105018 <create+0x168>
  ilock(ip);
80104f5c:	83 ec 0c             	sub    $0xc,%esp
80104f5f:	50                   	push   %eax
80104f60:	e8 3b c8 ff ff       	call   801017a0 <ilock>
  ip->major = major;
80104f65:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104f69:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104f6d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104f71:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104f75:	b8 01 00 00 00       	mov    $0x1,%eax
80104f7a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104f7e:	89 34 24             	mov    %esi,(%esp)
80104f81:	e8 6a c7 ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f86:	83 c4 10             	add    $0x10,%esp
80104f89:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104f8e:	74 30                	je     80104fc0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104f90:	83 ec 04             	sub    $0x4,%esp
80104f93:	ff 76 04             	push   0x4(%esi)
80104f96:	57                   	push   %edi
80104f97:	53                   	push   %ebx
80104f98:	e8 23 d0 ff ff       	call   80101fc0 <dirlink>
80104f9d:	83 c4 10             	add    $0x10,%esp
80104fa0:	85 c0                	test   %eax,%eax
80104fa2:	78 67                	js     8010500b <create+0x15b>
  iunlockput(dp);
80104fa4:	83 ec 0c             	sub    $0xc,%esp
80104fa7:	53                   	push   %ebx
80104fa8:	e8 83 ca ff ff       	call   80101a30 <iunlockput>
  return ip;
80104fad:	83 c4 10             	add    $0x10,%esp
}
80104fb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fb3:	89 f0                	mov    %esi,%eax
80104fb5:	5b                   	pop    %ebx
80104fb6:	5e                   	pop    %esi
80104fb7:	5f                   	pop    %edi
80104fb8:	5d                   	pop    %ebp
80104fb9:	c3                   	ret
80104fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104fc0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104fc3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104fc8:	53                   	push   %ebx
80104fc9:	e8 22 c7 ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104fce:	83 c4 0c             	add    $0xc,%esp
80104fd1:	ff 76 04             	push   0x4(%esi)
80104fd4:	68 38 7a 10 80       	push   $0x80107a38
80104fd9:	56                   	push   %esi
80104fda:	e8 e1 cf ff ff       	call   80101fc0 <dirlink>
80104fdf:	83 c4 10             	add    $0x10,%esp
80104fe2:	85 c0                	test   %eax,%eax
80104fe4:	78 18                	js     80104ffe <create+0x14e>
80104fe6:	83 ec 04             	sub    $0x4,%esp
80104fe9:	ff 73 04             	push   0x4(%ebx)
80104fec:	68 37 7a 10 80       	push   $0x80107a37
80104ff1:	56                   	push   %esi
80104ff2:	e8 c9 cf ff ff       	call   80101fc0 <dirlink>
80104ff7:	83 c4 10             	add    $0x10,%esp
80104ffa:	85 c0                	test   %eax,%eax
80104ffc:	79 92                	jns    80104f90 <create+0xe0>
      panic("create dots");
80104ffe:	83 ec 0c             	sub    $0xc,%esp
80105001:	68 2b 7a 10 80       	push   $0x80107a2b
80105006:	e8 75 b3 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
8010500b:	83 ec 0c             	sub    $0xc,%esp
8010500e:	68 3a 7a 10 80       	push   $0x80107a3a
80105013:	e8 68 b3 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105018:	83 ec 0c             	sub    $0xc,%esp
8010501b:	68 1c 7a 10 80       	push   $0x80107a1c
80105020:	e8 5b b3 ff ff       	call   80100380 <panic>
80105025:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010502c:	00 
8010502d:	8d 76 00             	lea    0x0(%esi),%esi

80105030 <sys_dup>:
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105035:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105038:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010503b:	50                   	push   %eax
8010503c:	6a 00                	push   $0x0
8010503e:	e8 bd fc ff ff       	call   80104d00 <argint>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	85 c0                	test   %eax,%eax
80105048:	78 36                	js     80105080 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010504a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010504e:	77 30                	ja     80105080 <sys_dup+0x50>
80105050:	e8 4b e9 ff ff       	call   801039a0 <myproc>
80105055:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105058:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010505c:	85 f6                	test   %esi,%esi
8010505e:	74 20                	je     80105080 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105060:	e8 3b e9 ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105065:	31 db                	xor    %ebx,%ebx
80105067:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010506e:	00 
8010506f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80105070:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105074:	85 d2                	test   %edx,%edx
80105076:	74 18                	je     80105090 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105078:	83 c3 01             	add    $0x1,%ebx
8010507b:	83 fb 10             	cmp    $0x10,%ebx
8010507e:	75 f0                	jne    80105070 <sys_dup+0x40>
}
80105080:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105083:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105088:	89 d8                	mov    %ebx,%eax
8010508a:	5b                   	pop    %ebx
8010508b:	5e                   	pop    %esi
8010508c:	5d                   	pop    %ebp
8010508d:	c3                   	ret
8010508e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105090:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105093:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105097:	56                   	push   %esi
80105098:	e8 23 be ff ff       	call   80100ec0 <filedup>
  return fd;
8010509d:	83 c4 10             	add    $0x10,%esp
}
801050a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050a3:	89 d8                	mov    %ebx,%eax
801050a5:	5b                   	pop    %ebx
801050a6:	5e                   	pop    %esi
801050a7:	5d                   	pop    %ebp
801050a8:	c3                   	ret
801050a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801050b0 <sys_read>:
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	56                   	push   %esi
801050b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050b5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050bb:	53                   	push   %ebx
801050bc:	6a 00                	push   $0x0
801050be:	e8 3d fc ff ff       	call   80104d00 <argint>
801050c3:	83 c4 10             	add    $0x10,%esp
801050c6:	85 c0                	test   %eax,%eax
801050c8:	78 5e                	js     80105128 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ce:	77 58                	ja     80105128 <sys_read+0x78>
801050d0:	e8 cb e8 ff ff       	call   801039a0 <myproc>
801050d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050d8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050dc:	85 f6                	test   %esi,%esi
801050de:	74 48                	je     80105128 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050e0:	83 ec 08             	sub    $0x8,%esp
801050e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050e6:	50                   	push   %eax
801050e7:	6a 02                	push   $0x2
801050e9:	e8 12 fc ff ff       	call   80104d00 <argint>
801050ee:	83 c4 10             	add    $0x10,%esp
801050f1:	85 c0                	test   %eax,%eax
801050f3:	78 33                	js     80105128 <sys_read+0x78>
801050f5:	83 ec 04             	sub    $0x4,%esp
801050f8:	ff 75 f0             	push   -0x10(%ebp)
801050fb:	53                   	push   %ebx
801050fc:	6a 01                	push   $0x1
801050fe:	e8 4d fc ff ff       	call   80104d50 <argptr>
80105103:	83 c4 10             	add    $0x10,%esp
80105106:	85 c0                	test   %eax,%eax
80105108:	78 1e                	js     80105128 <sys_read+0x78>
  return fileread(f, p, n);
8010510a:	83 ec 04             	sub    $0x4,%esp
8010510d:	ff 75 f0             	push   -0x10(%ebp)
80105110:	ff 75 f4             	push   -0xc(%ebp)
80105113:	56                   	push   %esi
80105114:	e8 27 bf ff ff       	call   80101040 <fileread>
80105119:	83 c4 10             	add    $0x10,%esp
}
8010511c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010511f:	5b                   	pop    %ebx
80105120:	5e                   	pop    %esi
80105121:	5d                   	pop    %ebp
80105122:	c3                   	ret
80105123:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010512d:	eb ed                	jmp    8010511c <sys_read+0x6c>
8010512f:	90                   	nop

80105130 <sys_write>:
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	56                   	push   %esi
80105134:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105135:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105138:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010513b:	53                   	push   %ebx
8010513c:	6a 00                	push   $0x0
8010513e:	e8 bd fb ff ff       	call   80104d00 <argint>
80105143:	83 c4 10             	add    $0x10,%esp
80105146:	85 c0                	test   %eax,%eax
80105148:	78 5e                	js     801051a8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010514a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010514e:	77 58                	ja     801051a8 <sys_write+0x78>
80105150:	e8 4b e8 ff ff       	call   801039a0 <myproc>
80105155:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105158:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010515c:	85 f6                	test   %esi,%esi
8010515e:	74 48                	je     801051a8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105160:	83 ec 08             	sub    $0x8,%esp
80105163:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105166:	50                   	push   %eax
80105167:	6a 02                	push   $0x2
80105169:	e8 92 fb ff ff       	call   80104d00 <argint>
8010516e:	83 c4 10             	add    $0x10,%esp
80105171:	85 c0                	test   %eax,%eax
80105173:	78 33                	js     801051a8 <sys_write+0x78>
80105175:	83 ec 04             	sub    $0x4,%esp
80105178:	ff 75 f0             	push   -0x10(%ebp)
8010517b:	53                   	push   %ebx
8010517c:	6a 01                	push   $0x1
8010517e:	e8 cd fb ff ff       	call   80104d50 <argptr>
80105183:	83 c4 10             	add    $0x10,%esp
80105186:	85 c0                	test   %eax,%eax
80105188:	78 1e                	js     801051a8 <sys_write+0x78>
  return filewrite(f, p, n);
8010518a:	83 ec 04             	sub    $0x4,%esp
8010518d:	ff 75 f0             	push   -0x10(%ebp)
80105190:	ff 75 f4             	push   -0xc(%ebp)
80105193:	56                   	push   %esi
80105194:	e8 37 bf ff ff       	call   801010d0 <filewrite>
80105199:	83 c4 10             	add    $0x10,%esp
}
8010519c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010519f:	5b                   	pop    %ebx
801051a0:	5e                   	pop    %esi
801051a1:	5d                   	pop    %ebp
801051a2:	c3                   	ret
801051a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
801051a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ad:	eb ed                	jmp    8010519c <sys_write+0x6c>
801051af:	90                   	nop

801051b0 <sys_close>:
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	56                   	push   %esi
801051b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801051b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051bb:	50                   	push   %eax
801051bc:	6a 00                	push   $0x0
801051be:	e8 3d fb ff ff       	call   80104d00 <argint>
801051c3:	83 c4 10             	add    $0x10,%esp
801051c6:	85 c0                	test   %eax,%eax
801051c8:	78 3e                	js     80105208 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051ce:	77 38                	ja     80105208 <sys_close+0x58>
801051d0:	e8 cb e7 ff ff       	call   801039a0 <myproc>
801051d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051d8:	8d 5a 08             	lea    0x8(%edx),%ebx
801051db:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801051df:	85 f6                	test   %esi,%esi
801051e1:	74 25                	je     80105208 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801051e3:	e8 b8 e7 ff ff       	call   801039a0 <myproc>
  fileclose(f);
801051e8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801051eb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801051f2:	00 
  fileclose(f);
801051f3:	56                   	push   %esi
801051f4:	e8 17 bd ff ff       	call   80100f10 <fileclose>
  return 0;
801051f9:	83 c4 10             	add    $0x10,%esp
801051fc:	31 c0                	xor    %eax,%eax
}
801051fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105201:	5b                   	pop    %ebx
80105202:	5e                   	pop    %esi
80105203:	5d                   	pop    %ebp
80105204:	c3                   	ret
80105205:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105208:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520d:	eb ef                	jmp    801051fe <sys_close+0x4e>
8010520f:	90                   	nop

80105210 <sys_fstat>:
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	56                   	push   %esi
80105214:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105215:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105218:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010521b:	53                   	push   %ebx
8010521c:	6a 00                	push   $0x0
8010521e:	e8 dd fa ff ff       	call   80104d00 <argint>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	78 46                	js     80105270 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010522a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010522e:	77 40                	ja     80105270 <sys_fstat+0x60>
80105230:	e8 6b e7 ff ff       	call   801039a0 <myproc>
80105235:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105238:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010523c:	85 f6                	test   %esi,%esi
8010523e:	74 30                	je     80105270 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105240:	83 ec 04             	sub    $0x4,%esp
80105243:	6a 14                	push   $0x14
80105245:	53                   	push   %ebx
80105246:	6a 01                	push   $0x1
80105248:	e8 03 fb ff ff       	call   80104d50 <argptr>
8010524d:	83 c4 10             	add    $0x10,%esp
80105250:	85 c0                	test   %eax,%eax
80105252:	78 1c                	js     80105270 <sys_fstat+0x60>
  return filestat(f, st);
80105254:	83 ec 08             	sub    $0x8,%esp
80105257:	ff 75 f4             	push   -0xc(%ebp)
8010525a:	56                   	push   %esi
8010525b:	e8 90 bd ff ff       	call   80100ff0 <filestat>
80105260:	83 c4 10             	add    $0x10,%esp
}
80105263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105266:	5b                   	pop    %ebx
80105267:	5e                   	pop    %esi
80105268:	5d                   	pop    %ebp
80105269:	c3                   	ret
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105275:	eb ec                	jmp    80105263 <sys_fstat+0x53>
80105277:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010527e:	00 
8010527f:	90                   	nop

80105280 <sys_link>:
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105285:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105288:	53                   	push   %ebx
80105289:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010528c:	50                   	push   %eax
8010528d:	6a 00                	push   $0x0
8010528f:	e8 2c fb ff ff       	call   80104dc0 <argstr>
80105294:	83 c4 10             	add    $0x10,%esp
80105297:	85 c0                	test   %eax,%eax
80105299:	0f 88 fb 00 00 00    	js     8010539a <sys_link+0x11a>
8010529f:	83 ec 08             	sub    $0x8,%esp
801052a2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801052a5:	50                   	push   %eax
801052a6:	6a 01                	push   $0x1
801052a8:	e8 13 fb ff ff       	call   80104dc0 <argstr>
801052ad:	83 c4 10             	add    $0x10,%esp
801052b0:	85 c0                	test   %eax,%eax
801052b2:	0f 88 e2 00 00 00    	js     8010539a <sys_link+0x11a>
  begin_op();
801052b8:	e8 83 da ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
801052bd:	83 ec 0c             	sub    $0xc,%esp
801052c0:	ff 75 d4             	push   -0x2c(%ebp)
801052c3:	e8 b8 cd ff ff       	call   80102080 <namei>
801052c8:	83 c4 10             	add    $0x10,%esp
801052cb:	89 c3                	mov    %eax,%ebx
801052cd:	85 c0                	test   %eax,%eax
801052cf:	0f 84 df 00 00 00    	je     801053b4 <sys_link+0x134>
  ilock(ip);
801052d5:	83 ec 0c             	sub    $0xc,%esp
801052d8:	50                   	push   %eax
801052d9:	e8 c2 c4 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
801052de:	83 c4 10             	add    $0x10,%esp
801052e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052e6:	0f 84 b5 00 00 00    	je     801053a1 <sys_link+0x121>
  iupdate(ip);
801052ec:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801052ef:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801052f4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801052f7:	53                   	push   %ebx
801052f8:	e8 f3 c3 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
801052fd:	89 1c 24             	mov    %ebx,(%esp)
80105300:	e8 7b c5 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105305:	58                   	pop    %eax
80105306:	5a                   	pop    %edx
80105307:	57                   	push   %edi
80105308:	ff 75 d0             	push   -0x30(%ebp)
8010530b:	e8 90 cd ff ff       	call   801020a0 <nameiparent>
80105310:	83 c4 10             	add    $0x10,%esp
80105313:	89 c6                	mov    %eax,%esi
80105315:	85 c0                	test   %eax,%eax
80105317:	74 5b                	je     80105374 <sys_link+0xf4>
  ilock(dp);
80105319:	83 ec 0c             	sub    $0xc,%esp
8010531c:	50                   	push   %eax
8010531d:	e8 7e c4 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105322:	8b 03                	mov    (%ebx),%eax
80105324:	83 c4 10             	add    $0x10,%esp
80105327:	39 06                	cmp    %eax,(%esi)
80105329:	75 3d                	jne    80105368 <sys_link+0xe8>
8010532b:	83 ec 04             	sub    $0x4,%esp
8010532e:	ff 73 04             	push   0x4(%ebx)
80105331:	57                   	push   %edi
80105332:	56                   	push   %esi
80105333:	e8 88 cc ff ff       	call   80101fc0 <dirlink>
80105338:	83 c4 10             	add    $0x10,%esp
8010533b:	85 c0                	test   %eax,%eax
8010533d:	78 29                	js     80105368 <sys_link+0xe8>
  iunlockput(dp);
8010533f:	83 ec 0c             	sub    $0xc,%esp
80105342:	56                   	push   %esi
80105343:	e8 e8 c6 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
80105348:	89 1c 24             	mov    %ebx,(%esp)
8010534b:	e8 80 c5 ff ff       	call   801018d0 <iput>
  end_op();
80105350:	e8 5b da ff ff       	call   80102db0 <end_op>
  return 0;
80105355:	83 c4 10             	add    $0x10,%esp
80105358:	31 c0                	xor    %eax,%eax
}
8010535a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010535d:	5b                   	pop    %ebx
8010535e:	5e                   	pop    %esi
8010535f:	5f                   	pop    %edi
80105360:	5d                   	pop    %ebp
80105361:	c3                   	ret
80105362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105368:	83 ec 0c             	sub    $0xc,%esp
8010536b:	56                   	push   %esi
8010536c:	e8 bf c6 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105371:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105374:	83 ec 0c             	sub    $0xc,%esp
80105377:	53                   	push   %ebx
80105378:	e8 23 c4 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
8010537d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105382:	89 1c 24             	mov    %ebx,(%esp)
80105385:	e8 66 c3 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
8010538a:	89 1c 24             	mov    %ebx,(%esp)
8010538d:	e8 9e c6 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105392:	e8 19 da ff ff       	call   80102db0 <end_op>
  return -1;
80105397:	83 c4 10             	add    $0x10,%esp
    return -1;
8010539a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010539f:	eb b9                	jmp    8010535a <sys_link+0xda>
    iunlockput(ip);
801053a1:	83 ec 0c             	sub    $0xc,%esp
801053a4:	53                   	push   %ebx
801053a5:	e8 86 c6 ff ff       	call   80101a30 <iunlockput>
    end_op();
801053aa:	e8 01 da ff ff       	call   80102db0 <end_op>
    return -1;
801053af:	83 c4 10             	add    $0x10,%esp
801053b2:	eb e6                	jmp    8010539a <sys_link+0x11a>
    end_op();
801053b4:	e8 f7 d9 ff ff       	call   80102db0 <end_op>
    return -1;
801053b9:	eb df                	jmp    8010539a <sys_link+0x11a>
801053bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801053c0 <sys_unlink>:
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	57                   	push   %edi
801053c4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801053c5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053c8:	53                   	push   %ebx
801053c9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801053cc:	50                   	push   %eax
801053cd:	6a 00                	push   $0x0
801053cf:	e8 ec f9 ff ff       	call   80104dc0 <argstr>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	85 c0                	test   %eax,%eax
801053d9:	0f 88 54 01 00 00    	js     80105533 <sys_unlink+0x173>
  begin_op();
801053df:	e8 5c d9 ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801053e4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801053e7:	83 ec 08             	sub    $0x8,%esp
801053ea:	53                   	push   %ebx
801053eb:	ff 75 c0             	push   -0x40(%ebp)
801053ee:	e8 ad cc ff ff       	call   801020a0 <nameiparent>
801053f3:	83 c4 10             	add    $0x10,%esp
801053f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801053f9:	85 c0                	test   %eax,%eax
801053fb:	0f 84 58 01 00 00    	je     80105559 <sys_unlink+0x199>
  ilock(dp);
80105401:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105404:	83 ec 0c             	sub    $0xc,%esp
80105407:	57                   	push   %edi
80105408:	e8 93 c3 ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010540d:	58                   	pop    %eax
8010540e:	5a                   	pop    %edx
8010540f:	68 38 7a 10 80       	push   $0x80107a38
80105414:	53                   	push   %ebx
80105415:	e8 b6 c8 ff ff       	call   80101cd0 <namecmp>
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	85 c0                	test   %eax,%eax
8010541f:	0f 84 fb 00 00 00    	je     80105520 <sys_unlink+0x160>
80105425:	83 ec 08             	sub    $0x8,%esp
80105428:	68 37 7a 10 80       	push   $0x80107a37
8010542d:	53                   	push   %ebx
8010542e:	e8 9d c8 ff ff       	call   80101cd0 <namecmp>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	0f 84 e2 00 00 00    	je     80105520 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010543e:	83 ec 04             	sub    $0x4,%esp
80105441:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105444:	50                   	push   %eax
80105445:	53                   	push   %ebx
80105446:	57                   	push   %edi
80105447:	e8 a4 c8 ff ff       	call   80101cf0 <dirlookup>
8010544c:	83 c4 10             	add    $0x10,%esp
8010544f:	89 c3                	mov    %eax,%ebx
80105451:	85 c0                	test   %eax,%eax
80105453:	0f 84 c7 00 00 00    	je     80105520 <sys_unlink+0x160>
  ilock(ip);
80105459:	83 ec 0c             	sub    $0xc,%esp
8010545c:	50                   	push   %eax
8010545d:	e8 3e c3 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
80105462:	83 c4 10             	add    $0x10,%esp
80105465:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010546a:	0f 8e 0a 01 00 00    	jle    8010557a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105470:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105475:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105478:	74 66                	je     801054e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010547a:	83 ec 04             	sub    $0x4,%esp
8010547d:	6a 10                	push   $0x10
8010547f:	6a 00                	push   $0x0
80105481:	57                   	push   %edi
80105482:	e8 c9 f5 ff ff       	call   80104a50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105487:	6a 10                	push   $0x10
80105489:	ff 75 c4             	push   -0x3c(%ebp)
8010548c:	57                   	push   %edi
8010548d:	ff 75 b4             	push   -0x4c(%ebp)
80105490:	e8 1b c7 ff ff       	call   80101bb0 <writei>
80105495:	83 c4 20             	add    $0x20,%esp
80105498:	83 f8 10             	cmp    $0x10,%eax
8010549b:	0f 85 cc 00 00 00    	jne    8010556d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801054a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054a6:	0f 84 94 00 00 00    	je     80105540 <sys_unlink+0x180>
  iunlockput(dp);
801054ac:	83 ec 0c             	sub    $0xc,%esp
801054af:	ff 75 b4             	push   -0x4c(%ebp)
801054b2:	e8 79 c5 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
801054b7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054bc:	89 1c 24             	mov    %ebx,(%esp)
801054bf:	e8 2c c2 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
801054c4:	89 1c 24             	mov    %ebx,(%esp)
801054c7:	e8 64 c5 ff ff       	call   80101a30 <iunlockput>
  end_op();
801054cc:	e8 df d8 ff ff       	call   80102db0 <end_op>
  return 0;
801054d1:	83 c4 10             	add    $0x10,%esp
801054d4:	31 c0                	xor    %eax,%eax
}
801054d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054d9:	5b                   	pop    %ebx
801054da:	5e                   	pop    %esi
801054db:	5f                   	pop    %edi
801054dc:	5d                   	pop    %ebp
801054dd:	c3                   	ret
801054de:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801054e4:	76 94                	jbe    8010547a <sys_unlink+0xba>
801054e6:	be 20 00 00 00       	mov    $0x20,%esi
801054eb:	eb 0b                	jmp    801054f8 <sys_unlink+0x138>
801054ed:	8d 76 00             	lea    0x0(%esi),%esi
801054f0:	83 c6 10             	add    $0x10,%esi
801054f3:	3b 73 58             	cmp    0x58(%ebx),%esi
801054f6:	73 82                	jae    8010547a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054f8:	6a 10                	push   $0x10
801054fa:	56                   	push   %esi
801054fb:	57                   	push   %edi
801054fc:	53                   	push   %ebx
801054fd:	e8 ae c5 ff ff       	call   80101ab0 <readi>
80105502:	83 c4 10             	add    $0x10,%esp
80105505:	83 f8 10             	cmp    $0x10,%eax
80105508:	75 56                	jne    80105560 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010550a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010550f:	74 df                	je     801054f0 <sys_unlink+0x130>
    iunlockput(ip);
80105511:	83 ec 0c             	sub    $0xc,%esp
80105514:	53                   	push   %ebx
80105515:	e8 16 c5 ff ff       	call   80101a30 <iunlockput>
    goto bad;
8010551a:	83 c4 10             	add    $0x10,%esp
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	ff 75 b4             	push   -0x4c(%ebp)
80105526:	e8 05 c5 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010552b:	e8 80 d8 ff ff       	call   80102db0 <end_op>
  return -1;
80105530:	83 c4 10             	add    $0x10,%esp
    return -1;
80105533:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105538:	eb 9c                	jmp    801054d6 <sys_unlink+0x116>
8010553a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105540:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105543:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105546:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010554b:	50                   	push   %eax
8010554c:	e8 9f c1 ff ff       	call   801016f0 <iupdate>
80105551:	83 c4 10             	add    $0x10,%esp
80105554:	e9 53 ff ff ff       	jmp    801054ac <sys_unlink+0xec>
    end_op();
80105559:	e8 52 d8 ff ff       	call   80102db0 <end_op>
    return -1;
8010555e:	eb d3                	jmp    80105533 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105560:	83 ec 0c             	sub    $0xc,%esp
80105563:	68 5c 7a 10 80       	push   $0x80107a5c
80105568:	e8 13 ae ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010556d:	83 ec 0c             	sub    $0xc,%esp
80105570:	68 6e 7a 10 80       	push   $0x80107a6e
80105575:	e8 06 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010557a:	83 ec 0c             	sub    $0xc,%esp
8010557d:	68 4a 7a 10 80       	push   $0x80107a4a
80105582:	e8 f9 ad ff ff       	call   80100380 <panic>
80105587:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010558e:	00 
8010558f:	90                   	nop

80105590 <sys_open>:

int
sys_open(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	57                   	push   %edi
80105594:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105595:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105598:	53                   	push   %ebx
80105599:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010559c:	50                   	push   %eax
8010559d:	6a 00                	push   $0x0
8010559f:	e8 1c f8 ff ff       	call   80104dc0 <argstr>
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	85 c0                	test   %eax,%eax
801055a9:	0f 88 8e 00 00 00    	js     8010563d <sys_open+0xad>
801055af:	83 ec 08             	sub    $0x8,%esp
801055b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055b5:	50                   	push   %eax
801055b6:	6a 01                	push   $0x1
801055b8:	e8 43 f7 ff ff       	call   80104d00 <argint>
801055bd:	83 c4 10             	add    $0x10,%esp
801055c0:	85 c0                	test   %eax,%eax
801055c2:	78 79                	js     8010563d <sys_open+0xad>
    return -1;

  begin_op();
801055c4:	e8 77 d7 ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
801055c9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801055cd:	75 79                	jne    80105648 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801055cf:	83 ec 0c             	sub    $0xc,%esp
801055d2:	ff 75 e0             	push   -0x20(%ebp)
801055d5:	e8 a6 ca ff ff       	call   80102080 <namei>
801055da:	83 c4 10             	add    $0x10,%esp
801055dd:	89 c6                	mov    %eax,%esi
801055df:	85 c0                	test   %eax,%eax
801055e1:	0f 84 7e 00 00 00    	je     80105665 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801055e7:	83 ec 0c             	sub    $0xc,%esp
801055ea:	50                   	push   %eax
801055eb:	e8 b0 c1 ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055f0:	83 c4 10             	add    $0x10,%esp
801055f3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055f8:	0f 84 ba 00 00 00    	je     801056b8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055fe:	e8 4d b8 ff ff       	call   80100e50 <filealloc>
80105603:	89 c7                	mov    %eax,%edi
80105605:	85 c0                	test   %eax,%eax
80105607:	74 23                	je     8010562c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105609:	e8 92 e3 ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010560e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105610:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105614:	85 d2                	test   %edx,%edx
80105616:	74 58                	je     80105670 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105618:	83 c3 01             	add    $0x1,%ebx
8010561b:	83 fb 10             	cmp    $0x10,%ebx
8010561e:	75 f0                	jne    80105610 <sys_open+0x80>
    if(f)
      fileclose(f);
80105620:	83 ec 0c             	sub    $0xc,%esp
80105623:	57                   	push   %edi
80105624:	e8 e7 b8 ff ff       	call   80100f10 <fileclose>
80105629:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010562c:	83 ec 0c             	sub    $0xc,%esp
8010562f:	56                   	push   %esi
80105630:	e8 fb c3 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105635:	e8 76 d7 ff ff       	call   80102db0 <end_op>
    return -1;
8010563a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010563d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105642:	eb 65                	jmp    801056a9 <sys_open+0x119>
80105644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	31 c9                	xor    %ecx,%ecx
8010564d:	ba 02 00 00 00       	mov    $0x2,%edx
80105652:	6a 00                	push   $0x0
80105654:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105657:	e8 54 f8 ff ff       	call   80104eb0 <create>
    if(ip == 0){
8010565c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010565f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105661:	85 c0                	test   %eax,%eax
80105663:	75 99                	jne    801055fe <sys_open+0x6e>
      end_op();
80105665:	e8 46 d7 ff ff       	call   80102db0 <end_op>
      return -1;
8010566a:	eb d1                	jmp    8010563d <sys_open+0xad>
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105670:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105673:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105677:	56                   	push   %esi
80105678:	e8 03 c2 ff ff       	call   80101880 <iunlock>
  end_op();
8010567d:	e8 2e d7 ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
80105682:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105688:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010568b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010568e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105691:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105693:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010569a:	f7 d0                	not    %eax
8010569c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010569f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801056a2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056a5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801056a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056ac:	89 d8                	mov    %ebx,%eax
801056ae:	5b                   	pop    %ebx
801056af:	5e                   	pop    %esi
801056b0:	5f                   	pop    %edi
801056b1:	5d                   	pop    %ebp
801056b2:	c3                   	ret
801056b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801056b8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056bb:	85 c9                	test   %ecx,%ecx
801056bd:	0f 84 3b ff ff ff    	je     801055fe <sys_open+0x6e>
801056c3:	e9 64 ff ff ff       	jmp    8010562c <sys_open+0x9c>
801056c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056cf:	00 

801056d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801056d6:	e8 65 d6 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801056db:	83 ec 08             	sub    $0x8,%esp
801056de:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056e1:	50                   	push   %eax
801056e2:	6a 00                	push   $0x0
801056e4:	e8 d7 f6 ff ff       	call   80104dc0 <argstr>
801056e9:	83 c4 10             	add    $0x10,%esp
801056ec:	85 c0                	test   %eax,%eax
801056ee:	78 30                	js     80105720 <sys_mkdir+0x50>
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056f6:	31 c9                	xor    %ecx,%ecx
801056f8:	ba 01 00 00 00       	mov    $0x1,%edx
801056fd:	6a 00                	push   $0x0
801056ff:	e8 ac f7 ff ff       	call   80104eb0 <create>
80105704:	83 c4 10             	add    $0x10,%esp
80105707:	85 c0                	test   %eax,%eax
80105709:	74 15                	je     80105720 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010570b:	83 ec 0c             	sub    $0xc,%esp
8010570e:	50                   	push   %eax
8010570f:	e8 1c c3 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105714:	e8 97 d6 ff ff       	call   80102db0 <end_op>
  return 0;
80105719:	83 c4 10             	add    $0x10,%esp
8010571c:	31 c0                	xor    %eax,%eax
}
8010571e:	c9                   	leave
8010571f:	c3                   	ret
    end_op();
80105720:	e8 8b d6 ff ff       	call   80102db0 <end_op>
    return -1;
80105725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010572a:	c9                   	leave
8010572b:	c3                   	ret
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_mknod>:

int
sys_mknod(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105736:	e8 05 d6 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010573b:	83 ec 08             	sub    $0x8,%esp
8010573e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105741:	50                   	push   %eax
80105742:	6a 00                	push   $0x0
80105744:	e8 77 f6 ff ff       	call   80104dc0 <argstr>
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	85 c0                	test   %eax,%eax
8010574e:	78 60                	js     801057b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105750:	83 ec 08             	sub    $0x8,%esp
80105753:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105756:	50                   	push   %eax
80105757:	6a 01                	push   $0x1
80105759:	e8 a2 f5 ff ff       	call   80104d00 <argint>
  if((argstr(0, &path)) < 0 ||
8010575e:	83 c4 10             	add    $0x10,%esp
80105761:	85 c0                	test   %eax,%eax
80105763:	78 4b                	js     801057b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105765:	83 ec 08             	sub    $0x8,%esp
80105768:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010576b:	50                   	push   %eax
8010576c:	6a 02                	push   $0x2
8010576e:	e8 8d f5 ff ff       	call   80104d00 <argint>
     argint(1, &major) < 0 ||
80105773:	83 c4 10             	add    $0x10,%esp
80105776:	85 c0                	test   %eax,%eax
80105778:	78 36                	js     801057b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010577a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010577e:	83 ec 0c             	sub    $0xc,%esp
80105781:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105785:	ba 03 00 00 00       	mov    $0x3,%edx
8010578a:	50                   	push   %eax
8010578b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010578e:	e8 1d f7 ff ff       	call   80104eb0 <create>
     argint(2, &minor) < 0 ||
80105793:	83 c4 10             	add    $0x10,%esp
80105796:	85 c0                	test   %eax,%eax
80105798:	74 16                	je     801057b0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010579a:	83 ec 0c             	sub    $0xc,%esp
8010579d:	50                   	push   %eax
8010579e:	e8 8d c2 ff ff       	call   80101a30 <iunlockput>
  end_op();
801057a3:	e8 08 d6 ff ff       	call   80102db0 <end_op>
  return 0;
801057a8:	83 c4 10             	add    $0x10,%esp
801057ab:	31 c0                	xor    %eax,%eax
}
801057ad:	c9                   	leave
801057ae:	c3                   	ret
801057af:	90                   	nop
    end_op();
801057b0:	e8 fb d5 ff ff       	call   80102db0 <end_op>
    return -1;
801057b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ba:	c9                   	leave
801057bb:	c3                   	ret
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_chdir>:

int
sys_chdir(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	56                   	push   %esi
801057c4:	53                   	push   %ebx
801057c5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801057c8:	e8 d3 e1 ff ff       	call   801039a0 <myproc>
801057cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801057cf:	e8 6c d5 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801057d4:	83 ec 08             	sub    $0x8,%esp
801057d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057da:	50                   	push   %eax
801057db:	6a 00                	push   $0x0
801057dd:	e8 de f5 ff ff       	call   80104dc0 <argstr>
801057e2:	83 c4 10             	add    $0x10,%esp
801057e5:	85 c0                	test   %eax,%eax
801057e7:	78 77                	js     80105860 <sys_chdir+0xa0>
801057e9:	83 ec 0c             	sub    $0xc,%esp
801057ec:	ff 75 f4             	push   -0xc(%ebp)
801057ef:	e8 8c c8 ff ff       	call   80102080 <namei>
801057f4:	83 c4 10             	add    $0x10,%esp
801057f7:	89 c3                	mov    %eax,%ebx
801057f9:	85 c0                	test   %eax,%eax
801057fb:	74 63                	je     80105860 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057fd:	83 ec 0c             	sub    $0xc,%esp
80105800:	50                   	push   %eax
80105801:	e8 9a bf ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105806:	83 c4 10             	add    $0x10,%esp
80105809:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010580e:	75 30                	jne    80105840 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	53                   	push   %ebx
80105814:	e8 67 c0 ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
80105819:	58                   	pop    %eax
8010581a:	ff 76 68             	push   0x68(%esi)
8010581d:	e8 ae c0 ff ff       	call   801018d0 <iput>
  end_op();
80105822:	e8 89 d5 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
80105827:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010582a:	83 c4 10             	add    $0x10,%esp
8010582d:	31 c0                	xor    %eax,%eax
}
8010582f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105832:	5b                   	pop    %ebx
80105833:	5e                   	pop    %esi
80105834:	5d                   	pop    %ebp
80105835:	c3                   	ret
80105836:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010583d:	00 
8010583e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	53                   	push   %ebx
80105844:	e8 e7 c1 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105849:	e8 62 d5 ff ff       	call   80102db0 <end_op>
    return -1;
8010584e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105851:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105856:	eb d7                	jmp    8010582f <sys_chdir+0x6f>
80105858:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010585f:	00 
    end_op();
80105860:	e8 4b d5 ff ff       	call   80102db0 <end_op>
    return -1;
80105865:	eb ea                	jmp    80105851 <sys_chdir+0x91>
80105867:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010586e:	00 
8010586f:	90                   	nop

80105870 <sys_exec>:

int
sys_exec(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	57                   	push   %edi
80105874:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105875:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010587b:	53                   	push   %ebx
8010587c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105882:	50                   	push   %eax
80105883:	6a 00                	push   $0x0
80105885:	e8 36 f5 ff ff       	call   80104dc0 <argstr>
8010588a:	83 c4 10             	add    $0x10,%esp
8010588d:	85 c0                	test   %eax,%eax
8010588f:	0f 88 87 00 00 00    	js     8010591c <sys_exec+0xac>
80105895:	83 ec 08             	sub    $0x8,%esp
80105898:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010589e:	50                   	push   %eax
8010589f:	6a 01                	push   $0x1
801058a1:	e8 5a f4 ff ff       	call   80104d00 <argint>
801058a6:	83 c4 10             	add    $0x10,%esp
801058a9:	85 c0                	test   %eax,%eax
801058ab:	78 6f                	js     8010591c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801058ad:	83 ec 04             	sub    $0x4,%esp
801058b0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801058b6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801058b8:	68 80 00 00 00       	push   $0x80
801058bd:	6a 00                	push   $0x0
801058bf:	56                   	push   %esi
801058c0:	e8 8b f1 ff ff       	call   80104a50 <memset>
801058c5:	83 c4 10             	add    $0x10,%esp
801058c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058cf:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801058d0:	83 ec 08             	sub    $0x8,%esp
801058d3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801058d9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801058e0:	50                   	push   %eax
801058e1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058e7:	01 f8                	add    %edi,%eax
801058e9:	50                   	push   %eax
801058ea:	e8 81 f3 ff ff       	call   80104c70 <fetchint>
801058ef:	83 c4 10             	add    $0x10,%esp
801058f2:	85 c0                	test   %eax,%eax
801058f4:	78 26                	js     8010591c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801058f6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058fc:	85 c0                	test   %eax,%eax
801058fe:	74 30                	je     80105930 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105900:	83 ec 08             	sub    $0x8,%esp
80105903:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105906:	52                   	push   %edx
80105907:	50                   	push   %eax
80105908:	e8 a3 f3 ff ff       	call   80104cb0 <fetchstr>
8010590d:	83 c4 10             	add    $0x10,%esp
80105910:	85 c0                	test   %eax,%eax
80105912:	78 08                	js     8010591c <sys_exec+0xac>
  for(i=0;; i++){
80105914:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105917:	83 fb 20             	cmp    $0x20,%ebx
8010591a:	75 b4                	jne    801058d0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010591c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010591f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105924:	5b                   	pop    %ebx
80105925:	5e                   	pop    %esi
80105926:	5f                   	pop    %edi
80105927:	5d                   	pop    %ebp
80105928:	c3                   	ret
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105930:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105937:	00 00 00 00 
  return exec(path, argv);
8010593b:	83 ec 08             	sub    $0x8,%esp
8010593e:	56                   	push   %esi
8010593f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105945:	e8 66 b1 ff ff       	call   80100ab0 <exec>
8010594a:	83 c4 10             	add    $0x10,%esp
}
8010594d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105950:	5b                   	pop    %ebx
80105951:	5e                   	pop    %esi
80105952:	5f                   	pop    %edi
80105953:	5d                   	pop    %ebp
80105954:	c3                   	ret
80105955:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010595c:	00 
8010595d:	8d 76 00             	lea    0x0(%esi),%esi

80105960 <sys_pipe>:

int
sys_pipe(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	57                   	push   %edi
80105964:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105965:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105968:	53                   	push   %ebx
80105969:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010596c:	6a 08                	push   $0x8
8010596e:	50                   	push   %eax
8010596f:	6a 00                	push   $0x0
80105971:	e8 da f3 ff ff       	call   80104d50 <argptr>
80105976:	83 c4 10             	add    $0x10,%esp
80105979:	85 c0                	test   %eax,%eax
8010597b:	0f 88 8b 00 00 00    	js     80105a0c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105981:	83 ec 08             	sub    $0x8,%esp
80105984:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105987:	50                   	push   %eax
80105988:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010598b:	50                   	push   %eax
8010598c:	e8 7f da ff ff       	call   80103410 <pipealloc>
80105991:	83 c4 10             	add    $0x10,%esp
80105994:	85 c0                	test   %eax,%eax
80105996:	78 74                	js     80105a0c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105998:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010599b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010599d:	e8 fe df ff ff       	call   801039a0 <myproc>
    if(curproc->ofile[fd] == 0){
801059a2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801059a6:	85 f6                	test   %esi,%esi
801059a8:	74 16                	je     801059c0 <sys_pipe+0x60>
801059aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801059b0:	83 c3 01             	add    $0x1,%ebx
801059b3:	83 fb 10             	cmp    $0x10,%ebx
801059b6:	74 3d                	je     801059f5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801059b8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801059bc:	85 f6                	test   %esi,%esi
801059be:	75 f0                	jne    801059b0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801059c0:	8d 73 08             	lea    0x8(%ebx),%esi
801059c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801059ca:	e8 d1 df ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059cf:	31 d2                	xor    %edx,%edx
801059d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801059d8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801059dc:	85 c9                	test   %ecx,%ecx
801059de:	74 38                	je     80105a18 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
801059e0:	83 c2 01             	add    $0x1,%edx
801059e3:	83 fa 10             	cmp    $0x10,%edx
801059e6:	75 f0                	jne    801059d8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801059e8:	e8 b3 df ff ff       	call   801039a0 <myproc>
801059ed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059f4:	00 
    fileclose(rf);
801059f5:	83 ec 0c             	sub    $0xc,%esp
801059f8:	ff 75 e0             	push   -0x20(%ebp)
801059fb:	e8 10 b5 ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
80105a00:	58                   	pop    %eax
80105a01:	ff 75 e4             	push   -0x1c(%ebp)
80105a04:	e8 07 b5 ff ff       	call   80100f10 <fileclose>
    return -1;
80105a09:	83 c4 10             	add    $0x10,%esp
    return -1;
80105a0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a11:	eb 16                	jmp    80105a29 <sys_pipe+0xc9>
80105a13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105a18:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105a1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a1f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a21:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a24:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a27:	31 c0                	xor    %eax,%eax
}
80105a29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a2c:	5b                   	pop    %ebx
80105a2d:	5e                   	pop    %esi
80105a2e:	5f                   	pop    %edi
80105a2f:	5d                   	pop    %ebp
80105a30:	c3                   	ret
80105a31:	66 90                	xchg   %ax,%ax
80105a33:	66 90                	xchg   %ax,%ax
80105a35:	66 90                	xchg   %ax,%ax
80105a37:	66 90                	xchg   %ax,%ax
80105a39:	66 90                	xchg   %ax,%ax
80105a3b:	66 90                	xchg   %ax,%ax
80105a3d:	66 90                	xchg   %ax,%ax
80105a3f:	90                   	nop

80105a40 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105a40:	e9 fb e0 ff ff       	jmp    80103b40 <fork>
80105a45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a4c:	00 
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi

80105a50 <sys_exit>:
}

int
sys_exit(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a56:	e8 85 e3 ff ff       	call   80103de0 <exit>
  return 0;  // not reached
}
80105a5b:	31 c0                	xor    %eax,%eax
80105a5d:	c9                   	leave
80105a5e:	c3                   	ret
80105a5f:	90                   	nop

80105a60 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105a60:	e9 8b e6 ff ff       	jmp    801040f0 <wait>
80105a65:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a6c:	00 
80105a6d:	8d 76 00             	lea    0x0(%esi),%esi

80105a70 <sys_kill>:
}

int
sys_kill(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a79:	50                   	push   %eax
80105a7a:	6a 00                	push   $0x0
80105a7c:	e8 7f f2 ff ff       	call   80104d00 <argint>
80105a81:	83 c4 10             	add    $0x10,%esp
80105a84:	85 c0                	test   %eax,%eax
80105a86:	78 18                	js     80105aa0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	ff 75 f4             	push   -0xc(%ebp)
80105a8e:	e8 bd e7 ff ff       	call   80104250 <kill>
80105a93:	83 c4 10             	add    $0x10,%esp
}
80105a96:	c9                   	leave
80105a97:	c3                   	ret
80105a98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a9f:	00 
80105aa0:	c9                   	leave
    return -1;
80105aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa6:	c3                   	ret
80105aa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aae:	00 
80105aaf:	90                   	nop

80105ab0 <sys_getpid>:

int
sys_getpid(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ab6:	e8 e5 de ff ff       	call   801039a0 <myproc>
80105abb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105abe:	c9                   	leave
80105abf:	c3                   	ret

80105ac0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ac7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aca:	50                   	push   %eax
80105acb:	6a 00                	push   $0x0
80105acd:	e8 2e f2 ff ff       	call   80104d00 <argint>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	78 27                	js     80105b00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ad9:	e8 c2 de ff ff       	call   801039a0 <myproc>
  if(growproc(n) < 0)
80105ade:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ae1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ae3:	ff 75 f4             	push   -0xc(%ebp)
80105ae6:	e8 d5 df ff ff       	call   80103ac0 <growproc>
80105aeb:	83 c4 10             	add    $0x10,%esp
80105aee:	85 c0                	test   %eax,%eax
80105af0:	78 0e                	js     80105b00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105af2:	89 d8                	mov    %ebx,%eax
80105af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af7:	c9                   	leave
80105af8:	c3                   	ret
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b05:	eb eb                	jmp    80105af2 <sys_sbrk+0x32>
80105b07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b0e:	00 
80105b0f:	90                   	nop

80105b10 <sys_sleep>:

int
sys_sleep(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b1a:	50                   	push   %eax
80105b1b:	6a 00                	push   $0x0
80105b1d:	e8 de f1 ff ff       	call   80104d00 <argint>
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	85 c0                	test   %eax,%eax
80105b27:	78 64                	js     80105b8d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105b29:	83 ec 0c             	sub    $0xc,%esp
80105b2c:	68 80 54 11 80       	push   $0x80115480
80105b31:	e8 1a ee ff ff       	call   80104950 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105b39:	8b 1d 60 54 11 80    	mov    0x80115460,%ebx
  while(ticks - ticks0 < n){
80105b3f:	83 c4 10             	add    $0x10,%esp
80105b42:	85 d2                	test   %edx,%edx
80105b44:	75 2b                	jne    80105b71 <sys_sleep+0x61>
80105b46:	eb 58                	jmp    80105ba0 <sys_sleep+0x90>
80105b48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b4f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b50:	83 ec 08             	sub    $0x8,%esp
80105b53:	68 80 54 11 80       	push   $0x80115480
80105b58:	68 60 54 11 80       	push   $0x80115460
80105b5d:	e8 9e e4 ff ff       	call   80104000 <sleep>
  while(ticks - ticks0 < n){
80105b62:	a1 60 54 11 80       	mov    0x80115460,%eax
80105b67:	83 c4 10             	add    $0x10,%esp
80105b6a:	29 d8                	sub    %ebx,%eax
80105b6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b6f:	73 2f                	jae    80105ba0 <sys_sleep+0x90>
    if(myproc()->killed){
80105b71:	e8 2a de ff ff       	call   801039a0 <myproc>
80105b76:	8b 40 24             	mov    0x24(%eax),%eax
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	74 d3                	je     80105b50 <sys_sleep+0x40>
      release(&tickslock);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	68 80 54 11 80       	push   $0x80115480
80105b85:	e8 66 ed ff ff       	call   801048f0 <release>
      return -1;
80105b8a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105b8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b95:	c9                   	leave
80105b96:	c3                   	ret
80105b97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b9e:	00 
80105b9f:	90                   	nop
  release(&tickslock);
80105ba0:	83 ec 0c             	sub    $0xc,%esp
80105ba3:	68 80 54 11 80       	push   $0x80115480
80105ba8:	e8 43 ed ff ff       	call   801048f0 <release>
}
80105bad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105bb0:	83 c4 10             	add    $0x10,%esp
80105bb3:	31 c0                	xor    %eax,%eax
}
80105bb5:	c9                   	leave
80105bb6:	c3                   	ret
80105bb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bbe:	00 
80105bbf:	90                   	nop

80105bc0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	53                   	push   %ebx
80105bc4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105bc7:	68 80 54 11 80       	push   $0x80115480
80105bcc:	e8 7f ed ff ff       	call   80104950 <acquire>
  xticks = ticks;
80105bd1:	8b 1d 60 54 11 80    	mov    0x80115460,%ebx
  release(&tickslock);
80105bd7:	c7 04 24 80 54 11 80 	movl   $0x80115480,(%esp)
80105bde:	e8 0d ed ff ff       	call   801048f0 <release>
  return xticks;
}
80105be3:	89 d8                	mov    %ebx,%eax
80105be5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105be8:	c9                   	leave
80105be9:	c3                   	ret
80105bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bf0 <sys_cscount>:


// LAB 6
int
sys_cscount(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if (argint(0, &pid) < 0)
80105bf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bf9:	50                   	push   %eax
80105bfa:	6a 00                	push   $0x0
80105bfc:	e8 ff f0 ff ff       	call   80104d00 <argint>
80105c01:	83 c4 10             	add    $0x10,%esp
80105c04:	85 c0                	test   %eax,%eax
80105c06:	78 18                	js     80105c20 <sys_cscount+0x30>
    return -1;
  cscount(pid);
80105c08:	83 ec 0c             	sub    $0xc,%esp
80105c0b:	ff 75 f4             	push   -0xc(%ebp)
80105c0e:	e8 7d e7 ff ff       	call   80104390 <cscount>
  return 0;
80105c13:	83 c4 10             	add    $0x10,%esp
80105c16:	31 c0                	xor    %eax,%eax
}
80105c18:	c9                   	leave
80105c19:	c3                   	ret
80105c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c20:	c9                   	leave
    return -1;
80105c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c26:	c3                   	ret
80105c27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c2e:	00 
80105c2f:	90                   	nop

80105c30 <sys_wait2>:


int
sys_wait2(void)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	83 ec 1c             	sub    $0x1c,%esp
  int *wtime, *rtime;

  if (argptr(0, (char**)&wtime, sizeof(int)) < 0)
80105c36:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c39:	6a 04                	push   $0x4
80105c3b:	50                   	push   %eax
80105c3c:	6a 00                	push   $0x0
80105c3e:	e8 0d f1 ff ff       	call   80104d50 <argptr>
80105c43:	83 c4 10             	add    $0x10,%esp
80105c46:	85 c0                	test   %eax,%eax
80105c48:	78 2e                	js     80105c78 <sys_wait2+0x48>
    return -1;
  if (argptr(1, (char**)&rtime, sizeof(int)) < 0)
80105c4a:	83 ec 04             	sub    $0x4,%esp
80105c4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c50:	6a 04                	push   $0x4
80105c52:	50                   	push   %eax
80105c53:	6a 01                	push   $0x1
80105c55:	e8 f6 f0 ff ff       	call   80104d50 <argptr>
80105c5a:	83 c4 10             	add    $0x10,%esp
80105c5d:	85 c0                	test   %eax,%eax
80105c5f:	78 17                	js     80105c78 <sys_wait2+0x48>
    return -1;

  return wait2(wtime, rtime);
80105c61:	83 ec 08             	sub    $0x8,%esp
80105c64:	ff 75 f4             	push   -0xc(%ebp)
80105c67:	ff 75 f0             	push   -0x10(%ebp)
80105c6a:	e8 a1 e7 ff ff       	call   80104410 <wait2>
80105c6f:	83 c4 10             	add    $0x10,%esp

}
80105c72:	c9                   	leave
80105c73:	c3                   	ret
80105c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c78:	c9                   	leave
    return -1;
80105c79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c7e:	c3                   	ret
80105c7f:	90                   	nop

80105c80 <sys_set_priority>:

int
sys_set_priority(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 20             	sub    $0x20,%esp
  int pid, priority;

  if (argint(0, &pid) < 0)
80105c86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c89:	50                   	push   %eax
80105c8a:	6a 00                	push   $0x0
80105c8c:	e8 6f f0 ff ff       	call   80104d00 <argint>
80105c91:	83 c4 10             	add    $0x10,%esp
80105c94:	85 c0                	test   %eax,%eax
80105c96:	78 28                	js     80105cc0 <sys_set_priority+0x40>
    return -1;
  if (argint(1, &priority) < 0)
80105c98:	83 ec 08             	sub    $0x8,%esp
80105c9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c9e:	50                   	push   %eax
80105c9f:	6a 01                	push   $0x1
80105ca1:	e8 5a f0 ff ff       	call   80104d00 <argint>
80105ca6:	83 c4 10             	add    $0x10,%esp
80105ca9:	85 c0                	test   %eax,%eax
80105cab:	78 13                	js     80105cc0 <sys_set_priority+0x40>
    return -1;

  return set_priority(pid, priority);
80105cad:	83 ec 08             	sub    $0x8,%esp
80105cb0:	ff 75 f4             	push   -0xc(%ebp)
80105cb3:	ff 75 f0             	push   -0x10(%ebp)
80105cb6:	e8 85 e8 ff ff       	call   80104540 <set_priority>
80105cbb:	83 c4 10             	add    $0x10,%esp
}
80105cbe:	c9                   	leave
80105cbf:	c3                   	ret
80105cc0:	c9                   	leave
    return -1;
80105cc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cc6:	c3                   	ret
80105cc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cce:	00 
80105ccf:	90                   	nop

80105cd0 <sys_set_quanta>:

int
sys_set_quanta(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	83 ec 20             	sub    $0x20,%esp
  int pid, quanta;

  if (argint(0, &pid) < 0)
80105cd6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cd9:	50                   	push   %eax
80105cda:	6a 00                	push   $0x0
80105cdc:	e8 1f f0 ff ff       	call   80104d00 <argint>
80105ce1:	83 c4 10             	add    $0x10,%esp
80105ce4:	85 c0                	test   %eax,%eax
80105ce6:	78 28                	js     80105d10 <sys_set_quanta+0x40>
    return -1;
  if (argint(1, &quanta) < 0)
80105ce8:	83 ec 08             	sub    $0x8,%esp
80105ceb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cee:	50                   	push   %eax
80105cef:	6a 01                	push   $0x1
80105cf1:	e8 0a f0 ff ff       	call   80104d00 <argint>
80105cf6:	83 c4 10             	add    $0x10,%esp
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	78 13                	js     80105d10 <sys_set_quanta+0x40>
    return -1;
  return set_quanta(pid, quanta);
80105cfd:	83 ec 08             	sub    $0x8,%esp
80105d00:	ff 75 f4             	push   -0xc(%ebp)
80105d03:	ff 75 f0             	push   -0x10(%ebp)
80105d06:	e8 b5 e8 ff ff       	call   801045c0 <set_quanta>
80105d0b:	83 c4 10             	add    $0x10,%esp
80105d0e:	c9                   	leave
80105d0f:	c3                   	ret
80105d10:	c9                   	leave
    return -1;
80105d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d16:	c3                   	ret

80105d17 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d17:	1e                   	push   %ds
  pushl %es
80105d18:	06                   	push   %es
  pushl %fs
80105d19:	0f a0                	push   %fs
  pushl %gs
80105d1b:	0f a8                	push   %gs
  pushal
80105d1d:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d1e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d22:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d24:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d26:	54                   	push   %esp
  call trap
80105d27:	e8 c4 00 00 00       	call   80105df0 <trap>
  addl $4, %esp
80105d2c:	83 c4 04             	add    $0x4,%esp

80105d2f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d2f:	61                   	popa
  popl %gs
80105d30:	0f a9                	pop    %gs
  popl %fs
80105d32:	0f a1                	pop    %fs
  popl %es
80105d34:	07                   	pop    %es
  popl %ds
80105d35:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d36:	83 c4 08             	add    $0x8,%esp
  iret
80105d39:	cf                   	iret
80105d3a:	66 90                	xchg   %ax,%ax
80105d3c:	66 90                	xchg   %ax,%ax
80105d3e:	66 90                	xchg   %ax,%ax

80105d40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d41:	31 c0                	xor    %eax,%eax
{
80105d43:	89 e5                	mov    %esp,%ebp
80105d45:	83 ec 08             	sub    $0x8,%esp
80105d48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d4f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d50:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105d57:	c7 04 c5 c2 54 11 80 	movl   $0x8e000008,-0x7feeab3e(,%eax,8)
80105d5e:	08 00 00 8e 
80105d62:	66 89 14 c5 c0 54 11 	mov    %dx,-0x7feeab40(,%eax,8)
80105d69:	80 
80105d6a:	c1 ea 10             	shr    $0x10,%edx
80105d6d:	66 89 14 c5 c6 54 11 	mov    %dx,-0x7feeab3a(,%eax,8)
80105d74:	80 
  for(i = 0; i < 256; i++)
80105d75:	83 c0 01             	add    $0x1,%eax
80105d78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d7d:	75 d1                	jne    80105d50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d7f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d82:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105d87:	c7 05 c2 56 11 80 08 	movl   $0xef000008,0x801156c2
80105d8e:	00 00 ef 
  initlock(&tickslock, "time");
80105d91:	68 7d 7a 10 80       	push   $0x80107a7d
80105d96:	68 80 54 11 80       	push   $0x80115480
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d9b:	66 a3 c0 56 11 80    	mov    %ax,0x801156c0
80105da1:	c1 e8 10             	shr    $0x10,%eax
80105da4:	66 a3 c6 56 11 80    	mov    %ax,0x801156c6
  initlock(&tickslock, "time");
80105daa:	e8 b1 e9 ff ff       	call   80104760 <initlock>
}
80105daf:	83 c4 10             	add    $0x10,%esp
80105db2:	c9                   	leave
80105db3:	c3                   	ret
80105db4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dbb:	00 
80105dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105dc0 <idtinit>:

void
idtinit(void)
{
80105dc0:	55                   	push   %ebp
  pd[0] = size-1;
80105dc1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105dc6:	89 e5                	mov    %esp,%ebp
80105dc8:	83 ec 10             	sub    $0x10,%esp
80105dcb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105dcf:	b8 c0 54 11 80       	mov    $0x801154c0,%eax
80105dd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105dd8:	c1 e8 10             	shr    $0x10,%eax
80105ddb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105ddf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105de2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105de5:	c9                   	leave
80105de6:	c3                   	ret
80105de7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dee:	00 
80105def:	90                   	nop

80105df0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	57                   	push   %edi
80105df4:	56                   	push   %esi
80105df5:	53                   	push   %ebx
80105df6:	83 ec 1c             	sub    $0x1c,%esp
80105df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105dfc:	8b 43 30             	mov    0x30(%ebx),%eax
80105dff:	83 f8 40             	cmp    $0x40,%eax
80105e02:	0f 84 70 01 00 00    	je     80105f78 <trap+0x188>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e08:	83 e8 20             	sub    $0x20,%eax
80105e0b:	83 f8 1f             	cmp    $0x1f,%eax
80105e0e:	0f 87 7c 00 00 00    	ja     80105e90 <trap+0xa0>
80105e14:	ff 24 85 08 80 10 80 	jmp    *-0x7fef7ff8(,%eax,4)
80105e1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105e20:	e8 0b c4 ff ff       	call   80102230 <ideintr>
    lapiceoi();
80105e25:	e8 c6 ca ff ff       	call   801028f0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e2a:	e8 71 db ff ff       	call   801039a0 <myproc>
80105e2f:	85 c0                	test   %eax,%eax
80105e31:	74 1a                	je     80105e4d <trap+0x5d>
80105e33:	e8 68 db ff ff       	call   801039a0 <myproc>
80105e38:	8b 50 24             	mov    0x24(%eax),%edx
80105e3b:	85 d2                	test   %edx,%edx
80105e3d:	74 0e                	je     80105e4d <trap+0x5d>
80105e3f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e43:	f7 d0                	not    %eax
80105e45:	a8 03                	test   $0x3,%al
80105e47:	0f 84 f3 01 00 00    	je     80106040 <trap+0x250>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e4d:	e8 4e db ff ff       	call   801039a0 <myproc>
80105e52:	85 c0                	test   %eax,%eax
80105e54:	74 0f                	je     80105e65 <trap+0x75>
80105e56:	e8 45 db ff ff       	call   801039a0 <myproc>
80105e5b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e5f:	0f 84 ab 00 00 00    	je     80105f10 <trap+0x120>
      yield();
    }
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e65:	e8 36 db ff ff       	call   801039a0 <myproc>
80105e6a:	85 c0                	test   %eax,%eax
80105e6c:	74 1a                	je     80105e88 <trap+0x98>
80105e6e:	e8 2d db ff ff       	call   801039a0 <myproc>
80105e73:	8b 40 24             	mov    0x24(%eax),%eax
80105e76:	85 c0                	test   %eax,%eax
80105e78:	74 0e                	je     80105e88 <trap+0x98>
80105e7a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e7e:	f7 d0                	not    %eax
80105e80:	a8 03                	test   $0x3,%al
80105e82:	0f 84 1d 01 00 00    	je     80105fa5 <trap+0x1b5>
    exit();
}
80105e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e8b:	5b                   	pop    %ebx
80105e8c:	5e                   	pop    %esi
80105e8d:	5f                   	pop    %edi
80105e8e:	5d                   	pop    %ebp
80105e8f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e90:	e8 0b db ff ff       	call   801039a0 <myproc>
80105e95:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e98:	85 c0                	test   %eax,%eax
80105e9a:	0f 84 ca 01 00 00    	je     8010606a <trap+0x27a>
80105ea0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ea4:	0f 84 c0 01 00 00    	je     8010606a <trap+0x27a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105eaa:	0f 20 d1             	mov    %cr2,%ecx
80105ead:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eb0:	e8 cb da ff ff       	call   80103980 <cpuid>
80105eb5:	8b 73 30             	mov    0x30(%ebx),%esi
80105eb8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ebb:	8b 43 34             	mov    0x34(%ebx),%eax
80105ebe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ec1:	e8 da da ff ff       	call   801039a0 <myproc>
80105ec6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ec9:	e8 d2 da ff ff       	call   801039a0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ece:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ed1:	51                   	push   %ecx
80105ed2:	57                   	push   %edi
80105ed3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ed6:	52                   	push   %edx
80105ed7:	ff 75 e4             	push   -0x1c(%ebp)
80105eda:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105edb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105ede:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ee1:	56                   	push   %esi
80105ee2:	ff 70 10             	push   0x10(%eax)
80105ee5:	68 f8 7c 10 80       	push   $0x80107cf8
80105eea:	e8 c1 a7 ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105eef:	83 c4 20             	add    $0x20,%esp
80105ef2:	e8 a9 da ff ff       	call   801039a0 <myproc>
80105ef7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105efe:	e8 9d da ff ff       	call   801039a0 <myproc>
80105f03:	85 c0                	test   %eax,%eax
80105f05:	0f 85 28 ff ff ff    	jne    80105e33 <trap+0x43>
80105f0b:	e9 3d ff ff ff       	jmp    80105e4d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105f10:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105f14:	0f 85 4b ff ff ff    	jne    80105e65 <trap+0x75>
    int current = myproc()->current_slice;
80105f1a:	e8 81 da ff ff       	call   801039a0 <myproc>
80105f1f:	8b b0 94 00 00 00    	mov    0x94(%eax),%esi
    if (current>=1) {
80105f25:	85 f6                	test   %esi,%esi
80105f27:	0f 8e 33 01 00 00    	jle    80106060 <trap+0x270>
      myproc()->current_slice = current - 1;
80105f2d:	e8 6e da ff ff       	call   801039a0 <myproc>
80105f32:	83 ee 01             	sub    $0x1,%esi
80105f35:	89 b0 94 00 00 00    	mov    %esi,0x94(%eax)
80105f3b:	e9 25 ff ff ff       	jmp    80105e65 <trap+0x75>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f40:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f43:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f47:	e8 34 da ff ff       	call   80103980 <cpuid>
80105f4c:	57                   	push   %edi
80105f4d:	56                   	push   %esi
80105f4e:	50                   	push   %eax
80105f4f:	68 a0 7c 10 80       	push   $0x80107ca0
80105f54:	e8 57 a7 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105f59:	e8 92 c9 ff ff       	call   801028f0 <lapiceoi>
    break;
80105f5e:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f61:	e8 3a da ff ff       	call   801039a0 <myproc>
80105f66:	85 c0                	test   %eax,%eax
80105f68:	0f 85 c5 fe ff ff    	jne    80105e33 <trap+0x43>
80105f6e:	e9 da fe ff ff       	jmp    80105e4d <trap+0x5d>
80105f73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105f78:	e8 23 da ff ff       	call   801039a0 <myproc>
80105f7d:	8b 70 24             	mov    0x24(%eax),%esi
80105f80:	85 f6                	test   %esi,%esi
80105f82:	0f 85 c8 00 00 00    	jne    80106050 <trap+0x260>
    myproc()->tf = tf;
80105f88:	e8 13 da ff ff       	call   801039a0 <myproc>
80105f8d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105f90:	e8 ab ee ff ff       	call   80104e40 <syscall>
    if(myproc()->killed)
80105f95:	e8 06 da ff ff       	call   801039a0 <myproc>
80105f9a:	8b 48 24             	mov    0x24(%eax),%ecx
80105f9d:	85 c9                	test   %ecx,%ecx
80105f9f:	0f 84 e3 fe ff ff    	je     80105e88 <trap+0x98>
}
80105fa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fa8:	5b                   	pop    %ebx
80105fa9:	5e                   	pop    %esi
80105faa:	5f                   	pop    %edi
80105fab:	5d                   	pop    %ebp
      exit();
80105fac:	e9 2f de ff ff       	jmp    80103de0 <exit>
80105fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105fb8:	e8 63 02 00 00       	call   80106220 <uartintr>
    lapiceoi();
80105fbd:	e8 2e c9 ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fc2:	e8 d9 d9 ff ff       	call   801039a0 <myproc>
80105fc7:	85 c0                	test   %eax,%eax
80105fc9:	0f 85 64 fe ff ff    	jne    80105e33 <trap+0x43>
80105fcf:	e9 79 fe ff ff       	jmp    80105e4d <trap+0x5d>
80105fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105fd8:	e8 e3 c7 ff ff       	call   801027c0 <kbdintr>
    lapiceoi();
80105fdd:	e8 0e c9 ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fe2:	e8 b9 d9 ff ff       	call   801039a0 <myproc>
80105fe7:	85 c0                	test   %eax,%eax
80105fe9:	0f 85 44 fe ff ff    	jne    80105e33 <trap+0x43>
80105fef:	e9 59 fe ff ff       	jmp    80105e4d <trap+0x5d>
80105ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ff8:	e8 83 d9 ff ff       	call   80103980 <cpuid>
80105ffd:	85 c0                	test   %eax,%eax
80105fff:	0f 85 20 fe ff ff    	jne    80105e25 <trap+0x35>
      acquire(&tickslock);
80106005:	83 ec 0c             	sub    $0xc,%esp
80106008:	68 80 54 11 80       	push   $0x80115480
8010600d:	e8 3e e9 ff ff       	call   80104950 <acquire>
      ticks++;
80106012:	83 05 60 54 11 80 01 	addl   $0x1,0x80115460
      wakeup(&ticks);
80106019:	c7 04 24 60 54 11 80 	movl   $0x80115460,(%esp)
80106020:	e8 cb e1 ff ff       	call   801041f0 <wakeup>
      release(&tickslock);
80106025:	c7 04 24 80 54 11 80 	movl   $0x80115480,(%esp)
8010602c:	e8 bf e8 ff ff       	call   801048f0 <release>
80106031:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106034:	e9 ec fd ff ff       	jmp    80105e25 <trap+0x35>
80106039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106040:	e8 9b dd ff ff       	call   80103de0 <exit>
80106045:	e9 03 fe ff ff       	jmp    80105e4d <trap+0x5d>
8010604a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106050:	e8 8b dd ff ff       	call   80103de0 <exit>
80106055:	e9 2e ff ff ff       	jmp    80105f88 <trap+0x198>
8010605a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      yield();
80106060:	e8 cb de ff ff       	call   80103f30 <yield>
80106065:	e9 fb fd ff ff       	jmp    80105e65 <trap+0x75>
8010606a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010606d:	e8 0e d9 ff ff       	call   80103980 <cpuid>
80106072:	83 ec 0c             	sub    $0xc,%esp
80106075:	56                   	push   %esi
80106076:	57                   	push   %edi
80106077:	50                   	push   %eax
80106078:	ff 73 30             	push   0x30(%ebx)
8010607b:	68 c4 7c 10 80       	push   $0x80107cc4
80106080:	e8 2b a6 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106085:	83 c4 14             	add    $0x14,%esp
80106088:	68 82 7a 10 80       	push   $0x80107a82
8010608d:	e8 ee a2 ff ff       	call   80100380 <panic>
80106092:	66 90                	xchg   %ax,%ax
80106094:	66 90                	xchg   %ax,%ax
80106096:	66 90                	xchg   %ax,%ax
80106098:	66 90                	xchg   %ax,%ax
8010609a:	66 90                	xchg   %ax,%ax
8010609c:	66 90                	xchg   %ax,%ax
8010609e:	66 90                	xchg   %ax,%ax

801060a0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801060a0:	a1 c0 5c 11 80       	mov    0x80115cc0,%eax
801060a5:	85 c0                	test   %eax,%eax
801060a7:	74 17                	je     801060c0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060a9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060ae:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801060af:	a8 01                	test   $0x1,%al
801060b1:	74 0d                	je     801060c0 <uartgetc+0x20>
801060b3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060b8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801060b9:	0f b6 c0             	movzbl %al,%eax
801060bc:	c3                   	ret
801060bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801060c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060c5:	c3                   	ret
801060c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801060cd:	00 
801060ce:	66 90                	xchg   %ax,%ax

801060d0 <uartinit>:
{
801060d0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060d1:	31 c9                	xor    %ecx,%ecx
801060d3:	89 c8                	mov    %ecx,%eax
801060d5:	89 e5                	mov    %esp,%ebp
801060d7:	57                   	push   %edi
801060d8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801060dd:	56                   	push   %esi
801060de:	89 fa                	mov    %edi,%edx
801060e0:	53                   	push   %ebx
801060e1:	83 ec 1c             	sub    $0x1c,%esp
801060e4:	ee                   	out    %al,(%dx)
801060e5:	be fb 03 00 00       	mov    $0x3fb,%esi
801060ea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801060ef:	89 f2                	mov    %esi,%edx
801060f1:	ee                   	out    %al,(%dx)
801060f2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060fc:	ee                   	out    %al,(%dx)
801060fd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106102:	89 c8                	mov    %ecx,%eax
80106104:	89 da                	mov    %ebx,%edx
80106106:	ee                   	out    %al,(%dx)
80106107:	b8 03 00 00 00       	mov    $0x3,%eax
8010610c:	89 f2                	mov    %esi,%edx
8010610e:	ee                   	out    %al,(%dx)
8010610f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106114:	89 c8                	mov    %ecx,%eax
80106116:	ee                   	out    %al,(%dx)
80106117:	b8 01 00 00 00       	mov    $0x1,%eax
8010611c:	89 da                	mov    %ebx,%edx
8010611e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010611f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106124:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106125:	3c ff                	cmp    $0xff,%al
80106127:	0f 84 7c 00 00 00    	je     801061a9 <uartinit+0xd9>
  uart = 1;
8010612d:	c7 05 c0 5c 11 80 01 	movl   $0x1,0x80115cc0
80106134:	00 00 00 
80106137:	89 fa                	mov    %edi,%edx
80106139:	ec                   	in     (%dx),%al
8010613a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010613f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106140:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106143:	bf 87 7a 10 80       	mov    $0x80107a87,%edi
80106148:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010614d:	6a 00                	push   $0x0
8010614f:	6a 04                	push   $0x4
80106151:	e8 0a c3 ff ff       	call   80102460 <ioapicenable>
80106156:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106159:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
8010615d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106160:	a1 c0 5c 11 80       	mov    0x80115cc0,%eax
80106165:	85 c0                	test   %eax,%eax
80106167:	74 32                	je     8010619b <uartinit+0xcb>
80106169:	89 f2                	mov    %esi,%edx
8010616b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010616c:	a8 20                	test   $0x20,%al
8010616e:	75 21                	jne    80106191 <uartinit+0xc1>
80106170:	bb 80 00 00 00       	mov    $0x80,%ebx
80106175:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106178:	83 ec 0c             	sub    $0xc,%esp
8010617b:	6a 0a                	push   $0xa
8010617d:	e8 8e c7 ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106182:	83 c4 10             	add    $0x10,%esp
80106185:	83 eb 01             	sub    $0x1,%ebx
80106188:	74 07                	je     80106191 <uartinit+0xc1>
8010618a:	89 f2                	mov    %esi,%edx
8010618c:	ec                   	in     (%dx),%al
8010618d:	a8 20                	test   $0x20,%al
8010618f:	74 e7                	je     80106178 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106191:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106196:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010619a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010619b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010619f:	83 c7 01             	add    $0x1,%edi
801061a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801061a5:	84 c0                	test   %al,%al
801061a7:	75 b7                	jne    80106160 <uartinit+0x90>
}
801061a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061ac:	5b                   	pop    %ebx
801061ad:	5e                   	pop    %esi
801061ae:	5f                   	pop    %edi
801061af:	5d                   	pop    %ebp
801061b0:	c3                   	ret
801061b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801061b8:	00 
801061b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061c0 <uartputc>:
  if(!uart)
801061c0:	a1 c0 5c 11 80       	mov    0x80115cc0,%eax
801061c5:	85 c0                	test   %eax,%eax
801061c7:	74 4f                	je     80106218 <uartputc+0x58>
{
801061c9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061ca:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061cf:	89 e5                	mov    %esp,%ebp
801061d1:	56                   	push   %esi
801061d2:	53                   	push   %ebx
801061d3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061d4:	a8 20                	test   $0x20,%al
801061d6:	75 29                	jne    80106201 <uartputc+0x41>
801061d8:	bb 80 00 00 00       	mov    $0x80,%ebx
801061dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801061e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801061e8:	83 ec 0c             	sub    $0xc,%esp
801061eb:	6a 0a                	push   $0xa
801061ed:	e8 1e c7 ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061f2:	83 c4 10             	add    $0x10,%esp
801061f5:	83 eb 01             	sub    $0x1,%ebx
801061f8:	74 07                	je     80106201 <uartputc+0x41>
801061fa:	89 f2                	mov    %esi,%edx
801061fc:	ec                   	in     (%dx),%al
801061fd:	a8 20                	test   $0x20,%al
801061ff:	74 e7                	je     801061e8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106201:	8b 45 08             	mov    0x8(%ebp),%eax
80106204:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106209:	ee                   	out    %al,(%dx)
}
8010620a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010620d:	5b                   	pop    %ebx
8010620e:	5e                   	pop    %esi
8010620f:	5d                   	pop    %ebp
80106210:	c3                   	ret
80106211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106218:	c3                   	ret
80106219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106220 <uartintr>:

void
uartintr(void)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106226:	68 a0 60 10 80       	push   $0x801060a0
8010622b:	e8 70 a6 ff ff       	call   801008a0 <consoleintr>
}
80106230:	83 c4 10             	add    $0x10,%esp
80106233:	c9                   	leave
80106234:	c3                   	ret

80106235 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106235:	6a 00                	push   $0x0
  pushl $0
80106237:	6a 00                	push   $0x0
  jmp alltraps
80106239:	e9 d9 fa ff ff       	jmp    80105d17 <alltraps>

8010623e <vector1>:
.globl vector1
vector1:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $1
80106240:	6a 01                	push   $0x1
  jmp alltraps
80106242:	e9 d0 fa ff ff       	jmp    80105d17 <alltraps>

80106247 <vector2>:
.globl vector2
vector2:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $2
80106249:	6a 02                	push   $0x2
  jmp alltraps
8010624b:	e9 c7 fa ff ff       	jmp    80105d17 <alltraps>

80106250 <vector3>:
.globl vector3
vector3:
  pushl $0
80106250:	6a 00                	push   $0x0
  pushl $3
80106252:	6a 03                	push   $0x3
  jmp alltraps
80106254:	e9 be fa ff ff       	jmp    80105d17 <alltraps>

80106259 <vector4>:
.globl vector4
vector4:
  pushl $0
80106259:	6a 00                	push   $0x0
  pushl $4
8010625b:	6a 04                	push   $0x4
  jmp alltraps
8010625d:	e9 b5 fa ff ff       	jmp    80105d17 <alltraps>

80106262 <vector5>:
.globl vector5
vector5:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $5
80106264:	6a 05                	push   $0x5
  jmp alltraps
80106266:	e9 ac fa ff ff       	jmp    80105d17 <alltraps>

8010626b <vector6>:
.globl vector6
vector6:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $6
8010626d:	6a 06                	push   $0x6
  jmp alltraps
8010626f:	e9 a3 fa ff ff       	jmp    80105d17 <alltraps>

80106274 <vector7>:
.globl vector7
vector7:
  pushl $0
80106274:	6a 00                	push   $0x0
  pushl $7
80106276:	6a 07                	push   $0x7
  jmp alltraps
80106278:	e9 9a fa ff ff       	jmp    80105d17 <alltraps>

8010627d <vector8>:
.globl vector8
vector8:
  pushl $8
8010627d:	6a 08                	push   $0x8
  jmp alltraps
8010627f:	e9 93 fa ff ff       	jmp    80105d17 <alltraps>

80106284 <vector9>:
.globl vector9
vector9:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $9
80106286:	6a 09                	push   $0x9
  jmp alltraps
80106288:	e9 8a fa ff ff       	jmp    80105d17 <alltraps>

8010628d <vector10>:
.globl vector10
vector10:
  pushl $10
8010628d:	6a 0a                	push   $0xa
  jmp alltraps
8010628f:	e9 83 fa ff ff       	jmp    80105d17 <alltraps>

80106294 <vector11>:
.globl vector11
vector11:
  pushl $11
80106294:	6a 0b                	push   $0xb
  jmp alltraps
80106296:	e9 7c fa ff ff       	jmp    80105d17 <alltraps>

8010629b <vector12>:
.globl vector12
vector12:
  pushl $12
8010629b:	6a 0c                	push   $0xc
  jmp alltraps
8010629d:	e9 75 fa ff ff       	jmp    80105d17 <alltraps>

801062a2 <vector13>:
.globl vector13
vector13:
  pushl $13
801062a2:	6a 0d                	push   $0xd
  jmp alltraps
801062a4:	e9 6e fa ff ff       	jmp    80105d17 <alltraps>

801062a9 <vector14>:
.globl vector14
vector14:
  pushl $14
801062a9:	6a 0e                	push   $0xe
  jmp alltraps
801062ab:	e9 67 fa ff ff       	jmp    80105d17 <alltraps>

801062b0 <vector15>:
.globl vector15
vector15:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $15
801062b2:	6a 0f                	push   $0xf
  jmp alltraps
801062b4:	e9 5e fa ff ff       	jmp    80105d17 <alltraps>

801062b9 <vector16>:
.globl vector16
vector16:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $16
801062bb:	6a 10                	push   $0x10
  jmp alltraps
801062bd:	e9 55 fa ff ff       	jmp    80105d17 <alltraps>

801062c2 <vector17>:
.globl vector17
vector17:
  pushl $17
801062c2:	6a 11                	push   $0x11
  jmp alltraps
801062c4:	e9 4e fa ff ff       	jmp    80105d17 <alltraps>

801062c9 <vector18>:
.globl vector18
vector18:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $18
801062cb:	6a 12                	push   $0x12
  jmp alltraps
801062cd:	e9 45 fa ff ff       	jmp    80105d17 <alltraps>

801062d2 <vector19>:
.globl vector19
vector19:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $19
801062d4:	6a 13                	push   $0x13
  jmp alltraps
801062d6:	e9 3c fa ff ff       	jmp    80105d17 <alltraps>

801062db <vector20>:
.globl vector20
vector20:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $20
801062dd:	6a 14                	push   $0x14
  jmp alltraps
801062df:	e9 33 fa ff ff       	jmp    80105d17 <alltraps>

801062e4 <vector21>:
.globl vector21
vector21:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $21
801062e6:	6a 15                	push   $0x15
  jmp alltraps
801062e8:	e9 2a fa ff ff       	jmp    80105d17 <alltraps>

801062ed <vector22>:
.globl vector22
vector22:
  pushl $0
801062ed:	6a 00                	push   $0x0
  pushl $22
801062ef:	6a 16                	push   $0x16
  jmp alltraps
801062f1:	e9 21 fa ff ff       	jmp    80105d17 <alltraps>

801062f6 <vector23>:
.globl vector23
vector23:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $23
801062f8:	6a 17                	push   $0x17
  jmp alltraps
801062fa:	e9 18 fa ff ff       	jmp    80105d17 <alltraps>

801062ff <vector24>:
.globl vector24
vector24:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $24
80106301:	6a 18                	push   $0x18
  jmp alltraps
80106303:	e9 0f fa ff ff       	jmp    80105d17 <alltraps>

80106308 <vector25>:
.globl vector25
vector25:
  pushl $0
80106308:	6a 00                	push   $0x0
  pushl $25
8010630a:	6a 19                	push   $0x19
  jmp alltraps
8010630c:	e9 06 fa ff ff       	jmp    80105d17 <alltraps>

80106311 <vector26>:
.globl vector26
vector26:
  pushl $0
80106311:	6a 00                	push   $0x0
  pushl $26
80106313:	6a 1a                	push   $0x1a
  jmp alltraps
80106315:	e9 fd f9 ff ff       	jmp    80105d17 <alltraps>

8010631a <vector27>:
.globl vector27
vector27:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $27
8010631c:	6a 1b                	push   $0x1b
  jmp alltraps
8010631e:	e9 f4 f9 ff ff       	jmp    80105d17 <alltraps>

80106323 <vector28>:
.globl vector28
vector28:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $28
80106325:	6a 1c                	push   $0x1c
  jmp alltraps
80106327:	e9 eb f9 ff ff       	jmp    80105d17 <alltraps>

8010632c <vector29>:
.globl vector29
vector29:
  pushl $0
8010632c:	6a 00                	push   $0x0
  pushl $29
8010632e:	6a 1d                	push   $0x1d
  jmp alltraps
80106330:	e9 e2 f9 ff ff       	jmp    80105d17 <alltraps>

80106335 <vector30>:
.globl vector30
vector30:
  pushl $0
80106335:	6a 00                	push   $0x0
  pushl $30
80106337:	6a 1e                	push   $0x1e
  jmp alltraps
80106339:	e9 d9 f9 ff ff       	jmp    80105d17 <alltraps>

8010633e <vector31>:
.globl vector31
vector31:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $31
80106340:	6a 1f                	push   $0x1f
  jmp alltraps
80106342:	e9 d0 f9 ff ff       	jmp    80105d17 <alltraps>

80106347 <vector32>:
.globl vector32
vector32:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $32
80106349:	6a 20                	push   $0x20
  jmp alltraps
8010634b:	e9 c7 f9 ff ff       	jmp    80105d17 <alltraps>

80106350 <vector33>:
.globl vector33
vector33:
  pushl $0
80106350:	6a 00                	push   $0x0
  pushl $33
80106352:	6a 21                	push   $0x21
  jmp alltraps
80106354:	e9 be f9 ff ff       	jmp    80105d17 <alltraps>

80106359 <vector34>:
.globl vector34
vector34:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $34
8010635b:	6a 22                	push   $0x22
  jmp alltraps
8010635d:	e9 b5 f9 ff ff       	jmp    80105d17 <alltraps>

80106362 <vector35>:
.globl vector35
vector35:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $35
80106364:	6a 23                	push   $0x23
  jmp alltraps
80106366:	e9 ac f9 ff ff       	jmp    80105d17 <alltraps>

8010636b <vector36>:
.globl vector36
vector36:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $36
8010636d:	6a 24                	push   $0x24
  jmp alltraps
8010636f:	e9 a3 f9 ff ff       	jmp    80105d17 <alltraps>

80106374 <vector37>:
.globl vector37
vector37:
  pushl $0
80106374:	6a 00                	push   $0x0
  pushl $37
80106376:	6a 25                	push   $0x25
  jmp alltraps
80106378:	e9 9a f9 ff ff       	jmp    80105d17 <alltraps>

8010637d <vector38>:
.globl vector38
vector38:
  pushl $0
8010637d:	6a 00                	push   $0x0
  pushl $38
8010637f:	6a 26                	push   $0x26
  jmp alltraps
80106381:	e9 91 f9 ff ff       	jmp    80105d17 <alltraps>

80106386 <vector39>:
.globl vector39
vector39:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $39
80106388:	6a 27                	push   $0x27
  jmp alltraps
8010638a:	e9 88 f9 ff ff       	jmp    80105d17 <alltraps>

8010638f <vector40>:
.globl vector40
vector40:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $40
80106391:	6a 28                	push   $0x28
  jmp alltraps
80106393:	e9 7f f9 ff ff       	jmp    80105d17 <alltraps>

80106398 <vector41>:
.globl vector41
vector41:
  pushl $0
80106398:	6a 00                	push   $0x0
  pushl $41
8010639a:	6a 29                	push   $0x29
  jmp alltraps
8010639c:	e9 76 f9 ff ff       	jmp    80105d17 <alltraps>

801063a1 <vector42>:
.globl vector42
vector42:
  pushl $0
801063a1:	6a 00                	push   $0x0
  pushl $42
801063a3:	6a 2a                	push   $0x2a
  jmp alltraps
801063a5:	e9 6d f9 ff ff       	jmp    80105d17 <alltraps>

801063aa <vector43>:
.globl vector43
vector43:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $43
801063ac:	6a 2b                	push   $0x2b
  jmp alltraps
801063ae:	e9 64 f9 ff ff       	jmp    80105d17 <alltraps>

801063b3 <vector44>:
.globl vector44
vector44:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $44
801063b5:	6a 2c                	push   $0x2c
  jmp alltraps
801063b7:	e9 5b f9 ff ff       	jmp    80105d17 <alltraps>

801063bc <vector45>:
.globl vector45
vector45:
  pushl $0
801063bc:	6a 00                	push   $0x0
  pushl $45
801063be:	6a 2d                	push   $0x2d
  jmp alltraps
801063c0:	e9 52 f9 ff ff       	jmp    80105d17 <alltraps>

801063c5 <vector46>:
.globl vector46
vector46:
  pushl $0
801063c5:	6a 00                	push   $0x0
  pushl $46
801063c7:	6a 2e                	push   $0x2e
  jmp alltraps
801063c9:	e9 49 f9 ff ff       	jmp    80105d17 <alltraps>

801063ce <vector47>:
.globl vector47
vector47:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $47
801063d0:	6a 2f                	push   $0x2f
  jmp alltraps
801063d2:	e9 40 f9 ff ff       	jmp    80105d17 <alltraps>

801063d7 <vector48>:
.globl vector48
vector48:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $48
801063d9:	6a 30                	push   $0x30
  jmp alltraps
801063db:	e9 37 f9 ff ff       	jmp    80105d17 <alltraps>

801063e0 <vector49>:
.globl vector49
vector49:
  pushl $0
801063e0:	6a 00                	push   $0x0
  pushl $49
801063e2:	6a 31                	push   $0x31
  jmp alltraps
801063e4:	e9 2e f9 ff ff       	jmp    80105d17 <alltraps>

801063e9 <vector50>:
.globl vector50
vector50:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $50
801063eb:	6a 32                	push   $0x32
  jmp alltraps
801063ed:	e9 25 f9 ff ff       	jmp    80105d17 <alltraps>

801063f2 <vector51>:
.globl vector51
vector51:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $51
801063f4:	6a 33                	push   $0x33
  jmp alltraps
801063f6:	e9 1c f9 ff ff       	jmp    80105d17 <alltraps>

801063fb <vector52>:
.globl vector52
vector52:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $52
801063fd:	6a 34                	push   $0x34
  jmp alltraps
801063ff:	e9 13 f9 ff ff       	jmp    80105d17 <alltraps>

80106404 <vector53>:
.globl vector53
vector53:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $53
80106406:	6a 35                	push   $0x35
  jmp alltraps
80106408:	e9 0a f9 ff ff       	jmp    80105d17 <alltraps>

8010640d <vector54>:
.globl vector54
vector54:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $54
8010640f:	6a 36                	push   $0x36
  jmp alltraps
80106411:	e9 01 f9 ff ff       	jmp    80105d17 <alltraps>

80106416 <vector55>:
.globl vector55
vector55:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $55
80106418:	6a 37                	push   $0x37
  jmp alltraps
8010641a:	e9 f8 f8 ff ff       	jmp    80105d17 <alltraps>

8010641f <vector56>:
.globl vector56
vector56:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $56
80106421:	6a 38                	push   $0x38
  jmp alltraps
80106423:	e9 ef f8 ff ff       	jmp    80105d17 <alltraps>

80106428 <vector57>:
.globl vector57
vector57:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $57
8010642a:	6a 39                	push   $0x39
  jmp alltraps
8010642c:	e9 e6 f8 ff ff       	jmp    80105d17 <alltraps>

80106431 <vector58>:
.globl vector58
vector58:
  pushl $0
80106431:	6a 00                	push   $0x0
  pushl $58
80106433:	6a 3a                	push   $0x3a
  jmp alltraps
80106435:	e9 dd f8 ff ff       	jmp    80105d17 <alltraps>

8010643a <vector59>:
.globl vector59
vector59:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $59
8010643c:	6a 3b                	push   $0x3b
  jmp alltraps
8010643e:	e9 d4 f8 ff ff       	jmp    80105d17 <alltraps>

80106443 <vector60>:
.globl vector60
vector60:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $60
80106445:	6a 3c                	push   $0x3c
  jmp alltraps
80106447:	e9 cb f8 ff ff       	jmp    80105d17 <alltraps>

8010644c <vector61>:
.globl vector61
vector61:
  pushl $0
8010644c:	6a 00                	push   $0x0
  pushl $61
8010644e:	6a 3d                	push   $0x3d
  jmp alltraps
80106450:	e9 c2 f8 ff ff       	jmp    80105d17 <alltraps>

80106455 <vector62>:
.globl vector62
vector62:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $62
80106457:	6a 3e                	push   $0x3e
  jmp alltraps
80106459:	e9 b9 f8 ff ff       	jmp    80105d17 <alltraps>

8010645e <vector63>:
.globl vector63
vector63:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $63
80106460:	6a 3f                	push   $0x3f
  jmp alltraps
80106462:	e9 b0 f8 ff ff       	jmp    80105d17 <alltraps>

80106467 <vector64>:
.globl vector64
vector64:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $64
80106469:	6a 40                	push   $0x40
  jmp alltraps
8010646b:	e9 a7 f8 ff ff       	jmp    80105d17 <alltraps>

80106470 <vector65>:
.globl vector65
vector65:
  pushl $0
80106470:	6a 00                	push   $0x0
  pushl $65
80106472:	6a 41                	push   $0x41
  jmp alltraps
80106474:	e9 9e f8 ff ff       	jmp    80105d17 <alltraps>

80106479 <vector66>:
.globl vector66
vector66:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $66
8010647b:	6a 42                	push   $0x42
  jmp alltraps
8010647d:	e9 95 f8 ff ff       	jmp    80105d17 <alltraps>

80106482 <vector67>:
.globl vector67
vector67:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $67
80106484:	6a 43                	push   $0x43
  jmp alltraps
80106486:	e9 8c f8 ff ff       	jmp    80105d17 <alltraps>

8010648b <vector68>:
.globl vector68
vector68:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $68
8010648d:	6a 44                	push   $0x44
  jmp alltraps
8010648f:	e9 83 f8 ff ff       	jmp    80105d17 <alltraps>

80106494 <vector69>:
.globl vector69
vector69:
  pushl $0
80106494:	6a 00                	push   $0x0
  pushl $69
80106496:	6a 45                	push   $0x45
  jmp alltraps
80106498:	e9 7a f8 ff ff       	jmp    80105d17 <alltraps>

8010649d <vector70>:
.globl vector70
vector70:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $70
8010649f:	6a 46                	push   $0x46
  jmp alltraps
801064a1:	e9 71 f8 ff ff       	jmp    80105d17 <alltraps>

801064a6 <vector71>:
.globl vector71
vector71:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $71
801064a8:	6a 47                	push   $0x47
  jmp alltraps
801064aa:	e9 68 f8 ff ff       	jmp    80105d17 <alltraps>

801064af <vector72>:
.globl vector72
vector72:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $72
801064b1:	6a 48                	push   $0x48
  jmp alltraps
801064b3:	e9 5f f8 ff ff       	jmp    80105d17 <alltraps>

801064b8 <vector73>:
.globl vector73
vector73:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $73
801064ba:	6a 49                	push   $0x49
  jmp alltraps
801064bc:	e9 56 f8 ff ff       	jmp    80105d17 <alltraps>

801064c1 <vector74>:
.globl vector74
vector74:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $74
801064c3:	6a 4a                	push   $0x4a
  jmp alltraps
801064c5:	e9 4d f8 ff ff       	jmp    80105d17 <alltraps>

801064ca <vector75>:
.globl vector75
vector75:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $75
801064cc:	6a 4b                	push   $0x4b
  jmp alltraps
801064ce:	e9 44 f8 ff ff       	jmp    80105d17 <alltraps>

801064d3 <vector76>:
.globl vector76
vector76:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $76
801064d5:	6a 4c                	push   $0x4c
  jmp alltraps
801064d7:	e9 3b f8 ff ff       	jmp    80105d17 <alltraps>

801064dc <vector77>:
.globl vector77
vector77:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $77
801064de:	6a 4d                	push   $0x4d
  jmp alltraps
801064e0:	e9 32 f8 ff ff       	jmp    80105d17 <alltraps>

801064e5 <vector78>:
.globl vector78
vector78:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $78
801064e7:	6a 4e                	push   $0x4e
  jmp alltraps
801064e9:	e9 29 f8 ff ff       	jmp    80105d17 <alltraps>

801064ee <vector79>:
.globl vector79
vector79:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $79
801064f0:	6a 4f                	push   $0x4f
  jmp alltraps
801064f2:	e9 20 f8 ff ff       	jmp    80105d17 <alltraps>

801064f7 <vector80>:
.globl vector80
vector80:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $80
801064f9:	6a 50                	push   $0x50
  jmp alltraps
801064fb:	e9 17 f8 ff ff       	jmp    80105d17 <alltraps>

80106500 <vector81>:
.globl vector81
vector81:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $81
80106502:	6a 51                	push   $0x51
  jmp alltraps
80106504:	e9 0e f8 ff ff       	jmp    80105d17 <alltraps>

80106509 <vector82>:
.globl vector82
vector82:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $82
8010650b:	6a 52                	push   $0x52
  jmp alltraps
8010650d:	e9 05 f8 ff ff       	jmp    80105d17 <alltraps>

80106512 <vector83>:
.globl vector83
vector83:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $83
80106514:	6a 53                	push   $0x53
  jmp alltraps
80106516:	e9 fc f7 ff ff       	jmp    80105d17 <alltraps>

8010651b <vector84>:
.globl vector84
vector84:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $84
8010651d:	6a 54                	push   $0x54
  jmp alltraps
8010651f:	e9 f3 f7 ff ff       	jmp    80105d17 <alltraps>

80106524 <vector85>:
.globl vector85
vector85:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $85
80106526:	6a 55                	push   $0x55
  jmp alltraps
80106528:	e9 ea f7 ff ff       	jmp    80105d17 <alltraps>

8010652d <vector86>:
.globl vector86
vector86:
  pushl $0
8010652d:	6a 00                	push   $0x0
  pushl $86
8010652f:	6a 56                	push   $0x56
  jmp alltraps
80106531:	e9 e1 f7 ff ff       	jmp    80105d17 <alltraps>

80106536 <vector87>:
.globl vector87
vector87:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $87
80106538:	6a 57                	push   $0x57
  jmp alltraps
8010653a:	e9 d8 f7 ff ff       	jmp    80105d17 <alltraps>

8010653f <vector88>:
.globl vector88
vector88:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $88
80106541:	6a 58                	push   $0x58
  jmp alltraps
80106543:	e9 cf f7 ff ff       	jmp    80105d17 <alltraps>

80106548 <vector89>:
.globl vector89
vector89:
  pushl $0
80106548:	6a 00                	push   $0x0
  pushl $89
8010654a:	6a 59                	push   $0x59
  jmp alltraps
8010654c:	e9 c6 f7 ff ff       	jmp    80105d17 <alltraps>

80106551 <vector90>:
.globl vector90
vector90:
  pushl $0
80106551:	6a 00                	push   $0x0
  pushl $90
80106553:	6a 5a                	push   $0x5a
  jmp alltraps
80106555:	e9 bd f7 ff ff       	jmp    80105d17 <alltraps>

8010655a <vector91>:
.globl vector91
vector91:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $91
8010655c:	6a 5b                	push   $0x5b
  jmp alltraps
8010655e:	e9 b4 f7 ff ff       	jmp    80105d17 <alltraps>

80106563 <vector92>:
.globl vector92
vector92:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $92
80106565:	6a 5c                	push   $0x5c
  jmp alltraps
80106567:	e9 ab f7 ff ff       	jmp    80105d17 <alltraps>

8010656c <vector93>:
.globl vector93
vector93:
  pushl $0
8010656c:	6a 00                	push   $0x0
  pushl $93
8010656e:	6a 5d                	push   $0x5d
  jmp alltraps
80106570:	e9 a2 f7 ff ff       	jmp    80105d17 <alltraps>

80106575 <vector94>:
.globl vector94
vector94:
  pushl $0
80106575:	6a 00                	push   $0x0
  pushl $94
80106577:	6a 5e                	push   $0x5e
  jmp alltraps
80106579:	e9 99 f7 ff ff       	jmp    80105d17 <alltraps>

8010657e <vector95>:
.globl vector95
vector95:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $95
80106580:	6a 5f                	push   $0x5f
  jmp alltraps
80106582:	e9 90 f7 ff ff       	jmp    80105d17 <alltraps>

80106587 <vector96>:
.globl vector96
vector96:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $96
80106589:	6a 60                	push   $0x60
  jmp alltraps
8010658b:	e9 87 f7 ff ff       	jmp    80105d17 <alltraps>

80106590 <vector97>:
.globl vector97
vector97:
  pushl $0
80106590:	6a 00                	push   $0x0
  pushl $97
80106592:	6a 61                	push   $0x61
  jmp alltraps
80106594:	e9 7e f7 ff ff       	jmp    80105d17 <alltraps>

80106599 <vector98>:
.globl vector98
vector98:
  pushl $0
80106599:	6a 00                	push   $0x0
  pushl $98
8010659b:	6a 62                	push   $0x62
  jmp alltraps
8010659d:	e9 75 f7 ff ff       	jmp    80105d17 <alltraps>

801065a2 <vector99>:
.globl vector99
vector99:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $99
801065a4:	6a 63                	push   $0x63
  jmp alltraps
801065a6:	e9 6c f7 ff ff       	jmp    80105d17 <alltraps>

801065ab <vector100>:
.globl vector100
vector100:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $100
801065ad:	6a 64                	push   $0x64
  jmp alltraps
801065af:	e9 63 f7 ff ff       	jmp    80105d17 <alltraps>

801065b4 <vector101>:
.globl vector101
vector101:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $101
801065b6:	6a 65                	push   $0x65
  jmp alltraps
801065b8:	e9 5a f7 ff ff       	jmp    80105d17 <alltraps>

801065bd <vector102>:
.globl vector102
vector102:
  pushl $0
801065bd:	6a 00                	push   $0x0
  pushl $102
801065bf:	6a 66                	push   $0x66
  jmp alltraps
801065c1:	e9 51 f7 ff ff       	jmp    80105d17 <alltraps>

801065c6 <vector103>:
.globl vector103
vector103:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $103
801065c8:	6a 67                	push   $0x67
  jmp alltraps
801065ca:	e9 48 f7 ff ff       	jmp    80105d17 <alltraps>

801065cf <vector104>:
.globl vector104
vector104:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $104
801065d1:	6a 68                	push   $0x68
  jmp alltraps
801065d3:	e9 3f f7 ff ff       	jmp    80105d17 <alltraps>

801065d8 <vector105>:
.globl vector105
vector105:
  pushl $0
801065d8:	6a 00                	push   $0x0
  pushl $105
801065da:	6a 69                	push   $0x69
  jmp alltraps
801065dc:	e9 36 f7 ff ff       	jmp    80105d17 <alltraps>

801065e1 <vector106>:
.globl vector106
vector106:
  pushl $0
801065e1:	6a 00                	push   $0x0
  pushl $106
801065e3:	6a 6a                	push   $0x6a
  jmp alltraps
801065e5:	e9 2d f7 ff ff       	jmp    80105d17 <alltraps>

801065ea <vector107>:
.globl vector107
vector107:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $107
801065ec:	6a 6b                	push   $0x6b
  jmp alltraps
801065ee:	e9 24 f7 ff ff       	jmp    80105d17 <alltraps>

801065f3 <vector108>:
.globl vector108
vector108:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $108
801065f5:	6a 6c                	push   $0x6c
  jmp alltraps
801065f7:	e9 1b f7 ff ff       	jmp    80105d17 <alltraps>

801065fc <vector109>:
.globl vector109
vector109:
  pushl $0
801065fc:	6a 00                	push   $0x0
  pushl $109
801065fe:	6a 6d                	push   $0x6d
  jmp alltraps
80106600:	e9 12 f7 ff ff       	jmp    80105d17 <alltraps>

80106605 <vector110>:
.globl vector110
vector110:
  pushl $0
80106605:	6a 00                	push   $0x0
  pushl $110
80106607:	6a 6e                	push   $0x6e
  jmp alltraps
80106609:	e9 09 f7 ff ff       	jmp    80105d17 <alltraps>

8010660e <vector111>:
.globl vector111
vector111:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $111
80106610:	6a 6f                	push   $0x6f
  jmp alltraps
80106612:	e9 00 f7 ff ff       	jmp    80105d17 <alltraps>

80106617 <vector112>:
.globl vector112
vector112:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $112
80106619:	6a 70                	push   $0x70
  jmp alltraps
8010661b:	e9 f7 f6 ff ff       	jmp    80105d17 <alltraps>

80106620 <vector113>:
.globl vector113
vector113:
  pushl $0
80106620:	6a 00                	push   $0x0
  pushl $113
80106622:	6a 71                	push   $0x71
  jmp alltraps
80106624:	e9 ee f6 ff ff       	jmp    80105d17 <alltraps>

80106629 <vector114>:
.globl vector114
vector114:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $114
8010662b:	6a 72                	push   $0x72
  jmp alltraps
8010662d:	e9 e5 f6 ff ff       	jmp    80105d17 <alltraps>

80106632 <vector115>:
.globl vector115
vector115:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $115
80106634:	6a 73                	push   $0x73
  jmp alltraps
80106636:	e9 dc f6 ff ff       	jmp    80105d17 <alltraps>

8010663b <vector116>:
.globl vector116
vector116:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $116
8010663d:	6a 74                	push   $0x74
  jmp alltraps
8010663f:	e9 d3 f6 ff ff       	jmp    80105d17 <alltraps>

80106644 <vector117>:
.globl vector117
vector117:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $117
80106646:	6a 75                	push   $0x75
  jmp alltraps
80106648:	e9 ca f6 ff ff       	jmp    80105d17 <alltraps>

8010664d <vector118>:
.globl vector118
vector118:
  pushl $0
8010664d:	6a 00                	push   $0x0
  pushl $118
8010664f:	6a 76                	push   $0x76
  jmp alltraps
80106651:	e9 c1 f6 ff ff       	jmp    80105d17 <alltraps>

80106656 <vector119>:
.globl vector119
vector119:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $119
80106658:	6a 77                	push   $0x77
  jmp alltraps
8010665a:	e9 b8 f6 ff ff       	jmp    80105d17 <alltraps>

8010665f <vector120>:
.globl vector120
vector120:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $120
80106661:	6a 78                	push   $0x78
  jmp alltraps
80106663:	e9 af f6 ff ff       	jmp    80105d17 <alltraps>

80106668 <vector121>:
.globl vector121
vector121:
  pushl $0
80106668:	6a 00                	push   $0x0
  pushl $121
8010666a:	6a 79                	push   $0x79
  jmp alltraps
8010666c:	e9 a6 f6 ff ff       	jmp    80105d17 <alltraps>

80106671 <vector122>:
.globl vector122
vector122:
  pushl $0
80106671:	6a 00                	push   $0x0
  pushl $122
80106673:	6a 7a                	push   $0x7a
  jmp alltraps
80106675:	e9 9d f6 ff ff       	jmp    80105d17 <alltraps>

8010667a <vector123>:
.globl vector123
vector123:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $123
8010667c:	6a 7b                	push   $0x7b
  jmp alltraps
8010667e:	e9 94 f6 ff ff       	jmp    80105d17 <alltraps>

80106683 <vector124>:
.globl vector124
vector124:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $124
80106685:	6a 7c                	push   $0x7c
  jmp alltraps
80106687:	e9 8b f6 ff ff       	jmp    80105d17 <alltraps>

8010668c <vector125>:
.globl vector125
vector125:
  pushl $0
8010668c:	6a 00                	push   $0x0
  pushl $125
8010668e:	6a 7d                	push   $0x7d
  jmp alltraps
80106690:	e9 82 f6 ff ff       	jmp    80105d17 <alltraps>

80106695 <vector126>:
.globl vector126
vector126:
  pushl $0
80106695:	6a 00                	push   $0x0
  pushl $126
80106697:	6a 7e                	push   $0x7e
  jmp alltraps
80106699:	e9 79 f6 ff ff       	jmp    80105d17 <alltraps>

8010669e <vector127>:
.globl vector127
vector127:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $127
801066a0:	6a 7f                	push   $0x7f
  jmp alltraps
801066a2:	e9 70 f6 ff ff       	jmp    80105d17 <alltraps>

801066a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $128
801066a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801066ae:	e9 64 f6 ff ff       	jmp    80105d17 <alltraps>

801066b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $129
801066b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801066ba:	e9 58 f6 ff ff       	jmp    80105d17 <alltraps>

801066bf <vector130>:
.globl vector130
vector130:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $130
801066c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801066c6:	e9 4c f6 ff ff       	jmp    80105d17 <alltraps>

801066cb <vector131>:
.globl vector131
vector131:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $131
801066cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066d2:	e9 40 f6 ff ff       	jmp    80105d17 <alltraps>

801066d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $132
801066d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066de:	e9 34 f6 ff ff       	jmp    80105d17 <alltraps>

801066e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $133
801066e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066ea:	e9 28 f6 ff ff       	jmp    80105d17 <alltraps>

801066ef <vector134>:
.globl vector134
vector134:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $134
801066f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066f6:	e9 1c f6 ff ff       	jmp    80105d17 <alltraps>

801066fb <vector135>:
.globl vector135
vector135:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $135
801066fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106702:	e9 10 f6 ff ff       	jmp    80105d17 <alltraps>

80106707 <vector136>:
.globl vector136
vector136:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $136
80106709:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010670e:	e9 04 f6 ff ff       	jmp    80105d17 <alltraps>

80106713 <vector137>:
.globl vector137
vector137:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $137
80106715:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010671a:	e9 f8 f5 ff ff       	jmp    80105d17 <alltraps>

8010671f <vector138>:
.globl vector138
vector138:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $138
80106721:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106726:	e9 ec f5 ff ff       	jmp    80105d17 <alltraps>

8010672b <vector139>:
.globl vector139
vector139:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $139
8010672d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106732:	e9 e0 f5 ff ff       	jmp    80105d17 <alltraps>

80106737 <vector140>:
.globl vector140
vector140:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $140
80106739:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010673e:	e9 d4 f5 ff ff       	jmp    80105d17 <alltraps>

80106743 <vector141>:
.globl vector141
vector141:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $141
80106745:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010674a:	e9 c8 f5 ff ff       	jmp    80105d17 <alltraps>

8010674f <vector142>:
.globl vector142
vector142:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $142
80106751:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106756:	e9 bc f5 ff ff       	jmp    80105d17 <alltraps>

8010675b <vector143>:
.globl vector143
vector143:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $143
8010675d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106762:	e9 b0 f5 ff ff       	jmp    80105d17 <alltraps>

80106767 <vector144>:
.globl vector144
vector144:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $144
80106769:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010676e:	e9 a4 f5 ff ff       	jmp    80105d17 <alltraps>

80106773 <vector145>:
.globl vector145
vector145:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $145
80106775:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010677a:	e9 98 f5 ff ff       	jmp    80105d17 <alltraps>

8010677f <vector146>:
.globl vector146
vector146:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $146
80106781:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106786:	e9 8c f5 ff ff       	jmp    80105d17 <alltraps>

8010678b <vector147>:
.globl vector147
vector147:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $147
8010678d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106792:	e9 80 f5 ff ff       	jmp    80105d17 <alltraps>

80106797 <vector148>:
.globl vector148
vector148:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $148
80106799:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010679e:	e9 74 f5 ff ff       	jmp    80105d17 <alltraps>

801067a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $149
801067a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801067aa:	e9 68 f5 ff ff       	jmp    80105d17 <alltraps>

801067af <vector150>:
.globl vector150
vector150:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $150
801067b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801067b6:	e9 5c f5 ff ff       	jmp    80105d17 <alltraps>

801067bb <vector151>:
.globl vector151
vector151:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $151
801067bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801067c2:	e9 50 f5 ff ff       	jmp    80105d17 <alltraps>

801067c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $152
801067c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067ce:	e9 44 f5 ff ff       	jmp    80105d17 <alltraps>

801067d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $153
801067d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067da:	e9 38 f5 ff ff       	jmp    80105d17 <alltraps>

801067df <vector154>:
.globl vector154
vector154:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $154
801067e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067e6:	e9 2c f5 ff ff       	jmp    80105d17 <alltraps>

801067eb <vector155>:
.globl vector155
vector155:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $155
801067ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067f2:	e9 20 f5 ff ff       	jmp    80105d17 <alltraps>

801067f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $156
801067f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067fe:	e9 14 f5 ff ff       	jmp    80105d17 <alltraps>

80106803 <vector157>:
.globl vector157
vector157:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $157
80106805:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010680a:	e9 08 f5 ff ff       	jmp    80105d17 <alltraps>

8010680f <vector158>:
.globl vector158
vector158:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $158
80106811:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106816:	e9 fc f4 ff ff       	jmp    80105d17 <alltraps>

8010681b <vector159>:
.globl vector159
vector159:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $159
8010681d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106822:	e9 f0 f4 ff ff       	jmp    80105d17 <alltraps>

80106827 <vector160>:
.globl vector160
vector160:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $160
80106829:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010682e:	e9 e4 f4 ff ff       	jmp    80105d17 <alltraps>

80106833 <vector161>:
.globl vector161
vector161:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $161
80106835:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010683a:	e9 d8 f4 ff ff       	jmp    80105d17 <alltraps>

8010683f <vector162>:
.globl vector162
vector162:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $162
80106841:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106846:	e9 cc f4 ff ff       	jmp    80105d17 <alltraps>

8010684b <vector163>:
.globl vector163
vector163:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $163
8010684d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106852:	e9 c0 f4 ff ff       	jmp    80105d17 <alltraps>

80106857 <vector164>:
.globl vector164
vector164:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $164
80106859:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010685e:	e9 b4 f4 ff ff       	jmp    80105d17 <alltraps>

80106863 <vector165>:
.globl vector165
vector165:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $165
80106865:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010686a:	e9 a8 f4 ff ff       	jmp    80105d17 <alltraps>

8010686f <vector166>:
.globl vector166
vector166:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $166
80106871:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106876:	e9 9c f4 ff ff       	jmp    80105d17 <alltraps>

8010687b <vector167>:
.globl vector167
vector167:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $167
8010687d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106882:	e9 90 f4 ff ff       	jmp    80105d17 <alltraps>

80106887 <vector168>:
.globl vector168
vector168:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $168
80106889:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010688e:	e9 84 f4 ff ff       	jmp    80105d17 <alltraps>

80106893 <vector169>:
.globl vector169
vector169:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $169
80106895:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010689a:	e9 78 f4 ff ff       	jmp    80105d17 <alltraps>

8010689f <vector170>:
.globl vector170
vector170:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $170
801068a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801068a6:	e9 6c f4 ff ff       	jmp    80105d17 <alltraps>

801068ab <vector171>:
.globl vector171
vector171:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $171
801068ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801068b2:	e9 60 f4 ff ff       	jmp    80105d17 <alltraps>

801068b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $172
801068b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801068be:	e9 54 f4 ff ff       	jmp    80105d17 <alltraps>

801068c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $173
801068c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801068ca:	e9 48 f4 ff ff       	jmp    80105d17 <alltraps>

801068cf <vector174>:
.globl vector174
vector174:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $174
801068d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068d6:	e9 3c f4 ff ff       	jmp    80105d17 <alltraps>

801068db <vector175>:
.globl vector175
vector175:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $175
801068dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068e2:	e9 30 f4 ff ff       	jmp    80105d17 <alltraps>

801068e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $176
801068e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068ee:	e9 24 f4 ff ff       	jmp    80105d17 <alltraps>

801068f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $177
801068f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068fa:	e9 18 f4 ff ff       	jmp    80105d17 <alltraps>

801068ff <vector178>:
.globl vector178
vector178:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $178
80106901:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106906:	e9 0c f4 ff ff       	jmp    80105d17 <alltraps>

8010690b <vector179>:
.globl vector179
vector179:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $179
8010690d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106912:	e9 00 f4 ff ff       	jmp    80105d17 <alltraps>

80106917 <vector180>:
.globl vector180
vector180:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $180
80106919:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010691e:	e9 f4 f3 ff ff       	jmp    80105d17 <alltraps>

80106923 <vector181>:
.globl vector181
vector181:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $181
80106925:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010692a:	e9 e8 f3 ff ff       	jmp    80105d17 <alltraps>

8010692f <vector182>:
.globl vector182
vector182:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $182
80106931:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106936:	e9 dc f3 ff ff       	jmp    80105d17 <alltraps>

8010693b <vector183>:
.globl vector183
vector183:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $183
8010693d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106942:	e9 d0 f3 ff ff       	jmp    80105d17 <alltraps>

80106947 <vector184>:
.globl vector184
vector184:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $184
80106949:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010694e:	e9 c4 f3 ff ff       	jmp    80105d17 <alltraps>

80106953 <vector185>:
.globl vector185
vector185:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $185
80106955:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010695a:	e9 b8 f3 ff ff       	jmp    80105d17 <alltraps>

8010695f <vector186>:
.globl vector186
vector186:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $186
80106961:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106966:	e9 ac f3 ff ff       	jmp    80105d17 <alltraps>

8010696b <vector187>:
.globl vector187
vector187:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $187
8010696d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106972:	e9 a0 f3 ff ff       	jmp    80105d17 <alltraps>

80106977 <vector188>:
.globl vector188
vector188:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $188
80106979:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010697e:	e9 94 f3 ff ff       	jmp    80105d17 <alltraps>

80106983 <vector189>:
.globl vector189
vector189:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $189
80106985:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010698a:	e9 88 f3 ff ff       	jmp    80105d17 <alltraps>

8010698f <vector190>:
.globl vector190
vector190:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $190
80106991:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106996:	e9 7c f3 ff ff       	jmp    80105d17 <alltraps>

8010699b <vector191>:
.globl vector191
vector191:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $191
8010699d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801069a2:	e9 70 f3 ff ff       	jmp    80105d17 <alltraps>

801069a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $192
801069a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801069ae:	e9 64 f3 ff ff       	jmp    80105d17 <alltraps>

801069b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $193
801069b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801069ba:	e9 58 f3 ff ff       	jmp    80105d17 <alltraps>

801069bf <vector194>:
.globl vector194
vector194:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $194
801069c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801069c6:	e9 4c f3 ff ff       	jmp    80105d17 <alltraps>

801069cb <vector195>:
.globl vector195
vector195:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $195
801069cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069d2:	e9 40 f3 ff ff       	jmp    80105d17 <alltraps>

801069d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $196
801069d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069de:	e9 34 f3 ff ff       	jmp    80105d17 <alltraps>

801069e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $197
801069e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069ea:	e9 28 f3 ff ff       	jmp    80105d17 <alltraps>

801069ef <vector198>:
.globl vector198
vector198:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $198
801069f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069f6:	e9 1c f3 ff ff       	jmp    80105d17 <alltraps>

801069fb <vector199>:
.globl vector199
vector199:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $199
801069fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a02:	e9 10 f3 ff ff       	jmp    80105d17 <alltraps>

80106a07 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $200
80106a09:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a0e:	e9 04 f3 ff ff       	jmp    80105d17 <alltraps>

80106a13 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $201
80106a15:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a1a:	e9 f8 f2 ff ff       	jmp    80105d17 <alltraps>

80106a1f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $202
80106a21:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a26:	e9 ec f2 ff ff       	jmp    80105d17 <alltraps>

80106a2b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $203
80106a2d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a32:	e9 e0 f2 ff ff       	jmp    80105d17 <alltraps>

80106a37 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $204
80106a39:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a3e:	e9 d4 f2 ff ff       	jmp    80105d17 <alltraps>

80106a43 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $205
80106a45:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a4a:	e9 c8 f2 ff ff       	jmp    80105d17 <alltraps>

80106a4f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $206
80106a51:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a56:	e9 bc f2 ff ff       	jmp    80105d17 <alltraps>

80106a5b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $207
80106a5d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a62:	e9 b0 f2 ff ff       	jmp    80105d17 <alltraps>

80106a67 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $208
80106a69:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a6e:	e9 a4 f2 ff ff       	jmp    80105d17 <alltraps>

80106a73 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $209
80106a75:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a7a:	e9 98 f2 ff ff       	jmp    80105d17 <alltraps>

80106a7f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $210
80106a81:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a86:	e9 8c f2 ff ff       	jmp    80105d17 <alltraps>

80106a8b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $211
80106a8d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a92:	e9 80 f2 ff ff       	jmp    80105d17 <alltraps>

80106a97 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $212
80106a99:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a9e:	e9 74 f2 ff ff       	jmp    80105d17 <alltraps>

80106aa3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $213
80106aa5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106aaa:	e9 68 f2 ff ff       	jmp    80105d17 <alltraps>

80106aaf <vector214>:
.globl vector214
vector214:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $214
80106ab1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ab6:	e9 5c f2 ff ff       	jmp    80105d17 <alltraps>

80106abb <vector215>:
.globl vector215
vector215:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $215
80106abd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ac2:	e9 50 f2 ff ff       	jmp    80105d17 <alltraps>

80106ac7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $216
80106ac9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ace:	e9 44 f2 ff ff       	jmp    80105d17 <alltraps>

80106ad3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $217
80106ad5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106ada:	e9 38 f2 ff ff       	jmp    80105d17 <alltraps>

80106adf <vector218>:
.globl vector218
vector218:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $218
80106ae1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ae6:	e9 2c f2 ff ff       	jmp    80105d17 <alltraps>

80106aeb <vector219>:
.globl vector219
vector219:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $219
80106aed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106af2:	e9 20 f2 ff ff       	jmp    80105d17 <alltraps>

80106af7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $220
80106af9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106afe:	e9 14 f2 ff ff       	jmp    80105d17 <alltraps>

80106b03 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $221
80106b05:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b0a:	e9 08 f2 ff ff       	jmp    80105d17 <alltraps>

80106b0f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $222
80106b11:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b16:	e9 fc f1 ff ff       	jmp    80105d17 <alltraps>

80106b1b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $223
80106b1d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b22:	e9 f0 f1 ff ff       	jmp    80105d17 <alltraps>

80106b27 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $224
80106b29:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b2e:	e9 e4 f1 ff ff       	jmp    80105d17 <alltraps>

80106b33 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $225
80106b35:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b3a:	e9 d8 f1 ff ff       	jmp    80105d17 <alltraps>

80106b3f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $226
80106b41:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b46:	e9 cc f1 ff ff       	jmp    80105d17 <alltraps>

80106b4b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $227
80106b4d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b52:	e9 c0 f1 ff ff       	jmp    80105d17 <alltraps>

80106b57 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $228
80106b59:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b5e:	e9 b4 f1 ff ff       	jmp    80105d17 <alltraps>

80106b63 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $229
80106b65:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b6a:	e9 a8 f1 ff ff       	jmp    80105d17 <alltraps>

80106b6f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $230
80106b71:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b76:	e9 9c f1 ff ff       	jmp    80105d17 <alltraps>

80106b7b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $231
80106b7d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b82:	e9 90 f1 ff ff       	jmp    80105d17 <alltraps>

80106b87 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $232
80106b89:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b8e:	e9 84 f1 ff ff       	jmp    80105d17 <alltraps>

80106b93 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $233
80106b95:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b9a:	e9 78 f1 ff ff       	jmp    80105d17 <alltraps>

80106b9f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $234
80106ba1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ba6:	e9 6c f1 ff ff       	jmp    80105d17 <alltraps>

80106bab <vector235>:
.globl vector235
vector235:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $235
80106bad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106bb2:	e9 60 f1 ff ff       	jmp    80105d17 <alltraps>

80106bb7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $236
80106bb9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106bbe:	e9 54 f1 ff ff       	jmp    80105d17 <alltraps>

80106bc3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $237
80106bc5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106bca:	e9 48 f1 ff ff       	jmp    80105d17 <alltraps>

80106bcf <vector238>:
.globl vector238
vector238:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $238
80106bd1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106bd6:	e9 3c f1 ff ff       	jmp    80105d17 <alltraps>

80106bdb <vector239>:
.globl vector239
vector239:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $239
80106bdd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106be2:	e9 30 f1 ff ff       	jmp    80105d17 <alltraps>

80106be7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $240
80106be9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bee:	e9 24 f1 ff ff       	jmp    80105d17 <alltraps>

80106bf3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $241
80106bf5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106bfa:	e9 18 f1 ff ff       	jmp    80105d17 <alltraps>

80106bff <vector242>:
.globl vector242
vector242:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $242
80106c01:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c06:	e9 0c f1 ff ff       	jmp    80105d17 <alltraps>

80106c0b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $243
80106c0d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c12:	e9 00 f1 ff ff       	jmp    80105d17 <alltraps>

80106c17 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $244
80106c19:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c1e:	e9 f4 f0 ff ff       	jmp    80105d17 <alltraps>

80106c23 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $245
80106c25:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c2a:	e9 e8 f0 ff ff       	jmp    80105d17 <alltraps>

80106c2f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $246
80106c31:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c36:	e9 dc f0 ff ff       	jmp    80105d17 <alltraps>

80106c3b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $247
80106c3d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c42:	e9 d0 f0 ff ff       	jmp    80105d17 <alltraps>

80106c47 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $248
80106c49:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c4e:	e9 c4 f0 ff ff       	jmp    80105d17 <alltraps>

80106c53 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $249
80106c55:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c5a:	e9 b8 f0 ff ff       	jmp    80105d17 <alltraps>

80106c5f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $250
80106c61:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c66:	e9 ac f0 ff ff       	jmp    80105d17 <alltraps>

80106c6b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $251
80106c6d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c72:	e9 a0 f0 ff ff       	jmp    80105d17 <alltraps>

80106c77 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $252
80106c79:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c7e:	e9 94 f0 ff ff       	jmp    80105d17 <alltraps>

80106c83 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $253
80106c85:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c8a:	e9 88 f0 ff ff       	jmp    80105d17 <alltraps>

80106c8f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $254
80106c91:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c96:	e9 7c f0 ff ff       	jmp    80105d17 <alltraps>

80106c9b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $255
80106c9d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ca2:	e9 70 f0 ff ff       	jmp    80105d17 <alltraps>
80106ca7:	66 90                	xchg   %ax,%ax
80106ca9:	66 90                	xchg   %ax,%ax
80106cab:	66 90                	xchg   %ax,%ax
80106cad:	66 90                	xchg   %ax,%ax
80106caf:	90                   	nop

80106cb0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cb0:	55                   	push   %ebp
80106cb1:	89 e5                	mov    %esp,%ebp
80106cb3:	57                   	push   %edi
80106cb4:	56                   	push   %esi
80106cb5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106cb6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106cbc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cc2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106cc5:	39 d3                	cmp    %edx,%ebx
80106cc7:	73 56                	jae    80106d1f <deallocuvm.part.0+0x6f>
80106cc9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106ccc:	89 c6                	mov    %eax,%esi
80106cce:	89 d7                	mov    %edx,%edi
80106cd0:	eb 12                	jmp    80106ce4 <deallocuvm.part.0+0x34>
80106cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106cd8:	83 c2 01             	add    $0x1,%edx
80106cdb:	89 d3                	mov    %edx,%ebx
80106cdd:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106ce0:	39 fb                	cmp    %edi,%ebx
80106ce2:	73 38                	jae    80106d1c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106ce4:	89 da                	mov    %ebx,%edx
80106ce6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106ce9:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106cec:	a8 01                	test   $0x1,%al
80106cee:	74 e8                	je     80106cd8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106cf0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cf2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106cf7:	c1 e9 0a             	shr    $0xa,%ecx
80106cfa:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106d00:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106d07:	85 c0                	test   %eax,%eax
80106d09:	74 cd                	je     80106cd8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106d0b:	8b 10                	mov    (%eax),%edx
80106d0d:	f6 c2 01             	test   $0x1,%dl
80106d10:	75 1e                	jne    80106d30 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106d12:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d18:	39 fb                	cmp    %edi,%ebx
80106d1a:	72 c8                	jb     80106ce4 <deallocuvm.part.0+0x34>
80106d1c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d22:	89 c8                	mov    %ecx,%eax
80106d24:	5b                   	pop    %ebx
80106d25:	5e                   	pop    %esi
80106d26:	5f                   	pop    %edi
80106d27:	5d                   	pop    %ebp
80106d28:	c3                   	ret
80106d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106d30:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106d36:	74 26                	je     80106d5e <deallocuvm.part.0+0xae>
      kfree(v);
80106d38:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d3b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106d41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d44:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106d4a:	52                   	push   %edx
80106d4b:	e8 50 b7 ff ff       	call   801024a0 <kfree>
      *pte = 0;
80106d50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106d53:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106d56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106d5c:	eb 82                	jmp    80106ce0 <deallocuvm.part.0+0x30>
        panic("kfree");
80106d5e:	83 ec 0c             	sub    $0xc,%esp
80106d61:	68 4c 78 10 80       	push   $0x8010784c
80106d66:	e8 15 96 ff ff       	call   80100380 <panic>
80106d6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106d70 <mappages>:
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106d76:	89 d3                	mov    %edx,%ebx
80106d78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d7e:	83 ec 1c             	sub    $0x1c,%esp
80106d81:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d84:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d90:	8b 45 08             	mov    0x8(%ebp),%eax
80106d93:	29 d8                	sub    %ebx,%eax
80106d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d98:	eb 3f                	jmp    80106dd9 <mappages+0x69>
80106d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106da0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106da2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106da7:	c1 ea 0a             	shr    $0xa,%edx
80106daa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106db0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106db7:	85 c0                	test   %eax,%eax
80106db9:	74 75                	je     80106e30 <mappages+0xc0>
    if(*pte & PTE_P)
80106dbb:	f6 00 01             	testb  $0x1,(%eax)
80106dbe:	0f 85 86 00 00 00    	jne    80106e4a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106dc4:	0b 75 0c             	or     0xc(%ebp),%esi
80106dc7:	83 ce 01             	or     $0x1,%esi
80106dca:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106dcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106dcf:	39 c3                	cmp    %eax,%ebx
80106dd1:	74 6d                	je     80106e40 <mappages+0xd0>
    a += PGSIZE;
80106dd3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106ddc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106ddf:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106de2:	89 d8                	mov    %ebx,%eax
80106de4:	c1 e8 16             	shr    $0x16,%eax
80106de7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106dea:	8b 07                	mov    (%edi),%eax
80106dec:	a8 01                	test   $0x1,%al
80106dee:	75 b0                	jne    80106da0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106df0:	e8 6b b8 ff ff       	call   80102660 <kalloc>
80106df5:	85 c0                	test   %eax,%eax
80106df7:	74 37                	je     80106e30 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106df9:	83 ec 04             	sub    $0x4,%esp
80106dfc:	68 00 10 00 00       	push   $0x1000
80106e01:	6a 00                	push   $0x0
80106e03:	50                   	push   %eax
80106e04:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106e07:	e8 44 dc ff ff       	call   80104a50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e0c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106e0f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e12:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106e18:	83 c8 07             	or     $0x7,%eax
80106e1b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106e1d:	89 d8                	mov    %ebx,%eax
80106e1f:	c1 e8 0a             	shr    $0xa,%eax
80106e22:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e27:	01 d0                	add    %edx,%eax
80106e29:	eb 90                	jmp    80106dbb <mappages+0x4b>
80106e2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e38:	5b                   	pop    %ebx
80106e39:	5e                   	pop    %esi
80106e3a:	5f                   	pop    %edi
80106e3b:	5d                   	pop    %ebp
80106e3c:	c3                   	ret
80106e3d:	8d 76 00             	lea    0x0(%esi),%esi
80106e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e43:	31 c0                	xor    %eax,%eax
}
80106e45:	5b                   	pop    %ebx
80106e46:	5e                   	pop    %esi
80106e47:	5f                   	pop    %edi
80106e48:	5d                   	pop    %ebp
80106e49:	c3                   	ret
      panic("remap");
80106e4a:	83 ec 0c             	sub    $0xc,%esp
80106e4d:	68 8f 7a 10 80       	push   $0x80107a8f
80106e52:	e8 29 95 ff ff       	call   80100380 <panic>
80106e57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e5e:	00 
80106e5f:	90                   	nop

80106e60 <seginit>:
{
80106e60:	55                   	push   %ebp
80106e61:	89 e5                	mov    %esp,%ebp
80106e63:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e66:	e8 15 cb ff ff       	call   80103980 <cpuid>
  pd[0] = size-1;
80106e6b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e70:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e76:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106e7a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106e81:	ff 00 00 
80106e84:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106e8b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e8e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106e95:	ff 00 00 
80106e98:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106e9f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ea2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106ea9:	ff 00 00 
80106eac:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106eb3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106eb6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106ebd:	ff 00 00 
80106ec0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106ec7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106eca:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106ecf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ed3:	c1 e8 10             	shr    $0x10,%eax
80106ed6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106eda:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106edd:	0f 01 10             	lgdtl  (%eax)
}
80106ee0:	c9                   	leave
80106ee1:	c3                   	ret
80106ee2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ee9:	00 
80106eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ef0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ef0:	a1 c4 5c 11 80       	mov    0x80115cc4,%eax
80106ef5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106efa:	0f 22 d8             	mov    %eax,%cr3
}
80106efd:	c3                   	ret
80106efe:	66 90                	xchg   %ax,%ax

80106f00 <switchuvm>:
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 1c             	sub    $0x1c,%esp
80106f09:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f0c:	85 f6                	test   %esi,%esi
80106f0e:	0f 84 cb 00 00 00    	je     80106fdf <switchuvm+0xdf>
  if(p->kstack == 0)
80106f14:	8b 46 08             	mov    0x8(%esi),%eax
80106f17:	85 c0                	test   %eax,%eax
80106f19:	0f 84 da 00 00 00    	je     80106ff9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f1f:	8b 46 04             	mov    0x4(%esi),%eax
80106f22:	85 c0                	test   %eax,%eax
80106f24:	0f 84 c2 00 00 00    	je     80106fec <switchuvm+0xec>
  pushcli();
80106f2a:	e8 d1 d8 ff ff       	call   80104800 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f2f:	e8 ec c9 ff ff       	call   80103920 <mycpu>
80106f34:	89 c3                	mov    %eax,%ebx
80106f36:	e8 e5 c9 ff ff       	call   80103920 <mycpu>
80106f3b:	89 c7                	mov    %eax,%edi
80106f3d:	e8 de c9 ff ff       	call   80103920 <mycpu>
80106f42:	83 c7 08             	add    $0x8,%edi
80106f45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f48:	e8 d3 c9 ff ff       	call   80103920 <mycpu>
80106f4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f50:	ba 67 00 00 00       	mov    $0x67,%edx
80106f55:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f5c:	83 c0 08             	add    $0x8,%eax
80106f5f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f66:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f6b:	83 c1 08             	add    $0x8,%ecx
80106f6e:	c1 e8 18             	shr    $0x18,%eax
80106f71:	c1 e9 10             	shr    $0x10,%ecx
80106f74:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f7a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f80:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f85:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f8c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f91:	e8 8a c9 ff ff       	call   80103920 <mycpu>
80106f96:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f9d:	e8 7e c9 ff ff       	call   80103920 <mycpu>
80106fa2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106fa6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106fa9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106faf:	e8 6c c9 ff ff       	call   80103920 <mycpu>
80106fb4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fb7:	e8 64 c9 ff ff       	call   80103920 <mycpu>
80106fbc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106fc0:	b8 28 00 00 00       	mov    $0x28,%eax
80106fc5:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106fc8:	8b 46 04             	mov    0x4(%esi),%eax
80106fcb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fd0:	0f 22 d8             	mov    %eax,%cr3
}
80106fd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fd6:	5b                   	pop    %ebx
80106fd7:	5e                   	pop    %esi
80106fd8:	5f                   	pop    %edi
80106fd9:	5d                   	pop    %ebp
  popcli();
80106fda:	e9 71 d8 ff ff       	jmp    80104850 <popcli>
    panic("switchuvm: no process");
80106fdf:	83 ec 0c             	sub    $0xc,%esp
80106fe2:	68 95 7a 10 80       	push   $0x80107a95
80106fe7:	e8 94 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106fec:	83 ec 0c             	sub    $0xc,%esp
80106fef:	68 c0 7a 10 80       	push   $0x80107ac0
80106ff4:	e8 87 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106ff9:	83 ec 0c             	sub    $0xc,%esp
80106ffc:	68 ab 7a 10 80       	push   $0x80107aab
80107001:	e8 7a 93 ff ff       	call   80100380 <panic>
80107006:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010700d:	00 
8010700e:	66 90                	xchg   %ax,%ax

80107010 <inituvm>:
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 1c             	sub    $0x1c,%esp
80107019:	8b 45 08             	mov    0x8(%ebp),%eax
8010701c:	8b 75 10             	mov    0x10(%ebp),%esi
8010701f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107022:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107025:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010702b:	77 49                	ja     80107076 <inituvm+0x66>
  mem = kalloc();
8010702d:	e8 2e b6 ff ff       	call   80102660 <kalloc>
  memset(mem, 0, PGSIZE);
80107032:	83 ec 04             	sub    $0x4,%esp
80107035:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010703a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010703c:	6a 00                	push   $0x0
8010703e:	50                   	push   %eax
8010703f:	e8 0c da ff ff       	call   80104a50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107044:	58                   	pop    %eax
80107045:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010704b:	5a                   	pop    %edx
8010704c:	6a 06                	push   $0x6
8010704e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107053:	31 d2                	xor    %edx,%edx
80107055:	50                   	push   %eax
80107056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107059:	e8 12 fd ff ff       	call   80106d70 <mappages>
  memmove(mem, init, sz);
8010705e:	83 c4 10             	add    $0x10,%esp
80107061:	89 75 10             	mov    %esi,0x10(%ebp)
80107064:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107067:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010706a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010706d:	5b                   	pop    %ebx
8010706e:	5e                   	pop    %esi
8010706f:	5f                   	pop    %edi
80107070:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107071:	e9 6a da ff ff       	jmp    80104ae0 <memmove>
    panic("inituvm: more than a page");
80107076:	83 ec 0c             	sub    $0xc,%esp
80107079:	68 d4 7a 10 80       	push   $0x80107ad4
8010707e:	e8 fd 92 ff ff       	call   80100380 <panic>
80107083:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010708a:	00 
8010708b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107090 <loaduvm>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	57                   	push   %edi
80107094:	56                   	push   %esi
80107095:	53                   	push   %ebx
80107096:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107099:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010709c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010709f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
801070a5:	0f 85 a2 00 00 00    	jne    8010714d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
801070ab:	85 ff                	test   %edi,%edi
801070ad:	74 7d                	je     8010712c <loaduvm+0x9c>
801070af:	90                   	nop
  pde = &pgdir[PDX(va)];
801070b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801070b3:	8b 55 08             	mov    0x8(%ebp),%edx
801070b6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
801070b8:	89 c1                	mov    %eax,%ecx
801070ba:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801070bd:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
801070c0:	f6 c1 01             	test   $0x1,%cl
801070c3:	75 13                	jne    801070d8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
801070c5:	83 ec 0c             	sub    $0xc,%esp
801070c8:	68 ee 7a 10 80       	push   $0x80107aee
801070cd:	e8 ae 92 ff ff       	call   80100380 <panic>
801070d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070d8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070db:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801070e1:	25 fc 0f 00 00       	and    $0xffc,%eax
801070e6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070ed:	85 c9                	test   %ecx,%ecx
801070ef:	74 d4                	je     801070c5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801070f1:	89 fb                	mov    %edi,%ebx
801070f3:	b8 00 10 00 00       	mov    $0x1000,%eax
801070f8:	29 f3                	sub    %esi,%ebx
801070fa:	39 c3                	cmp    %eax,%ebx
801070fc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070ff:	53                   	push   %ebx
80107100:	8b 45 14             	mov    0x14(%ebp),%eax
80107103:	01 f0                	add    %esi,%eax
80107105:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80107106:	8b 01                	mov    (%ecx),%eax
80107108:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010710d:	05 00 00 00 80       	add    $0x80000000,%eax
80107112:	50                   	push   %eax
80107113:	ff 75 10             	push   0x10(%ebp)
80107116:	e8 95 a9 ff ff       	call   80101ab0 <readi>
8010711b:	83 c4 10             	add    $0x10,%esp
8010711e:	39 d8                	cmp    %ebx,%eax
80107120:	75 1e                	jne    80107140 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80107122:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107128:	39 fe                	cmp    %edi,%esi
8010712a:	72 84                	jb     801070b0 <loaduvm+0x20>
}
8010712c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010712f:	31 c0                	xor    %eax,%eax
}
80107131:	5b                   	pop    %ebx
80107132:	5e                   	pop    %esi
80107133:	5f                   	pop    %edi
80107134:	5d                   	pop    %ebp
80107135:	c3                   	ret
80107136:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010713d:	00 
8010713e:	66 90                	xchg   %ax,%ax
80107140:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107143:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107148:	5b                   	pop    %ebx
80107149:	5e                   	pop    %esi
8010714a:	5f                   	pop    %edi
8010714b:	5d                   	pop    %ebp
8010714c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010714d:	83 ec 0c             	sub    $0xc,%esp
80107150:	68 3c 7d 10 80       	push   $0x80107d3c
80107155:	e8 26 92 ff ff       	call   80100380 <panic>
8010715a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107160 <allocuvm>:
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	57                   	push   %edi
80107164:	56                   	push   %esi
80107165:	53                   	push   %ebx
80107166:	83 ec 1c             	sub    $0x1c,%esp
80107169:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010716c:	85 f6                	test   %esi,%esi
8010716e:	0f 88 98 00 00 00    	js     8010720c <allocuvm+0xac>
80107174:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107176:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107179:	0f 82 a1 00 00 00    	jb     80107220 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010717f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107182:	05 ff 0f 00 00       	add    $0xfff,%eax
80107187:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010718c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010718e:	39 f0                	cmp    %esi,%eax
80107190:	0f 83 8d 00 00 00    	jae    80107223 <allocuvm+0xc3>
80107196:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107199:	eb 44                	jmp    801071df <allocuvm+0x7f>
8010719b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801071a0:	83 ec 04             	sub    $0x4,%esp
801071a3:	68 00 10 00 00       	push   $0x1000
801071a8:	6a 00                	push   $0x0
801071aa:	50                   	push   %eax
801071ab:	e8 a0 d8 ff ff       	call   80104a50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801071b0:	58                   	pop    %eax
801071b1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071b7:	5a                   	pop    %edx
801071b8:	6a 06                	push   $0x6
801071ba:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071bf:	89 fa                	mov    %edi,%edx
801071c1:	50                   	push   %eax
801071c2:	8b 45 08             	mov    0x8(%ebp),%eax
801071c5:	e8 a6 fb ff ff       	call   80106d70 <mappages>
801071ca:	83 c4 10             	add    $0x10,%esp
801071cd:	85 c0                	test   %eax,%eax
801071cf:	78 5f                	js     80107230 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
801071d1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801071d7:	39 f7                	cmp    %esi,%edi
801071d9:	0f 83 89 00 00 00    	jae    80107268 <allocuvm+0x108>
    mem = kalloc();
801071df:	e8 7c b4 ff ff       	call   80102660 <kalloc>
801071e4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801071e6:	85 c0                	test   %eax,%eax
801071e8:	75 b6                	jne    801071a0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071ea:	83 ec 0c             	sub    $0xc,%esp
801071ed:	68 0c 7b 10 80       	push   $0x80107b0c
801071f2:	e8 b9 94 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801071f7:	83 c4 10             	add    $0x10,%esp
801071fa:	3b 75 0c             	cmp    0xc(%ebp),%esi
801071fd:	74 0d                	je     8010720c <allocuvm+0xac>
801071ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107202:	8b 45 08             	mov    0x8(%ebp),%eax
80107205:	89 f2                	mov    %esi,%edx
80107207:	e8 a4 fa ff ff       	call   80106cb0 <deallocuvm.part.0>
    return 0;
8010720c:	31 d2                	xor    %edx,%edx
}
8010720e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107211:	89 d0                	mov    %edx,%eax
80107213:	5b                   	pop    %ebx
80107214:	5e                   	pop    %esi
80107215:	5f                   	pop    %edi
80107216:	5d                   	pop    %ebp
80107217:	c3                   	ret
80107218:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010721f:	00 
    return oldsz;
80107220:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80107223:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107226:	89 d0                	mov    %edx,%eax
80107228:	5b                   	pop    %ebx
80107229:	5e                   	pop    %esi
8010722a:	5f                   	pop    %edi
8010722b:	5d                   	pop    %ebp
8010722c:	c3                   	ret
8010722d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107230:	83 ec 0c             	sub    $0xc,%esp
80107233:	68 24 7b 10 80       	push   $0x80107b24
80107238:	e8 73 94 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
8010723d:	83 c4 10             	add    $0x10,%esp
80107240:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107243:	74 0d                	je     80107252 <allocuvm+0xf2>
80107245:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107248:	8b 45 08             	mov    0x8(%ebp),%eax
8010724b:	89 f2                	mov    %esi,%edx
8010724d:	e8 5e fa ff ff       	call   80106cb0 <deallocuvm.part.0>
      kfree(mem);
80107252:	83 ec 0c             	sub    $0xc,%esp
80107255:	53                   	push   %ebx
80107256:	e8 45 b2 ff ff       	call   801024a0 <kfree>
      return 0;
8010725b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010725e:	31 d2                	xor    %edx,%edx
80107260:	eb ac                	jmp    8010720e <allocuvm+0xae>
80107262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107268:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010726b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010726e:	5b                   	pop    %ebx
8010726f:	5e                   	pop    %esi
80107270:	89 d0                	mov    %edx,%eax
80107272:	5f                   	pop    %edi
80107273:	5d                   	pop    %ebp
80107274:	c3                   	ret
80107275:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010727c:	00 
8010727d:	8d 76 00             	lea    0x0(%esi),%esi

80107280 <deallocuvm>:
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	8b 55 0c             	mov    0xc(%ebp),%edx
80107286:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107289:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010728c:	39 d1                	cmp    %edx,%ecx
8010728e:	73 10                	jae    801072a0 <deallocuvm+0x20>
}
80107290:	5d                   	pop    %ebp
80107291:	e9 1a fa ff ff       	jmp    80106cb0 <deallocuvm.part.0>
80107296:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010729d:	00 
8010729e:	66 90                	xchg   %ax,%ax
801072a0:	89 d0                	mov    %edx,%eax
801072a2:	5d                   	pop    %ebp
801072a3:	c3                   	ret
801072a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072ab:	00 
801072ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	56                   	push   %esi
801072b5:	53                   	push   %ebx
801072b6:	83 ec 0c             	sub    $0xc,%esp
801072b9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801072bc:	85 f6                	test   %esi,%esi
801072be:	74 59                	je     80107319 <freevm+0x69>
  if(newsz >= oldsz)
801072c0:	31 c9                	xor    %ecx,%ecx
801072c2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072c7:	89 f0                	mov    %esi,%eax
801072c9:	89 f3                	mov    %esi,%ebx
801072cb:	e8 e0 f9 ff ff       	call   80106cb0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072d0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072d6:	eb 0f                	jmp    801072e7 <freevm+0x37>
801072d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072df:	00 
801072e0:	83 c3 04             	add    $0x4,%ebx
801072e3:	39 fb                	cmp    %edi,%ebx
801072e5:	74 23                	je     8010730a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072e7:	8b 03                	mov    (%ebx),%eax
801072e9:	a8 01                	test   $0x1,%al
801072eb:	74 f3                	je     801072e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072f2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072fd:	50                   	push   %eax
801072fe:	e8 9d b1 ff ff       	call   801024a0 <kfree>
80107303:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107306:	39 fb                	cmp    %edi,%ebx
80107308:	75 dd                	jne    801072e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010730a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010730d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107310:	5b                   	pop    %ebx
80107311:	5e                   	pop    %esi
80107312:	5f                   	pop    %edi
80107313:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107314:	e9 87 b1 ff ff       	jmp    801024a0 <kfree>
    panic("freevm: no pgdir");
80107319:	83 ec 0c             	sub    $0xc,%esp
8010731c:	68 40 7b 10 80       	push   $0x80107b40
80107321:	e8 5a 90 ff ff       	call   80100380 <panic>
80107326:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010732d:	00 
8010732e:	66 90                	xchg   %ax,%ax

80107330 <setupkvm>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	56                   	push   %esi
80107334:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107335:	e8 26 b3 ff ff       	call   80102660 <kalloc>
8010733a:	85 c0                	test   %eax,%eax
8010733c:	74 5e                	je     8010739c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010733e:	83 ec 04             	sub    $0x4,%esp
80107341:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107343:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107348:	68 00 10 00 00       	push   $0x1000
8010734d:	6a 00                	push   $0x0
8010734f:	50                   	push   %eax
80107350:	e8 fb d6 ff ff       	call   80104a50 <memset>
80107355:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107358:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010735b:	83 ec 08             	sub    $0x8,%esp
8010735e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107361:	8b 13                	mov    (%ebx),%edx
80107363:	ff 73 0c             	push   0xc(%ebx)
80107366:	50                   	push   %eax
80107367:	29 c1                	sub    %eax,%ecx
80107369:	89 f0                	mov    %esi,%eax
8010736b:	e8 00 fa ff ff       	call   80106d70 <mappages>
80107370:	83 c4 10             	add    $0x10,%esp
80107373:	85 c0                	test   %eax,%eax
80107375:	78 19                	js     80107390 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107377:	83 c3 10             	add    $0x10,%ebx
8010737a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107380:	75 d6                	jne    80107358 <setupkvm+0x28>
}
80107382:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107385:	89 f0                	mov    %esi,%eax
80107387:	5b                   	pop    %ebx
80107388:	5e                   	pop    %esi
80107389:	5d                   	pop    %ebp
8010738a:	c3                   	ret
8010738b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107390:	83 ec 0c             	sub    $0xc,%esp
80107393:	56                   	push   %esi
80107394:	e8 17 ff ff ff       	call   801072b0 <freevm>
      return 0;
80107399:	83 c4 10             	add    $0x10,%esp
}
8010739c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010739f:	31 f6                	xor    %esi,%esi
}
801073a1:	89 f0                	mov    %esi,%eax
801073a3:	5b                   	pop    %ebx
801073a4:	5e                   	pop    %esi
801073a5:	5d                   	pop    %ebp
801073a6:	c3                   	ret
801073a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073ae:	00 
801073af:	90                   	nop

801073b0 <kvmalloc>:
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801073b6:	e8 75 ff ff ff       	call   80107330 <setupkvm>
801073bb:	a3 c4 5c 11 80       	mov    %eax,0x80115cc4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073c0:	05 00 00 00 80       	add    $0x80000000,%eax
801073c5:	0f 22 d8             	mov    %eax,%cr3
}
801073c8:	c9                   	leave
801073c9:	c3                   	ret
801073ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	83 ec 08             	sub    $0x8,%esp
801073d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073d9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073dc:	89 c1                	mov    %eax,%ecx
801073de:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073e1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073e4:	f6 c2 01             	test   $0x1,%dl
801073e7:	75 17                	jne    80107400 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801073e9:	83 ec 0c             	sub    $0xc,%esp
801073ec:	68 51 7b 10 80       	push   $0x80107b51
801073f1:	e8 8a 8f ff ff       	call   80100380 <panic>
801073f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073fd:	00 
801073fe:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107400:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107403:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107409:	25 fc 0f 00 00       	and    $0xffc,%eax
8010740e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107415:	85 c0                	test   %eax,%eax
80107417:	74 d0                	je     801073e9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107419:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010741c:	c9                   	leave
8010741d:	c3                   	ret
8010741e:	66 90                	xchg   %ax,%ax

80107420 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
80107426:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107429:	e8 02 ff ff ff       	call   80107330 <setupkvm>
8010742e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107431:	85 c0                	test   %eax,%eax
80107433:	0f 84 e9 00 00 00    	je     80107522 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107439:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010743c:	85 c9                	test   %ecx,%ecx
8010743e:	0f 84 b2 00 00 00    	je     801074f6 <copyuvm+0xd6>
80107444:	31 f6                	xor    %esi,%esi
80107446:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010744d:	00 
8010744e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107450:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107453:	89 f0                	mov    %esi,%eax
80107455:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107458:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010745b:	a8 01                	test   $0x1,%al
8010745d:	75 11                	jne    80107470 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010745f:	83 ec 0c             	sub    $0xc,%esp
80107462:	68 5b 7b 10 80       	push   $0x80107b5b
80107467:	e8 14 8f ff ff       	call   80100380 <panic>
8010746c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107470:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107472:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107477:	c1 ea 0a             	shr    $0xa,%edx
8010747a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107480:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107487:	85 c0                	test   %eax,%eax
80107489:	74 d4                	je     8010745f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010748b:	8b 00                	mov    (%eax),%eax
8010748d:	a8 01                	test   $0x1,%al
8010748f:	0f 84 9f 00 00 00    	je     80107534 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107495:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107497:	25 ff 0f 00 00       	and    $0xfff,%eax
8010749c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010749f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801074a5:	e8 b6 b1 ff ff       	call   80102660 <kalloc>
801074aa:	89 c3                	mov    %eax,%ebx
801074ac:	85 c0                	test   %eax,%eax
801074ae:	74 64                	je     80107514 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801074b0:	83 ec 04             	sub    $0x4,%esp
801074b3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801074b9:	68 00 10 00 00       	push   $0x1000
801074be:	57                   	push   %edi
801074bf:	50                   	push   %eax
801074c0:	e8 1b d6 ff ff       	call   80104ae0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801074c5:	58                   	pop    %eax
801074c6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074cc:	5a                   	pop    %edx
801074cd:	ff 75 e4             	push   -0x1c(%ebp)
801074d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074d5:	89 f2                	mov    %esi,%edx
801074d7:	50                   	push   %eax
801074d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074db:	e8 90 f8 ff ff       	call   80106d70 <mappages>
801074e0:	83 c4 10             	add    $0x10,%esp
801074e3:	85 c0                	test   %eax,%eax
801074e5:	78 21                	js     80107508 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801074e7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074ed:	3b 75 0c             	cmp    0xc(%ebp),%esi
801074f0:	0f 82 5a ff ff ff    	jb     80107450 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801074f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074fc:	5b                   	pop    %ebx
801074fd:	5e                   	pop    %esi
801074fe:	5f                   	pop    %edi
801074ff:	5d                   	pop    %ebp
80107500:	c3                   	ret
80107501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107508:	83 ec 0c             	sub    $0xc,%esp
8010750b:	53                   	push   %ebx
8010750c:	e8 8f af ff ff       	call   801024a0 <kfree>
      goto bad;
80107511:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107514:	83 ec 0c             	sub    $0xc,%esp
80107517:	ff 75 e0             	push   -0x20(%ebp)
8010751a:	e8 91 fd ff ff       	call   801072b0 <freevm>
  return 0;
8010751f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107522:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107529:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010752c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010752f:	5b                   	pop    %ebx
80107530:	5e                   	pop    %esi
80107531:	5f                   	pop    %edi
80107532:	5d                   	pop    %ebp
80107533:	c3                   	ret
      panic("copyuvm: page not present");
80107534:	83 ec 0c             	sub    $0xc,%esp
80107537:	68 75 7b 10 80       	push   $0x80107b75
8010753c:	e8 3f 8e ff ff       	call   80100380 <panic>
80107541:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107548:	00 
80107549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107550 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107556:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107559:	89 c1                	mov    %eax,%ecx
8010755b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010755e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107561:	f6 c2 01             	test   $0x1,%dl
80107564:	0f 84 f8 00 00 00    	je     80107662 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010756a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010756d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107573:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107574:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107579:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107580:	89 d0                	mov    %edx,%eax
80107582:	f7 d2                	not    %edx
80107584:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107589:	05 00 00 00 80       	add    $0x80000000,%eax
8010758e:	83 e2 05             	and    $0x5,%edx
80107591:	ba 00 00 00 00       	mov    $0x0,%edx
80107596:	0f 45 c2             	cmovne %edx,%eax
}
80107599:	c3                   	ret
8010759a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	53                   	push   %ebx
801075a6:	83 ec 0c             	sub    $0xc,%esp
801075a9:	8b 75 14             	mov    0x14(%ebp),%esi
801075ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801075af:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801075b2:	85 f6                	test   %esi,%esi
801075b4:	75 51                	jne    80107607 <copyout+0x67>
801075b6:	e9 9d 00 00 00       	jmp    80107658 <copyout+0xb8>
801075bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
801075c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801075c6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801075cc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801075d2:	74 74                	je     80107648 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
801075d4:	89 fb                	mov    %edi,%ebx
801075d6:	29 c3                	sub    %eax,%ebx
801075d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801075de:	39 f3                	cmp    %esi,%ebx
801075e0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801075e3:	29 f8                	sub    %edi,%eax
801075e5:	83 ec 04             	sub    $0x4,%esp
801075e8:	01 c1                	add    %eax,%ecx
801075ea:	53                   	push   %ebx
801075eb:	52                   	push   %edx
801075ec:	89 55 10             	mov    %edx,0x10(%ebp)
801075ef:	51                   	push   %ecx
801075f0:	e8 eb d4 ff ff       	call   80104ae0 <memmove>
    len -= n;
    buf += n;
801075f5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801075f8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801075fe:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107601:	01 da                	add    %ebx,%edx
  while(len > 0){
80107603:	29 de                	sub    %ebx,%esi
80107605:	74 51                	je     80107658 <copyout+0xb8>
  if(*pde & PTE_P){
80107607:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010760a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010760c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010760e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107611:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107617:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010761a:	f6 c1 01             	test   $0x1,%cl
8010761d:	0f 84 46 00 00 00    	je     80107669 <copyout.cold>
  return &pgtab[PTX(va)];
80107623:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107625:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010762b:	c1 eb 0c             	shr    $0xc,%ebx
8010762e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107634:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010763b:	89 d9                	mov    %ebx,%ecx
8010763d:	f7 d1                	not    %ecx
8010763f:	83 e1 05             	and    $0x5,%ecx
80107642:	0f 84 78 ff ff ff    	je     801075c0 <copyout+0x20>
  }
  return 0;
}
80107648:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010764b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107650:	5b                   	pop    %ebx
80107651:	5e                   	pop    %esi
80107652:	5f                   	pop    %edi
80107653:	5d                   	pop    %ebp
80107654:	c3                   	ret
80107655:	8d 76 00             	lea    0x0(%esi),%esi
80107658:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010765b:	31 c0                	xor    %eax,%eax
}
8010765d:	5b                   	pop    %ebx
8010765e:	5e                   	pop    %esi
8010765f:	5f                   	pop    %edi
80107660:	5d                   	pop    %ebp
80107661:	c3                   	ret

80107662 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107662:	a1 00 00 00 00       	mov    0x0,%eax
80107667:	0f 0b                	ud2

80107669 <copyout.cold>:
80107669:	a1 00 00 00 00       	mov    0x0,%eax
8010766e:	0f 0b                	ud2
