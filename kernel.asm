
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 24 37 10 80       	mov    $0x80103724,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 e4 83 10 	movl   $0x801083e4,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 94 4d 00 00       	call   80104de2 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 70 05 11 80 64 	movl   $0x80110564,0x80110570
80100055:	05 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 74 05 11 80 64 	movl   $0x80110564,0x80110574
8010005f:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 74 05 11 80       	mov    0x80110574,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 74 05 11 80       	mov    %eax,0x80110574

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000bd:	e8 41 4d 00 00       	call   80104e03 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 74 05 11 80       	mov    0x80110574,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	83 c8 01             	or     $0x1,%eax
801000f6:	89 c2                	mov    %eax,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100104:	e8 5c 4d 00 00       	call   80104e65 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 12 4a 00 00       	call   80104b36 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 70 05 11 80       	mov    0x80110570,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017c:	e8 e4 4c 00 00       	call   80104e65 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 eb 83 10 80 	movl   $0x801083eb,(%esp)
8010019f:	e8 96 03 00 00       	call   8010053a <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 cf 25 00 00       	call   801027a7 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 fc 83 10 80 	movl   $0x801083fc,(%esp)
801001f6:	e8 3f 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	83 c8 04             	or     $0x4,%eax
80100203:	89 c2                	mov    %eax,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 92 25 00 00       	call   801027a7 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 03 84 10 80 	movl   $0x80108403,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023c:	e8 c2 4b 00 00       	call   80104e03 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 74 05 11 80       	mov    0x80110574,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 74 05 11 80       	mov    %eax,0x80110574

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	83 e0 fe             	and    $0xfffffffe,%eax
80100290:	89 c2                	mov    %eax,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 6d 49 00 00       	call   80104c0f <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002a9:	e8 b7 4b 00 00       	call   80104e65 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	83 ec 14             	sub    $0x14,%esp
801002b6:	8b 45 08             	mov    0x8(%ebp),%eax
801002b9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	ec                   	in     (%dx),%al
801002c4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002c7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cb:	c9                   	leave  
801002cc:	c3                   	ret    

801002cd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002cd:	55                   	push   %ebp
801002ce:	89 e5                	mov    %esp,%ebp
801002d0:	83 ec 08             	sub    $0x8,%esp
801002d3:	8b 55 08             	mov    0x8(%ebp),%edx
801002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002d9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002e8:	ee                   	out    %al,(%dx)
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002ee:	fa                   	cli    
}
801002ef:	5d                   	pop    %ebp
801002f0:	c3                   	ret    

801002f1 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801002fd:	74 1c                	je     8010031b <printint+0x2a>
801002ff:	8b 45 08             	mov    0x8(%ebp),%eax
80100302:	c1 e8 1f             	shr    $0x1f,%eax
80100305:	0f b6 c0             	movzbl %al,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x2a>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100319:	eb 06                	jmp    80100321 <printint+0x30>
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100321:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010032b:	8d 41 01             	lea    0x1(%ecx),%eax
8010032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100337:	ba 00 00 00 00       	mov    $0x0,%edx
8010033c:	f7 f3                	div    %ebx
8010033e:	89 d0                	mov    %edx,%eax
80100340:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100347:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010034b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100351:	ba 00 00 00 00       	mov    $0x0,%edx
80100356:	f7 f6                	div    %esi
80100358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010035b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010035f:	75 c7                	jne    80100328 <printint+0x37>

  if(sign)
80100361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100365:	74 10                	je     80100377 <printint+0x86>
    buf[i++] = '-';
80100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010036a:	8d 50 01             	lea    0x1(%eax),%edx
8010036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100370:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100375:	eb 18                	jmp    8010038f <printint+0x9e>
80100377:	eb 16                	jmp    8010038f <printint+0x9e>
    consputc(buf[i]);
80100379:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037f:	01 d0                	add    %edx,%eax
80100381:	0f b6 00             	movzbl (%eax),%eax
80100384:	0f be c0             	movsbl %al,%eax
80100387:	89 04 24             	mov    %eax,(%esp)
8010038a:	e8 c1 03 00 00       	call   80100750 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100397:	79 e0                	jns    80100379 <printint+0x88>
    consputc(buf[i]);
}
80100399:	83 c4 30             	add    $0x30,%esp
8010039c:	5b                   	pop    %ebx
8010039d:	5e                   	pop    %esi
8010039e:	5d                   	pop    %ebp
8010039f:	c3                   	ret    

801003a0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a6:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003bb:	e8 43 4a 00 00       	call   80104e03 <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 0a 84 10 80 	movl   $0x8010840a,(%esp)
801003ce:	e8 67 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e0:	e9 21 01 00 00       	jmp    80100506 <cprintf+0x166>
    if(c != '%'){
801003e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5b>
      consputc(c);
801003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 5a 03 00 00       	call   80100750 <consputc>
      continue;
801003f6:	e9 07 01 00 00       	jmp    80100502 <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	0f b6 00             	movzbl (%eax),%eax
8010040a:	0f be c0             	movsbl %al,%eax
8010040d:	25 ff 00 00 00       	and    $0xff,%eax
80100412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100415:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100419:	75 05                	jne    80100420 <cprintf+0x80>
      break;
8010041b:	e9 06 01 00 00       	jmp    80100526 <cprintf+0x186>
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4f                	je     80100477 <cprintf+0xd7>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa0>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13c>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xaf>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14a>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 57                	je     8010049c <cprintf+0xfc>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2d                	je     80100477 <cprintf+0xd7>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8d 50 04             	lea    0x4(%eax),%edx
80100455:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100458:	8b 00                	mov    (%eax),%eax
8010045a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100461:	00 
80100462:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100469:	00 
8010046a:	89 04 24             	mov    %eax,(%esp)
8010046d:	e8 7f fe ff ff       	call   801002f1 <printint>
      break;
80100472:	e9 8b 00 00 00       	jmp    80100502 <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 57 fe ff ff       	call   801002f1 <printint>
      break;
8010049a:	eb 66                	jmp    80100502 <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ae:	75 09                	jne    801004b9 <cprintf+0x119>
        s = "(null)";
801004b0:	c7 45 ec 13 84 10 80 	movl   $0x80108413,-0x14(%ebp)
      for(; *s; s++)
801004b7:	eb 17                	jmp    801004d0 <cprintf+0x130>
801004b9:	eb 15                	jmp    801004d0 <cprintf+0x130>
        consputc(*s);
801004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004be:	0f b6 00             	movzbl (%eax),%eax
801004c1:	0f be c0             	movsbl %al,%eax
801004c4:	89 04 24             	mov    %eax,(%esp)
801004c7:	e8 84 02 00 00       	call   80100750 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004cc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 e1                	jne    801004bb <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x162>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 68 02 00 00       	call   80100750 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5a 02 00 00       	call   80100750 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 4f 02 00 00       	call   80100750 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x198>
    release(&cons.lock);
8010052c:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100533:	e8 2d 49 00 00       	call   80104e65 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 a6 fd ff ff       	call   801002eb <cli>
  cons.locking = 0;
80100545:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 1a 84 10 80 	movl   $0x8010841a,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 29 84 10 80 	movl   $0x80108429,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 20 49 00 00       	call   80104eb4 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 2b 84 10 80 	movl   $0x8010842b,(%esp)
801005af:	e8 ec fd ff ff       	call   801003a0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 e9 fc ff ff       	call   801002cd <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c0 fc ff ff       	call   801002b0 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c0 fc ff ff       	call   801002cd <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 97 fc ff ff       	call   801002b0 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	29 c1                	sub    %eax,%ecx
80100647:	89 ca                	mov    %ecx,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 35                	jmp    8010068a <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 26                	jle    8010068a <cgaputc+0xc0>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 20                	jmp    8010068a <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100673:	8d 50 01             	lea    0x1(%eax),%edx
80100676:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100679:	01 c0                	add    %eax,%eax
8010067b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067e:	8b 45 08             	mov    0x8(%ebp),%eax
80100681:	0f b6 c0             	movzbl %al,%eax
80100684:	80 cc 07             	or     $0x7,%ah
80100687:	66 89 02             	mov    %ax,(%edx)
  
  if((pos/80) >= 24){  // Scroll up.
8010068a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100691:	7e 53                	jle    801006e6 <cgaputc+0x11c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100693:	a1 00 90 10 80       	mov    0x80109000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 72 4a 00 00       	call   80105129 <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 90 10 80       	mov    0x80109000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 74 49 00 00       	call   8010505a <memset>
  }
  
  outb(CRTPORT, 14);
801006e6:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006ed:	00 
801006ee:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f5:	e8 d3 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos>>8);
801006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fd:	c1 f8 08             	sar    $0x8,%eax
80100700:	0f b6 c0             	movzbl %al,%eax
80100703:	89 44 24 04          	mov    %eax,0x4(%esp)
80100707:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070e:	e8 ba fb ff ff       	call   801002cd <outb>
  outb(CRTPORT, 15);
80100713:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071a:	00 
8010071b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100722:	e8 a6 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos);
80100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072a:	0f b6 c0             	movzbl %al,%eax
8010072d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100731:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100738:	e8 90 fb ff ff       	call   801002cd <outb>
  crt[pos] = ' ' | 0x0700;
8010073d:	a1 00 90 10 80       	mov    0x80109000,%eax
80100742:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100745:	01 d2                	add    %edx,%edx
80100747:	01 d0                	add    %edx,%eax
80100749:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074e:	c9                   	leave  
8010074f:	c3                   	ret    

80100750 <consputc>:

void
consputc(int c)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100756:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	74 07                	je     80100766 <consputc+0x16>
    cli();
8010075f:	e8 87 fb ff ff       	call   801002eb <cli>
    for(;;)
      ;
80100764:	eb fe                	jmp    80100764 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100766:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076d:	75 26                	jne    80100795 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100776:	e8 a4 62 00 00       	call   80106a1f <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 98 62 00 00       	call   80106a1f <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 8c 62 00 00       	call   80106a1f <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 7f 62 00 00       	call   80106a1f <uartputc>
  cgaputc(c);
801007a0:	8b 45 08             	mov    0x8(%ebp),%eax
801007a3:	89 04 24             	mov    %eax,(%esp)
801007a6:	e8 1f fe ff ff       	call   801005ca <cgaputc>
}
801007ab:	c9                   	leave  
801007ac:	c3                   	ret    

801007ad <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ad:	55                   	push   %ebp
801007ae:	89 e5                	mov    %esp,%ebp
801007b0:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b3:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
801007ba:	e8 44 46 00 00       	call   80104e03 <acquire>
  while((c = getc()) >= 0){
801007bf:	e9 37 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    switch(c){
801007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c7:	83 f8 10             	cmp    $0x10,%eax
801007ca:	74 1e                	je     801007ea <consoleintr+0x3d>
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	7f 0a                	jg     801007db <consoleintr+0x2e>
801007d1:	83 f8 08             	cmp    $0x8,%eax
801007d4:	74 64                	je     8010083a <consoleintr+0x8d>
801007d6:	e9 91 00 00 00       	jmp    8010086c <consoleintr+0xbf>
801007db:	83 f8 15             	cmp    $0x15,%eax
801007de:	74 2f                	je     8010080f <consoleintr+0x62>
801007e0:	83 f8 7f             	cmp    $0x7f,%eax
801007e3:	74 55                	je     8010083a <consoleintr+0x8d>
801007e5:	e9 82 00 00 00       	jmp    8010086c <consoleintr+0xbf>
    case C('P'):  // Process listing.
      procdump();
801007ea:	e8 c3 44 00 00       	call   80104cb2 <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 3c 08 11 80       	mov    0x8011083c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 3c 08 11 80       	mov    %eax,0x8011083c
        consputc(BACKSPACE);
80100801:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100808:	e8 43 ff ff ff       	call   80100750 <consputc>
8010080d:	eb 01                	jmp    80100810 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080f:	90                   	nop
80100810:	8b 15 3c 08 11 80    	mov    0x8011083c,%edx
80100816:	a1 38 08 11 80       	mov    0x80110838,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 3c 08 11 80       	mov    0x8011083c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 b4 07 11 80 	movzbl -0x7feef84c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100831:	3c 0a                	cmp    $0xa,%al
80100833:	75 bf                	jne    801007f4 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100835:	e9 c1 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083a:	8b 15 3c 08 11 80    	mov    0x8011083c,%edx
80100840:	a1 38 08 11 80       	mov    0x80110838,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 3c 08 11 80       	mov    0x8011083c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 3c 08 11 80       	mov    %eax,0x8011083c
        consputc(BACKSPACE);
80100856:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010085d:	e8 ee fe ff ff       	call   80100750 <consputc>
      }
      break;
80100862:	e9 94 00 00 00       	jmp    801008fb <consoleintr+0x14e>
80100867:	e9 8f 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100870:	0f 84 84 00 00 00    	je     801008fa <consoleintr+0x14d>
80100876:	8b 15 3c 08 11 80    	mov    0x8011083c,%edx
8010087c:	a1 34 08 11 80       	mov    0x80110834,%eax
80100881:	29 c2                	sub    %eax,%edx
80100883:	89 d0                	mov    %edx,%eax
80100885:	83 f8 7f             	cmp    $0x7f,%eax
80100888:	77 70                	ja     801008fa <consoleintr+0x14d>
        c = (c == '\r') ? '\n' : c;
8010088a:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010088e:	74 05                	je     80100895 <consoleintr+0xe8>
80100890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100893:	eb 05                	jmp    8010089a <consoleintr+0xed>
80100895:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010089d:	a1 3c 08 11 80       	mov    0x8011083c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 3c 08 11 80    	mov    %edx,0x8011083c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 b4 07 11 80    	mov    %al,-0x7feef84c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 3c 08 11 80       	mov    0x8011083c,%eax
801008d5:	8b 15 34 08 11 80    	mov    0x80110834,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 3c 08 11 80       	mov    0x8011083c,%eax
801008e7:	a3 38 08 11 80       	mov    %eax,0x80110838
          wakeup(&input.r);
801008ec:	c7 04 24 34 08 11 80 	movl   $0x80110834,(%esp)
801008f3:	e8 17 43 00 00       	call   80104c0f <wakeup>
        }
      }
      break;
801008f8:	eb 00                	jmp    801008fa <consoleintr+0x14d>
801008fa:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801008fb:	8b 45 08             	mov    0x8(%ebp),%eax
801008fe:	ff d0                	call   *%eax
80100900:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100907:	0f 89 b7 fe ff ff    	jns    801007c4 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010090d:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
80100914:	e8 4c 45 00 00       	call   80104e65 <release>
}
80100919:	c9                   	leave  
8010091a:	c3                   	ret    

8010091b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010091b:	55                   	push   %ebp
8010091c:	89 e5                	mov    %esp,%ebp
8010091e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100921:	8b 45 08             	mov    0x8(%ebp),%eax
80100924:	89 04 24             	mov    %eax,(%esp)
80100927:	e8 80 10 00 00       	call   801019ac <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
80100939:	e8 c5 44 00 00       	call   80104e03 <acquire>
  while(n > 0){
8010093e:	e9 aa 00 00 00       	jmp    801009ed <consoleread+0xd2>
    while(input.r == input.w){
80100943:	eb 42                	jmp    80100987 <consoleread+0x6c>
      if(proc->killed){
80100945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094b:	8b 40 24             	mov    0x24(%eax),%eax
8010094e:	85 c0                	test   %eax,%eax
80100950:	74 21                	je     80100973 <consoleread+0x58>
        release(&input.lock);
80100952:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
80100959:	e8 07 45 00 00       	call   80104e65 <release>
        ilock(ip);
8010095e:	8b 45 08             	mov    0x8(%ebp),%eax
80100961:	89 04 24             	mov    %eax,(%esp)
80100964:	e8 f5 0e 00 00       	call   8010185e <ilock>
        return -1;
80100969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096e:	e9 a5 00 00 00       	jmp    80100a18 <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100973:	c7 44 24 04 80 07 11 	movl   $0x80110780,0x4(%esp)
8010097a:	80 
8010097b:	c7 04 24 34 08 11 80 	movl   $0x80110834,(%esp)
80100982:	e8 af 41 00 00       	call   80104b36 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100987:	8b 15 34 08 11 80    	mov    0x80110834,%edx
8010098d:	a1 38 08 11 80       	mov    0x80110838,%eax
80100992:	39 c2                	cmp    %eax,%edx
80100994:	74 af                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100996:	a1 34 08 11 80       	mov    0x80110834,%eax
8010099b:	8d 50 01             	lea    0x1(%eax),%edx
8010099e:	89 15 34 08 11 80    	mov    %edx,0x80110834
801009a4:	83 e0 7f             	and    $0x7f,%eax
801009a7:	0f b6 80 b4 07 11 80 	movzbl -0x7feef84c(%eax),%eax
801009ae:	0f be c0             	movsbl %al,%eax
801009b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009b4:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009b8:	75 19                	jne    801009d3 <consoleread+0xb8>
      if(n < target){
801009ba:	8b 45 10             	mov    0x10(%ebp),%eax
801009bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009c0:	73 0f                	jae    801009d1 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c2:	a1 34 08 11 80       	mov    0x80110834,%eax
801009c7:	83 e8 01             	sub    $0x1,%eax
801009ca:	a3 34 08 11 80       	mov    %eax,0x80110834
      }
      break;
801009cf:	eb 26                	jmp    801009f7 <consoleread+0xdc>
801009d1:	eb 24                	jmp    801009f7 <consoleread+0xdc>
    }
    *dst++ = c;
801009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801009d6:	8d 50 01             	lea    0x1(%eax),%edx
801009d9:	89 55 0c             	mov    %edx,0xc(%ebp)
801009dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009df:	88 10                	mov    %dl,(%eax)
    --n;
801009e1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009e5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009e9:	75 02                	jne    801009ed <consoleread+0xd2>
      break;
801009eb:	eb 0a                	jmp    801009f7 <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f1:	0f 8f 4c ff ff ff    	jg     80100943 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
801009f7:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
801009fe:	e8 62 44 00 00       	call   80104e65 <release>
  ilock(ip);
80100a03:	8b 45 08             	mov    0x8(%ebp),%eax
80100a06:	89 04 24             	mov    %eax,(%esp)
80100a09:	e8 50 0e 00 00       	call   8010185e <ilock>

  return target - n;
80100a0e:	8b 45 10             	mov    0x10(%ebp),%eax
80100a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a14:	29 c2                	sub    %eax,%edx
80100a16:	89 d0                	mov    %edx,%eax
}
80100a18:	c9                   	leave  
80100a19:	c3                   	ret    

80100a1a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a1a:	55                   	push   %ebp
80100a1b:	89 e5                	mov    %esp,%ebp
80100a1d:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a20:	8b 45 08             	mov    0x8(%ebp),%eax
80100a23:	89 04 24             	mov    %eax,(%esp)
80100a26:	e8 81 0f 00 00       	call   801019ac <iunlock>
  acquire(&cons.lock);
80100a2b:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a32:	e8 cc 43 00 00       	call   80104e03 <acquire>
  for(i = 0; i < n; i++)
80100a37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a3e:	eb 1d                	jmp    80100a5d <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a43:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a46:	01 d0                	add    %edx,%eax
80100a48:	0f b6 00             	movzbl (%eax),%eax
80100a4b:	0f be c0             	movsbl %al,%eax
80100a4e:	0f b6 c0             	movzbl %al,%eax
80100a51:	89 04 24             	mov    %eax,(%esp)
80100a54:	e8 f7 fc ff ff       	call   80100750 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a60:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a63:	7c db                	jl     80100a40 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a65:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a6c:	e8 f4 43 00 00       	call   80104e65 <release>
  ilock(ip);
80100a71:	8b 45 08             	mov    0x8(%ebp),%eax
80100a74:	89 04 24             	mov    %eax,(%esp)
80100a77:	e8 e2 0d 00 00       	call   8010185e <ilock>

  return n;
80100a7c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a7f:	c9                   	leave  
80100a80:	c3                   	ret    

80100a81 <consoleinit>:

void
consoleinit(void)
{
80100a81:	55                   	push   %ebp
80100a82:	89 e5                	mov    %esp,%ebp
80100a84:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a87:	c7 44 24 04 2f 84 10 	movl   $0x8010842f,0x4(%esp)
80100a8e:	80 
80100a8f:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a96:	e8 47 43 00 00       	call   80104de2 <initlock>
  initlock(&input.lock, "input");
80100a9b:	c7 44 24 04 37 84 10 	movl   $0x80108437,0x4(%esp)
80100aa2:	80 
80100aa3:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
80100aaa:	e8 33 43 00 00       	call   80104de2 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aaf:	c7 05 ec 11 11 80 1a 	movl   $0x80100a1a,0x801111ec
80100ab6:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab9:	c7 05 e8 11 11 80 1b 	movl   $0x8010091b,0x801111e8
80100ac0:	09 10 80 
  cons.locking = 1;
80100ac3:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100aca:	00 00 00 

  picenable(IRQ_KBD);
80100acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad4:	e8 ec 32 00 00       	call   80103dc5 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ad9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae0:	00 
80100ae1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae8:	e8 77 1e 00 00       	call   80102964 <ioapicenable>
}
80100aed:	c9                   	leave  
80100aee:	c3                   	ret    
80100aef:	90                   	nop

80100af0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100af0:	55                   	push   %ebp
80100af1:	89 e5                	mov    %esp,%ebp
80100af3:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100af9:	e8 1c 29 00 00       	call   8010341a <begin_op>
  if((ip = namei(path)) == 0){
80100afe:	8b 45 08             	mov    0x8(%ebp),%eax
80100b01:	89 04 24             	mov    %eax,(%esp)
80100b04:	e8 00 19 00 00       	call   80102409 <namei>
80100b09:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b0c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b10:	75 0f                	jne    80100b21 <exec+0x31>
    end_op();
80100b12:	e8 87 29 00 00       	call   8010349e <end_op>
    return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1c:	e9 e8 03 00 00       	jmp    80100f09 <exec+0x419>
  }
  ilock(ip);
80100b21:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b24:	89 04 24             	mov    %eax,(%esp)
80100b27:	e8 32 0d 00 00       	call   8010185e <ilock>
  pgdir = 0;
80100b2c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b33:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b3a:	00 
80100b3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b42:	00 
80100b43:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b49:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b50:	89 04 24             	mov    %eax,(%esp)
80100b53:	e8 13 12 00 00       	call   80101d6b <readi>
80100b58:	83 f8 33             	cmp    $0x33,%eax
80100b5b:	77 05                	ja     80100b62 <exec+0x72>
    goto bad;
80100b5d:	e9 7b 03 00 00       	jmp    80100edd <exec+0x3ed>
  if(elf.magic != ELF_MAGIC)
80100b62:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b68:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6d:	74 05                	je     80100b74 <exec+0x84>
    goto bad;
80100b6f:	e9 69 03 00 00       	jmp    80100edd <exec+0x3ed>

  if((pgdir = setupkvm()) == 0)
80100b74:	e8 fc 6f 00 00       	call   80107b75 <setupkvm>
80100b79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b7c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b80:	75 05                	jne    80100b87 <exec+0x97>
    goto bad;
80100b82:	e9 56 03 00 00       	jmp    80100edd <exec+0x3ed>

  // Load program into memory.
  sz = 0;
80100b87:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b8e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b95:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100b9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100b9e:	e9 cb 00 00 00       	jmp    80100c6e <exec+0x17e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ba6:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bad:	00 
80100bae:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bb2:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbc:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bbf:	89 04 24             	mov    %eax,(%esp)
80100bc2:	e8 a4 11 00 00       	call   80101d6b <readi>
80100bc7:	83 f8 20             	cmp    $0x20,%eax
80100bca:	74 05                	je     80100bd1 <exec+0xe1>
      goto bad;
80100bcc:	e9 0c 03 00 00       	jmp    80100edd <exec+0x3ed>
    if(ph.type != ELF_PROG_LOAD)
80100bd1:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bd7:	83 f8 01             	cmp    $0x1,%eax
80100bda:	74 05                	je     80100be1 <exec+0xf1>
      continue;
80100bdc:	e9 80 00 00 00       	jmp    80100c61 <exec+0x171>
    if(ph.memsz < ph.filesz)
80100be1:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100be7:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bed:	39 c2                	cmp    %eax,%edx
80100bef:	73 05                	jae    80100bf6 <exec+0x106>
      goto bad;
80100bf1:	e9 e7 02 00 00       	jmp    80100edd <exec+0x3ed>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf6:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bfc:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c02:	01 d0                	add    %edx,%eax
80100c04:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c08:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c12:	89 04 24             	mov    %eax,(%esp)
80100c15:	e8 29 73 00 00       	call   80107f43 <allocuvm>
80100c1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c1d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c21:	75 05                	jne    80100c28 <exec+0x138>
      goto bad;
80100c23:	e9 b5 02 00 00       	jmp    80100edd <exec+0x3ed>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c28:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c2e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c34:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c3a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c3e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c42:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c45:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c49:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c50:	89 04 24             	mov    %eax,(%esp)
80100c53:	e8 00 72 00 00       	call   80107e58 <loaduvm>
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	79 05                	jns    80100c61 <exec+0x171>
      goto bad;
80100c5c:	e9 7c 02 00 00       	jmp    80100edd <exec+0x3ed>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c61:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c65:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c68:	83 c0 20             	add    $0x20,%eax
80100c6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c6e:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c75:	0f b7 c0             	movzwl %ax,%eax
80100c78:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c7b:	0f 8f 22 ff ff ff    	jg     80100ba3 <exec+0xb3>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c81:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c84:	89 04 24             	mov    %eax,(%esp)
80100c87:	e8 56 0e 00 00       	call   80101ae2 <iunlockput>
  end_op();
80100c8c:	e8 0d 28 00 00       	call   8010349e <end_op>
  ip = 0;
80100c91:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c9b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ca0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ca5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cab:	05 00 20 00 00       	add    $0x2000,%eax
80100cb0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cbe:	89 04 24             	mov    %eax,(%esp)
80100cc1:	e8 7d 72 00 00       	call   80107f43 <allocuvm>
80100cc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ccd:	75 05                	jne    80100cd4 <exec+0x1e4>
    goto bad;
80100ccf:	e9 09 02 00 00       	jmp    80100edd <exec+0x3ed>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd7:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ce3:	89 04 24             	mov    %eax,(%esp)
80100ce6:	e8 88 74 00 00       	call   80108173 <clearpteu>
  sp = sz;
80100ceb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cee:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cf1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cf8:	e9 9a 00 00 00       	jmp    80100d97 <exec+0x2a7>
    if(argc >= MAXARG)
80100cfd:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d01:	76 05                	jbe    80100d08 <exec+0x218>
      goto bad;
80100d03:	e9 d5 01 00 00       	jmp    80100edd <exec+0x3ed>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d12:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d15:	01 d0                	add    %edx,%eax
80100d17:	8b 00                	mov    (%eax),%eax
80100d19:	89 04 24             	mov    %eax,(%esp)
80100d1c:	e8 a3 45 00 00       	call   801052c4 <strlen>
80100d21:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d24:	29 c2                	sub    %eax,%edx
80100d26:	89 d0                	mov    %edx,%eax
80100d28:	83 e8 01             	sub    $0x1,%eax
80100d2b:	83 e0 fc             	and    $0xfffffffc,%eax
80100d2e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d3e:	01 d0                	add    %edx,%eax
80100d40:	8b 00                	mov    (%eax),%eax
80100d42:	89 04 24             	mov    %eax,(%esp)
80100d45:	e8 7a 45 00 00       	call   801052c4 <strlen>
80100d4a:	83 c0 01             	add    $0x1,%eax
80100d4d:	89 c2                	mov    %eax,%edx
80100d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d52:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d59:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d5c:	01 c8                	add    %ecx,%eax
80100d5e:	8b 00                	mov    (%eax),%eax
80100d60:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d64:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d68:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d72:	89 04 24             	mov    %eax,(%esp)
80100d75:	e8 be 75 00 00       	call   80108338 <copyout>
80100d7a:	85 c0                	test   %eax,%eax
80100d7c:	79 05                	jns    80100d83 <exec+0x293>
      goto bad;
80100d7e:	e9 5a 01 00 00       	jmp    80100edd <exec+0x3ed>
    ustack[3+argc] = sp;
80100d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d86:	8d 50 03             	lea    0x3(%eax),%edx
80100d89:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d8c:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d93:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d9a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100da1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da4:	01 d0                	add    %edx,%eax
80100da6:	8b 00                	mov    (%eax),%eax
80100da8:	85 c0                	test   %eax,%eax
80100daa:	0f 85 4d ff ff ff    	jne    80100cfd <exec+0x20d>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100db0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db3:	83 c0 03             	add    $0x3,%eax
80100db6:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100dbd:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dc1:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dc8:	ff ff ff 
  ustack[1] = argc;
80100dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dce:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd7:	83 c0 01             	add    $0x1,%eax
80100dda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de4:	29 d0                	sub    %edx,%eax
80100de6:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100dec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100def:	83 c0 04             	add    $0x4,%eax
80100df2:	c1 e0 02             	shl    $0x2,%eax
80100df5:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100df8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfb:	83 c0 04             	add    $0x4,%eax
80100dfe:	c1 e0 02             	shl    $0x2,%eax
80100e01:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e05:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e0b:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e12:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e19:	89 04 24             	mov    %eax,(%esp)
80100e1c:	e8 17 75 00 00       	call   80108338 <copyout>
80100e21:	85 c0                	test   %eax,%eax
80100e23:	79 05                	jns    80100e2a <exec+0x33a>
    goto bad;
80100e25:	e9 b3 00 00 00       	jmp    80100edd <exec+0x3ed>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e2a:	8b 45 08             	mov    0x8(%ebp),%eax
80100e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e33:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e36:	eb 17                	jmp    80100e4f <exec+0x35f>
    if(*s == '/')
80100e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e3b:	0f b6 00             	movzbl (%eax),%eax
80100e3e:	3c 2f                	cmp    $0x2f,%al
80100e40:	75 09                	jne    80100e4b <exec+0x35b>
      last = s+1;
80100e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e45:	83 c0 01             	add    $0x1,%eax
80100e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e4b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e52:	0f b6 00             	movzbl (%eax),%eax
80100e55:	84 c0                	test   %al,%al
80100e57:	75 df                	jne    80100e38 <exec+0x348>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e5f:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e62:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e69:	00 
80100e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e71:	89 14 24             	mov    %edx,(%esp)
80100e74:	e8 01 44 00 00       	call   8010527a <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7f:	8b 40 04             	mov    0x4(%eax),%eax
80100e82:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e8e:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e97:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e9a:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea2:	8b 40 18             	mov    0x18(%eax),%eax
80100ea5:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100eab:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100eae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb4:	8b 40 18             	mov    0x18(%eax),%eax
80100eb7:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100eba:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ebd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec3:	89 04 24             	mov    %eax,(%esp)
80100ec6:	e8 9b 6d 00 00       	call   80107c66 <switchuvm>
  freevm(oldpgdir);
80100ecb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ece:	89 04 24             	mov    %eax,(%esp)
80100ed1:	e8 03 72 00 00       	call   801080d9 <freevm>
  return 0;
80100ed6:	b8 00 00 00 00       	mov    $0x0,%eax
80100edb:	eb 2c                	jmp    80100f09 <exec+0x419>

 bad:
  if(pgdir)
80100edd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ee1:	74 0b                	je     80100eee <exec+0x3fe>
    freevm(pgdir);
80100ee3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ee6:	89 04 24             	mov    %eax,(%esp)
80100ee9:	e8 eb 71 00 00       	call   801080d9 <freevm>
  if(ip){
80100eee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ef2:	74 10                	je     80100f04 <exec+0x414>
    iunlockput(ip);
80100ef4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ef7:	89 04 24             	mov    %eax,(%esp)
80100efa:	e8 e3 0b 00 00       	call   80101ae2 <iunlockput>
    end_op();
80100eff:	e8 9a 25 00 00       	call   8010349e <end_op>
  }
  return -1;
80100f04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f09:	c9                   	leave  
80100f0a:	c3                   	ret    
80100f0b:	90                   	nop

80100f0c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f0c:	55                   	push   %ebp
80100f0d:	89 e5                	mov    %esp,%ebp
80100f0f:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f12:	c7 44 24 04 3d 84 10 	movl   $0x8010843d,0x4(%esp)
80100f19:	80 
80100f1a:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f21:	e8 bc 3e 00 00       	call   80104de2 <initlock>
}
80100f26:	c9                   	leave  
80100f27:	c3                   	ret    

80100f28 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f28:	55                   	push   %ebp
80100f29:	89 e5                	mov    %esp,%ebp
80100f2b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f2e:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f35:	e8 c9 3e 00 00       	call   80104e03 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f3a:	c7 45 f4 74 08 11 80 	movl   $0x80110874,-0xc(%ebp)
80100f41:	eb 29                	jmp    80100f6c <filealloc+0x44>
    if(f->ref == 0){
80100f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f46:	8b 40 04             	mov    0x4(%eax),%eax
80100f49:	85 c0                	test   %eax,%eax
80100f4b:	75 1b                	jne    80100f68 <filealloc+0x40>
      f->ref = 1;
80100f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f50:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f57:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f5e:	e8 02 3f 00 00       	call   80104e65 <release>
      return f;
80100f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f66:	eb 1e                	jmp    80100f86 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f68:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f6c:	81 7d f4 d4 11 11 80 	cmpl   $0x801111d4,-0xc(%ebp)
80100f73:	72 ce                	jb     80100f43 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f75:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f7c:	e8 e4 3e 00 00       	call   80104e65 <release>
  return 0;
80100f81:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f86:	c9                   	leave  
80100f87:	c3                   	ret    

80100f88 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f88:	55                   	push   %ebp
80100f89:	89 e5                	mov    %esp,%ebp
80100f8b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f8e:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f95:	e8 69 3e 00 00       	call   80104e03 <acquire>
  if(f->ref < 1)
80100f9a:	8b 45 08             	mov    0x8(%ebp),%eax
80100f9d:	8b 40 04             	mov    0x4(%eax),%eax
80100fa0:	85 c0                	test   %eax,%eax
80100fa2:	7f 0c                	jg     80100fb0 <filedup+0x28>
    panic("filedup");
80100fa4:	c7 04 24 44 84 10 80 	movl   $0x80108444,(%esp)
80100fab:	e8 8a f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb3:	8b 40 04             	mov    0x4(%eax),%eax
80100fb6:	8d 50 01             	lea    0x1(%eax),%edx
80100fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80100fbc:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fbf:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100fc6:	e8 9a 3e 00 00       	call   80104e65 <release>
  return f;
80100fcb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fce:	c9                   	leave  
80100fcf:	c3                   	ret    

80100fd0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fd6:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100fdd:	e8 21 3e 00 00       	call   80104e03 <acquire>
  if(f->ref < 1)
80100fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe5:	8b 40 04             	mov    0x4(%eax),%eax
80100fe8:	85 c0                	test   %eax,%eax
80100fea:	7f 0c                	jg     80100ff8 <fileclose+0x28>
    panic("fileclose");
80100fec:	c7 04 24 4c 84 10 80 	movl   $0x8010844c,(%esp)
80100ff3:	e8 42 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80100ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffb:	8b 40 04             	mov    0x4(%eax),%eax
80100ffe:	8d 50 ff             	lea    -0x1(%eax),%edx
80101001:	8b 45 08             	mov    0x8(%ebp),%eax
80101004:	89 50 04             	mov    %edx,0x4(%eax)
80101007:	8b 45 08             	mov    0x8(%ebp),%eax
8010100a:	8b 40 04             	mov    0x4(%eax),%eax
8010100d:	85 c0                	test   %eax,%eax
8010100f:	7e 11                	jle    80101022 <fileclose+0x52>
    release(&ftable.lock);
80101011:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80101018:	e8 48 3e 00 00       	call   80104e65 <release>
8010101d:	e9 82 00 00 00       	jmp    801010a4 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101022:	8b 45 08             	mov    0x8(%ebp),%eax
80101025:	8b 10                	mov    (%eax),%edx
80101027:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010102a:	8b 50 04             	mov    0x4(%eax),%edx
8010102d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101030:	8b 50 08             	mov    0x8(%eax),%edx
80101033:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101036:	8b 50 0c             	mov    0xc(%eax),%edx
80101039:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010103c:	8b 50 10             	mov    0x10(%eax),%edx
8010103f:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101042:	8b 40 14             	mov    0x14(%eax),%eax
80101045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101048:	8b 45 08             	mov    0x8(%ebp),%eax
8010104b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101052:	8b 45 08             	mov    0x8(%ebp),%eax
80101055:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010105b:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80101062:	e8 fe 3d 00 00       	call   80104e65 <release>
  
  if(ff.type == FD_PIPE)
80101067:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010106a:	83 f8 01             	cmp    $0x1,%eax
8010106d:	75 18                	jne    80101087 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
8010106f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101073:	0f be d0             	movsbl %al,%edx
80101076:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101079:	89 54 24 04          	mov    %edx,0x4(%esp)
8010107d:	89 04 24             	mov    %eax,(%esp)
80101080:	e8 f2 2f 00 00       	call   80104077 <pipeclose>
80101085:	eb 1d                	jmp    801010a4 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101087:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010108a:	83 f8 02             	cmp    $0x2,%eax
8010108d:	75 15                	jne    801010a4 <fileclose+0xd4>
    begin_op();
8010108f:	e8 86 23 00 00       	call   8010341a <begin_op>
    iput(ff.ip);
80101094:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101097:	89 04 24             	mov    %eax,(%esp)
8010109a:	e8 72 09 00 00       	call   80101a11 <iput>
    end_op();
8010109f:	e8 fa 23 00 00       	call   8010349e <end_op>
  }
}
801010a4:	c9                   	leave  
801010a5:	c3                   	ret    

801010a6 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010a6:	55                   	push   %ebp
801010a7:	89 e5                	mov    %esp,%ebp
801010a9:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010ac:	8b 45 08             	mov    0x8(%ebp),%eax
801010af:	8b 00                	mov    (%eax),%eax
801010b1:	83 f8 02             	cmp    $0x2,%eax
801010b4:	75 38                	jne    801010ee <filestat+0x48>
    ilock(f->ip);
801010b6:	8b 45 08             	mov    0x8(%ebp),%eax
801010b9:	8b 40 10             	mov    0x10(%eax),%eax
801010bc:	89 04 24             	mov    %eax,(%esp)
801010bf:	e8 9a 07 00 00       	call   8010185e <ilock>
    stati(f->ip, st);
801010c4:	8b 45 08             	mov    0x8(%ebp),%eax
801010c7:	8b 40 10             	mov    0x10(%eax),%eax
801010ca:	8b 55 0c             	mov    0xc(%ebp),%edx
801010cd:	89 54 24 04          	mov    %edx,0x4(%esp)
801010d1:	89 04 24             	mov    %eax,(%esp)
801010d4:	e8 4d 0c 00 00       	call   80101d26 <stati>
    iunlock(f->ip);
801010d9:	8b 45 08             	mov    0x8(%ebp),%eax
801010dc:	8b 40 10             	mov    0x10(%eax),%eax
801010df:	89 04 24             	mov    %eax,(%esp)
801010e2:	e8 c5 08 00 00       	call   801019ac <iunlock>
    return 0;
801010e7:	b8 00 00 00 00       	mov    $0x0,%eax
801010ec:	eb 05                	jmp    801010f3 <filestat+0x4d>
  }
  return -1;
801010ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010f3:	c9                   	leave  
801010f4:	c3                   	ret    

801010f5 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010f5:	55                   	push   %ebp
801010f6:	89 e5                	mov    %esp,%ebp
801010f8:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801010fb:	8b 45 08             	mov    0x8(%ebp),%eax
801010fe:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101102:	84 c0                	test   %al,%al
80101104:	75 0a                	jne    80101110 <fileread+0x1b>
    return -1;
80101106:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010110b:	e9 9f 00 00 00       	jmp    801011af <fileread+0xba>
  if(f->type == FD_PIPE)
80101110:	8b 45 08             	mov    0x8(%ebp),%eax
80101113:	8b 00                	mov    (%eax),%eax
80101115:	83 f8 01             	cmp    $0x1,%eax
80101118:	75 1e                	jne    80101138 <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010111a:	8b 45 08             	mov    0x8(%ebp),%eax
8010111d:	8b 40 0c             	mov    0xc(%eax),%eax
80101120:	8b 55 10             	mov    0x10(%ebp),%edx
80101123:	89 54 24 08          	mov    %edx,0x8(%esp)
80101127:	8b 55 0c             	mov    0xc(%ebp),%edx
8010112a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010112e:	89 04 24             	mov    %eax,(%esp)
80101131:	e8 c2 30 00 00       	call   801041f8 <piperead>
80101136:	eb 77                	jmp    801011af <fileread+0xba>
  if(f->type == FD_INODE){
80101138:	8b 45 08             	mov    0x8(%ebp),%eax
8010113b:	8b 00                	mov    (%eax),%eax
8010113d:	83 f8 02             	cmp    $0x2,%eax
80101140:	75 61                	jne    801011a3 <fileread+0xae>
    ilock(f->ip);
80101142:	8b 45 08             	mov    0x8(%ebp),%eax
80101145:	8b 40 10             	mov    0x10(%eax),%eax
80101148:	89 04 24             	mov    %eax,(%esp)
8010114b:	e8 0e 07 00 00       	call   8010185e <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101150:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101153:	8b 45 08             	mov    0x8(%ebp),%eax
80101156:	8b 50 14             	mov    0x14(%eax),%edx
80101159:	8b 45 08             	mov    0x8(%ebp),%eax
8010115c:	8b 40 10             	mov    0x10(%eax),%eax
8010115f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101163:	89 54 24 08          	mov    %edx,0x8(%esp)
80101167:	8b 55 0c             	mov    0xc(%ebp),%edx
8010116a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010116e:	89 04 24             	mov    %eax,(%esp)
80101171:	e8 f5 0b 00 00       	call   80101d6b <readi>
80101176:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101179:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010117d:	7e 11                	jle    80101190 <fileread+0x9b>
      f->off += r;
8010117f:	8b 45 08             	mov    0x8(%ebp),%eax
80101182:	8b 50 14             	mov    0x14(%eax),%edx
80101185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101188:	01 c2                	add    %eax,%edx
8010118a:	8b 45 08             	mov    0x8(%ebp),%eax
8010118d:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101190:	8b 45 08             	mov    0x8(%ebp),%eax
80101193:	8b 40 10             	mov    0x10(%eax),%eax
80101196:	89 04 24             	mov    %eax,(%esp)
80101199:	e8 0e 08 00 00       	call   801019ac <iunlock>
    return r;
8010119e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011a1:	eb 0c                	jmp    801011af <fileread+0xba>
  }
  panic("fileread");
801011a3:	c7 04 24 56 84 10 80 	movl   $0x80108456,(%esp)
801011aa:	e8 8b f3 ff ff       	call   8010053a <panic>
}
801011af:	c9                   	leave  
801011b0:	c3                   	ret    

801011b1 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011b1:	55                   	push   %ebp
801011b2:	89 e5                	mov    %esp,%ebp
801011b4:	53                   	push   %ebx
801011b5:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011b8:	8b 45 08             	mov    0x8(%ebp),%eax
801011bb:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011bf:	84 c0                	test   %al,%al
801011c1:	75 0a                	jne    801011cd <filewrite+0x1c>
    return -1;
801011c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011c8:	e9 20 01 00 00       	jmp    801012ed <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011cd:	8b 45 08             	mov    0x8(%ebp),%eax
801011d0:	8b 00                	mov    (%eax),%eax
801011d2:	83 f8 01             	cmp    $0x1,%eax
801011d5:	75 21                	jne    801011f8 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011d7:	8b 45 08             	mov    0x8(%ebp),%eax
801011da:	8b 40 0c             	mov    0xc(%eax),%eax
801011dd:	8b 55 10             	mov    0x10(%ebp),%edx
801011e0:	89 54 24 08          	mov    %edx,0x8(%esp)
801011e4:	8b 55 0c             	mov    0xc(%ebp),%edx
801011e7:	89 54 24 04          	mov    %edx,0x4(%esp)
801011eb:	89 04 24             	mov    %eax,(%esp)
801011ee:	e8 16 2f 00 00       	call   80104109 <pipewrite>
801011f3:	e9 f5 00 00 00       	jmp    801012ed <filewrite+0x13c>
  if(f->type == FD_INODE){
801011f8:	8b 45 08             	mov    0x8(%ebp),%eax
801011fb:	8b 00                	mov    (%eax),%eax
801011fd:	83 f8 02             	cmp    $0x2,%eax
80101200:	0f 85 db 00 00 00    	jne    801012e1 <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101206:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010120d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101214:	e9 a8 00 00 00       	jmp    801012c1 <filewrite+0x110>
      int n1 = n - i;
80101219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010121c:	8b 55 10             	mov    0x10(%ebp),%edx
8010121f:	29 c2                	sub    %eax,%edx
80101221:	89 d0                	mov    %edx,%eax
80101223:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101226:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101229:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010122c:	7e 06                	jle    80101234 <filewrite+0x83>
        n1 = max;
8010122e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101231:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101234:	e8 e1 21 00 00       	call   8010341a <begin_op>
      ilock(f->ip);
80101239:	8b 45 08             	mov    0x8(%ebp),%eax
8010123c:	8b 40 10             	mov    0x10(%eax),%eax
8010123f:	89 04 24             	mov    %eax,(%esp)
80101242:	e8 17 06 00 00       	call   8010185e <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101247:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010124a:	8b 45 08             	mov    0x8(%ebp),%eax
8010124d:	8b 50 14             	mov    0x14(%eax),%edx
80101250:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101253:	8b 45 0c             	mov    0xc(%ebp),%eax
80101256:	01 c3                	add    %eax,%ebx
80101258:	8b 45 08             	mov    0x8(%ebp),%eax
8010125b:	8b 40 10             	mov    0x10(%eax),%eax
8010125e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101262:	89 54 24 08          	mov    %edx,0x8(%esp)
80101266:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010126a:	89 04 24             	mov    %eax,(%esp)
8010126d:	e8 5d 0c 00 00       	call   80101ecf <writei>
80101272:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101275:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101279:	7e 11                	jle    8010128c <filewrite+0xdb>
        f->off += r;
8010127b:	8b 45 08             	mov    0x8(%ebp),%eax
8010127e:	8b 50 14             	mov    0x14(%eax),%edx
80101281:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101284:	01 c2                	add    %eax,%edx
80101286:	8b 45 08             	mov    0x8(%ebp),%eax
80101289:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010128c:	8b 45 08             	mov    0x8(%ebp),%eax
8010128f:	8b 40 10             	mov    0x10(%eax),%eax
80101292:	89 04 24             	mov    %eax,(%esp)
80101295:	e8 12 07 00 00       	call   801019ac <iunlock>
      end_op();
8010129a:	e8 ff 21 00 00       	call   8010349e <end_op>

      if(r < 0)
8010129f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012a3:	79 02                	jns    801012a7 <filewrite+0xf6>
        break;
801012a5:	eb 26                	jmp    801012cd <filewrite+0x11c>
      if(r != n1)
801012a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012ad:	74 0c                	je     801012bb <filewrite+0x10a>
        panic("short filewrite");
801012af:	c7 04 24 5f 84 10 80 	movl   $0x8010845f,(%esp)
801012b6:	e8 7f f2 ff ff       	call   8010053a <panic>
      i += r;
801012bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012be:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c4:	3b 45 10             	cmp    0x10(%ebp),%eax
801012c7:	0f 8c 4c ff ff ff    	jl     80101219 <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012d0:	3b 45 10             	cmp    0x10(%ebp),%eax
801012d3:	75 05                	jne    801012da <filewrite+0x129>
801012d5:	8b 45 10             	mov    0x10(%ebp),%eax
801012d8:	eb 05                	jmp    801012df <filewrite+0x12e>
801012da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012df:	eb 0c                	jmp    801012ed <filewrite+0x13c>
  }
  panic("filewrite");
801012e1:	c7 04 24 6f 84 10 80 	movl   $0x8010846f,(%esp)
801012e8:	e8 4d f2 ff ff       	call   8010053a <panic>
}
801012ed:	83 c4 24             	add    $0x24,%esp
801012f0:	5b                   	pop    %ebx
801012f1:	5d                   	pop    %ebp
801012f2:	c3                   	ret    
801012f3:	90                   	nop

801012f4 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012f4:	55                   	push   %ebp
801012f5:	89 e5                	mov    %esp,%ebp
801012f7:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012fa:	8b 45 08             	mov    0x8(%ebp),%eax
801012fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101304:	00 
80101305:	89 04 24             	mov    %eax,(%esp)
80101308:	e8 99 ee ff ff       	call   801001a6 <bread>
8010130d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101313:	83 c0 18             	add    $0x18,%eax
80101316:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010131d:	00 
8010131e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101322:	8b 45 0c             	mov    0xc(%ebp),%eax
80101325:	89 04 24             	mov    %eax,(%esp)
80101328:	e8 fc 3d 00 00       	call   80105129 <memmove>
  brelse(bp);
8010132d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101330:	89 04 24             	mov    %eax,(%esp)
80101333:	e8 df ee ff ff       	call   80100217 <brelse>
}
80101338:	c9                   	leave  
80101339:	c3                   	ret    

8010133a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010133a:	55                   	push   %ebp
8010133b:	89 e5                	mov    %esp,%ebp
8010133d:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101340:	8b 55 0c             	mov    0xc(%ebp),%edx
80101343:	8b 45 08             	mov    0x8(%ebp),%eax
80101346:	89 54 24 04          	mov    %edx,0x4(%esp)
8010134a:	89 04 24             	mov    %eax,(%esp)
8010134d:	e8 54 ee ff ff       	call   801001a6 <bread>
80101352:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101358:	83 c0 18             	add    $0x18,%eax
8010135b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101362:	00 
80101363:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010136a:	00 
8010136b:	89 04 24             	mov    %eax,(%esp)
8010136e:	e8 e7 3c 00 00       	call   8010505a <memset>
  log_write(bp);
80101373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101376:	89 04 24             	mov    %eax,(%esp)
80101379:	e8 a7 22 00 00       	call   80103625 <log_write>
  brelse(bp);
8010137e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101381:	89 04 24             	mov    %eax,(%esp)
80101384:	e8 8e ee ff ff       	call   80100217 <brelse>
}
80101389:	c9                   	leave  
8010138a:	c3                   	ret    

8010138b <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010138b:	55                   	push   %ebp
8010138c:	89 e5                	mov    %esp,%ebp
8010138e:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
80101391:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
80101398:	8b 45 08             	mov    0x8(%ebp),%eax
8010139b:	8d 55 d8             	lea    -0x28(%ebp),%edx
8010139e:	89 54 24 04          	mov    %edx,0x4(%esp)
801013a2:	89 04 24             	mov    %eax,(%esp)
801013a5:	e8 4a ff ff ff       	call   801012f4 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013b1:	e9 07 01 00 00       	jmp    801014bd <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b9:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013bf:	85 c0                	test   %eax,%eax
801013c1:	0f 48 c2             	cmovs  %edx,%eax
801013c4:	c1 f8 0c             	sar    $0xc,%eax
801013c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013ca:	c1 ea 03             	shr    $0x3,%edx
801013cd:	01 d0                	add    %edx,%eax
801013cf:	83 c0 03             	add    $0x3,%eax
801013d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801013d6:	8b 45 08             	mov    0x8(%ebp),%eax
801013d9:	89 04 24             	mov    %eax,(%esp)
801013dc:	e8 c5 ed ff ff       	call   801001a6 <bread>
801013e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013eb:	e9 9d 00 00 00       	jmp    8010148d <balloc+0x102>
      m = 1 << (bi % 8);
801013f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013f3:	99                   	cltd   
801013f4:	c1 ea 1d             	shr    $0x1d,%edx
801013f7:	01 d0                	add    %edx,%eax
801013f9:	83 e0 07             	and    $0x7,%eax
801013fc:	29 d0                	sub    %edx,%eax
801013fe:	ba 01 00 00 00       	mov    $0x1,%edx
80101403:	89 c1                	mov    %eax,%ecx
80101405:	d3 e2                	shl    %cl,%edx
80101407:	89 d0                	mov    %edx,%eax
80101409:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010140c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010140f:	8d 50 07             	lea    0x7(%eax),%edx
80101412:	85 c0                	test   %eax,%eax
80101414:	0f 48 c2             	cmovs  %edx,%eax
80101417:	c1 f8 03             	sar    $0x3,%eax
8010141a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010141d:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101422:	0f b6 c0             	movzbl %al,%eax
80101425:	23 45 e8             	and    -0x18(%ebp),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	75 5d                	jne    80101489 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
8010142c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142f:	8d 50 07             	lea    0x7(%eax),%edx
80101432:	85 c0                	test   %eax,%eax
80101434:	0f 48 c2             	cmovs  %edx,%eax
80101437:	c1 f8 03             	sar    $0x3,%eax
8010143a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010143d:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101442:	89 d1                	mov    %edx,%ecx
80101444:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101447:	09 ca                	or     %ecx,%edx
80101449:	89 d1                	mov    %edx,%ecx
8010144b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010144e:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101452:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101455:	89 04 24             	mov    %eax,(%esp)
80101458:	e8 c8 21 00 00       	call   80103625 <log_write>
        brelse(bp);
8010145d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101460:	89 04 24             	mov    %eax,(%esp)
80101463:	e8 af ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101468:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010146e:	01 c2                	add    %eax,%edx
80101470:	8b 45 08             	mov    0x8(%ebp),%eax
80101473:	89 54 24 04          	mov    %edx,0x4(%esp)
80101477:	89 04 24             	mov    %eax,(%esp)
8010147a:	e8 bb fe ff ff       	call   8010133a <bzero>
        return b + bi;
8010147f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101482:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101485:	01 d0                	add    %edx,%eax
80101487:	eb 4e                	jmp    801014d7 <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101489:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010148d:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101494:	7f 15                	jg     801014ab <balloc+0x120>
80101496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101499:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010149c:	01 d0                	add    %edx,%eax
8010149e:	89 c2                	mov    %eax,%edx
801014a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014a3:	39 c2                	cmp    %eax,%edx
801014a5:	0f 82 45 ff ff ff    	jb     801013f0 <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014ae:	89 04 24             	mov    %eax,(%esp)
801014b1:	e8 61 ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014b6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014c3:	39 c2                	cmp    %eax,%edx
801014c5:	0f 82 eb fe ff ff    	jb     801013b6 <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014cb:	c7 04 24 79 84 10 80 	movl   $0x80108479,(%esp)
801014d2:	e8 63 f0 ff ff       	call   8010053a <panic>
}
801014d7:	c9                   	leave  
801014d8:	c3                   	ret    

801014d9 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014d9:	55                   	push   %ebp
801014da:	89 e5                	mov    %esp,%ebp
801014dc:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014df:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801014e6:	8b 45 08             	mov    0x8(%ebp),%eax
801014e9:	89 04 24             	mov    %eax,(%esp)
801014ec:	e8 03 fe ff ff       	call   801012f4 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801014f4:	c1 e8 0c             	shr    $0xc,%eax
801014f7:	89 c2                	mov    %eax,%edx
801014f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014fc:	c1 e8 03             	shr    $0x3,%eax
801014ff:	01 d0                	add    %edx,%eax
80101501:	8d 50 03             	lea    0x3(%eax),%edx
80101504:	8b 45 08             	mov    0x8(%ebp),%eax
80101507:	89 54 24 04          	mov    %edx,0x4(%esp)
8010150b:	89 04 24             	mov    %eax,(%esp)
8010150e:	e8 93 ec ff ff       	call   801001a6 <bread>
80101513:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101516:	8b 45 0c             	mov    0xc(%ebp),%eax
80101519:	25 ff 0f 00 00       	and    $0xfff,%eax
8010151e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101521:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101524:	99                   	cltd   
80101525:	c1 ea 1d             	shr    $0x1d,%edx
80101528:	01 d0                	add    %edx,%eax
8010152a:	83 e0 07             	and    $0x7,%eax
8010152d:	29 d0                	sub    %edx,%eax
8010152f:	ba 01 00 00 00       	mov    $0x1,%edx
80101534:	89 c1                	mov    %eax,%ecx
80101536:	d3 e2                	shl    %cl,%edx
80101538:	89 d0                	mov    %edx,%eax
8010153a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010153d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101540:	8d 50 07             	lea    0x7(%eax),%edx
80101543:	85 c0                	test   %eax,%eax
80101545:	0f 48 c2             	cmovs  %edx,%eax
80101548:	c1 f8 03             	sar    $0x3,%eax
8010154b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010154e:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101553:	0f b6 c0             	movzbl %al,%eax
80101556:	23 45 ec             	and    -0x14(%ebp),%eax
80101559:	85 c0                	test   %eax,%eax
8010155b:	75 0c                	jne    80101569 <bfree+0x90>
    panic("freeing free block");
8010155d:	c7 04 24 8f 84 10 80 	movl   $0x8010848f,(%esp)
80101564:	e8 d1 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
80101569:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156c:	8d 50 07             	lea    0x7(%eax),%edx
8010156f:	85 c0                	test   %eax,%eax
80101571:	0f 48 c2             	cmovs  %edx,%eax
80101574:	c1 f8 03             	sar    $0x3,%eax
80101577:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010157a:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010157f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101582:	f7 d1                	not    %ecx
80101584:	21 ca                	and    %ecx,%edx
80101586:	89 d1                	mov    %edx,%ecx
80101588:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010158b:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010158f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101592:	89 04 24             	mov    %eax,(%esp)
80101595:	e8 8b 20 00 00       	call   80103625 <log_write>
  brelse(bp);
8010159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010159d:	89 04 24             	mov    %eax,(%esp)
801015a0:	e8 72 ec ff ff       	call   80100217 <brelse>
}
801015a5:	c9                   	leave  
801015a6:	c3                   	ret    

801015a7 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015a7:	55                   	push   %ebp
801015a8:	89 e5                	mov    %esp,%ebp
801015aa:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015ad:	c7 44 24 04 a2 84 10 	movl   $0x801084a2,0x4(%esp)
801015b4:	80 
801015b5:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
801015bc:	e8 21 38 00 00       	call   80104de2 <initlock>
}
801015c1:	c9                   	leave  
801015c2:	c3                   	ret    

801015c3 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015c3:	55                   	push   %ebp
801015c4:	89 e5                	mov    %esp,%ebp
801015c6:	83 ec 38             	sub    $0x38,%esp
801015c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801015cc:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015d0:	8b 45 08             	mov    0x8(%ebp),%eax
801015d3:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801015da:	89 04 24             	mov    %eax,(%esp)
801015dd:	e8 12 fd ff ff       	call   801012f4 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015e2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801015e9:	e9 98 00 00 00       	jmp    80101686 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
801015ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	83 c0 02             	add    $0x2,%eax
801015f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801015fb:	8b 45 08             	mov    0x8(%ebp),%eax
801015fe:	89 04 24             	mov    %eax,(%esp)
80101601:	e8 a0 eb ff ff       	call   801001a6 <bread>
80101606:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101609:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010160c:	8d 50 18             	lea    0x18(%eax),%edx
8010160f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101612:	83 e0 07             	and    $0x7,%eax
80101615:	c1 e0 06             	shl    $0x6,%eax
80101618:	01 d0                	add    %edx,%eax
8010161a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010161d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101620:	0f b7 00             	movzwl (%eax),%eax
80101623:	66 85 c0             	test   %ax,%ax
80101626:	75 4f                	jne    80101677 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101628:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010162f:	00 
80101630:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101637:	00 
80101638:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010163b:	89 04 24             	mov    %eax,(%esp)
8010163e:	e8 17 3a 00 00       	call   8010505a <memset>
      dip->type = type;
80101643:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101646:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
8010164a:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010164d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101650:	89 04 24             	mov    %eax,(%esp)
80101653:	e8 cd 1f 00 00       	call   80103625 <log_write>
      brelse(bp);
80101658:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165b:	89 04 24             	mov    %eax,(%esp)
8010165e:	e8 b4 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
80101663:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101666:	89 44 24 04          	mov    %eax,0x4(%esp)
8010166a:	8b 45 08             	mov    0x8(%ebp),%eax
8010166d:	89 04 24             	mov    %eax,(%esp)
80101670:	e8 e5 00 00 00       	call   8010175a <iget>
80101675:	eb 29                	jmp    801016a0 <ialloc+0xdd>
    }
    brelse(bp);
80101677:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010167a:	89 04 24             	mov    %eax,(%esp)
8010167d:	e8 95 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
80101682:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101686:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010168c:	39 c2                	cmp    %eax,%edx
8010168e:	0f 82 5a ff ff ff    	jb     801015ee <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101694:	c7 04 24 a9 84 10 80 	movl   $0x801084a9,(%esp)
8010169b:	e8 9a ee ff ff       	call   8010053a <panic>
}
801016a0:	c9                   	leave  
801016a1:	c3                   	ret    

801016a2 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016a2:	55                   	push   %ebp
801016a3:	89 e5                	mov    %esp,%ebp
801016a5:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016a8:	8b 45 08             	mov    0x8(%ebp),%eax
801016ab:	8b 40 04             	mov    0x4(%eax),%eax
801016ae:	c1 e8 03             	shr    $0x3,%eax
801016b1:	8d 50 02             	lea    0x2(%eax),%edx
801016b4:	8b 45 08             	mov    0x8(%ebp),%eax
801016b7:	8b 00                	mov    (%eax),%eax
801016b9:	89 54 24 04          	mov    %edx,0x4(%esp)
801016bd:	89 04 24             	mov    %eax,(%esp)
801016c0:	e8 e1 ea ff ff       	call   801001a6 <bread>
801016c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016cb:	8d 50 18             	lea    0x18(%eax),%edx
801016ce:	8b 45 08             	mov    0x8(%ebp),%eax
801016d1:	8b 40 04             	mov    0x4(%eax),%eax
801016d4:	83 e0 07             	and    $0x7,%eax
801016d7:	c1 e0 06             	shl    $0x6,%eax
801016da:	01 d0                	add    %edx,%eax
801016dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016df:	8b 45 08             	mov    0x8(%ebp),%eax
801016e2:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016ec:	8b 45 08             	mov    0x8(%ebp),%eax
801016ef:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801016f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f6:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801016fa:	8b 45 08             	mov    0x8(%ebp),%eax
801016fd:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101701:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101704:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101708:	8b 45 08             	mov    0x8(%ebp),%eax
8010170b:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010170f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101712:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101716:	8b 45 08             	mov    0x8(%ebp),%eax
80101719:	8b 50 18             	mov    0x18(%eax),%edx
8010171c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010171f:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101722:	8b 45 08             	mov    0x8(%ebp),%eax
80101725:	8d 50 1c             	lea    0x1c(%eax),%edx
80101728:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010172b:	83 c0 0c             	add    $0xc,%eax
8010172e:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101735:	00 
80101736:	89 54 24 04          	mov    %edx,0x4(%esp)
8010173a:	89 04 24             	mov    %eax,(%esp)
8010173d:	e8 e7 39 00 00       	call   80105129 <memmove>
  log_write(bp);
80101742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101745:	89 04 24             	mov    %eax,(%esp)
80101748:	e8 d8 1e 00 00       	call   80103625 <log_write>
  brelse(bp);
8010174d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101750:	89 04 24             	mov    %eax,(%esp)
80101753:	e8 bf ea ff ff       	call   80100217 <brelse>
}
80101758:	c9                   	leave  
80101759:	c3                   	ret    

8010175a <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010175a:	55                   	push   %ebp
8010175b:	89 e5                	mov    %esp,%ebp
8010175d:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101760:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101767:	e8 97 36 00 00       	call   80104e03 <acquire>

  // Is the inode already cached?
  empty = 0;
8010176c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101773:	c7 45 f4 74 12 11 80 	movl   $0x80111274,-0xc(%ebp)
8010177a:	eb 59                	jmp    801017d5 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010177c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177f:	8b 40 08             	mov    0x8(%eax),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 35                	jle    801017bb <iget+0x61>
80101786:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101789:	8b 00                	mov    (%eax),%eax
8010178b:	3b 45 08             	cmp    0x8(%ebp),%eax
8010178e:	75 2b                	jne    801017bb <iget+0x61>
80101790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101793:	8b 40 04             	mov    0x4(%eax),%eax
80101796:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101799:	75 20                	jne    801017bb <iget+0x61>
      ip->ref++;
8010179b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179e:	8b 40 08             	mov    0x8(%eax),%eax
801017a1:	8d 50 01             	lea    0x1(%eax),%edx
801017a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a7:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017aa:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
801017b1:	e8 af 36 00 00       	call   80104e65 <release>
      return ip;
801017b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b9:	eb 6f                	jmp    8010182a <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017bf:	75 10                	jne    801017d1 <iget+0x77>
801017c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c4:	8b 40 08             	mov    0x8(%eax),%eax
801017c7:	85 c0                	test   %eax,%eax
801017c9:	75 06                	jne    801017d1 <iget+0x77>
      empty = ip;
801017cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ce:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017d1:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017d5:	81 7d f4 14 22 11 80 	cmpl   $0x80112214,-0xc(%ebp)
801017dc:	72 9e                	jb     8010177c <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017e2:	75 0c                	jne    801017f0 <iget+0x96>
    panic("iget: no inodes");
801017e4:	c7 04 24 bb 84 10 80 	movl   $0x801084bb,(%esp)
801017eb:	e8 4a ed ff ff       	call   8010053a <panic>

  ip = empty;
801017f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801017f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f9:	8b 55 08             	mov    0x8(%ebp),%edx
801017fc:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801017fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101801:	8b 55 0c             	mov    0xc(%ebp),%edx
80101804:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010180a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101811:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101814:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010181b:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101822:	e8 3e 36 00 00       	call   80104e65 <release>

  return ip;
80101827:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010182a:	c9                   	leave  
8010182b:	c3                   	ret    

8010182c <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010182c:	55                   	push   %ebp
8010182d:	89 e5                	mov    %esp,%ebp
8010182f:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101832:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101839:	e8 c5 35 00 00       	call   80104e03 <acquire>
  ip->ref++;
8010183e:	8b 45 08             	mov    0x8(%ebp),%eax
80101841:	8b 40 08             	mov    0x8(%eax),%eax
80101844:	8d 50 01             	lea    0x1(%eax),%edx
80101847:	8b 45 08             	mov    0x8(%ebp),%eax
8010184a:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010184d:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101854:	e8 0c 36 00 00       	call   80104e65 <release>
  return ip;
80101859:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010185c:	c9                   	leave  
8010185d:	c3                   	ret    

8010185e <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010185e:	55                   	push   %ebp
8010185f:	89 e5                	mov    %esp,%ebp
80101861:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101864:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101868:	74 0a                	je     80101874 <ilock+0x16>
8010186a:	8b 45 08             	mov    0x8(%ebp),%eax
8010186d:	8b 40 08             	mov    0x8(%eax),%eax
80101870:	85 c0                	test   %eax,%eax
80101872:	7f 0c                	jg     80101880 <ilock+0x22>
    panic("ilock");
80101874:	c7 04 24 cb 84 10 80 	movl   $0x801084cb,(%esp)
8010187b:	e8 ba ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101880:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101887:	e8 77 35 00 00       	call   80104e03 <acquire>
  while(ip->flags & I_BUSY)
8010188c:	eb 13                	jmp    801018a1 <ilock+0x43>
    sleep(ip, &icache.lock);
8010188e:	c7 44 24 04 40 12 11 	movl   $0x80111240,0x4(%esp)
80101895:	80 
80101896:	8b 45 08             	mov    0x8(%ebp),%eax
80101899:	89 04 24             	mov    %eax,(%esp)
8010189c:	e8 95 32 00 00       	call   80104b36 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018a1:	8b 45 08             	mov    0x8(%ebp),%eax
801018a4:	8b 40 0c             	mov    0xc(%eax),%eax
801018a7:	83 e0 01             	and    $0x1,%eax
801018aa:	85 c0                	test   %eax,%eax
801018ac:	75 e0                	jne    8010188e <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018ae:	8b 45 08             	mov    0x8(%ebp),%eax
801018b1:	8b 40 0c             	mov    0xc(%eax),%eax
801018b4:	83 c8 01             	or     $0x1,%eax
801018b7:	89 c2                	mov    %eax,%edx
801018b9:	8b 45 08             	mov    0x8(%ebp),%eax
801018bc:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018bf:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
801018c6:	e8 9a 35 00 00       	call   80104e65 <release>

  if(!(ip->flags & I_VALID)){
801018cb:	8b 45 08             	mov    0x8(%ebp),%eax
801018ce:	8b 40 0c             	mov    0xc(%eax),%eax
801018d1:	83 e0 02             	and    $0x2,%eax
801018d4:	85 c0                	test   %eax,%eax
801018d6:	0f 85 ce 00 00 00    	jne    801019aa <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018dc:	8b 45 08             	mov    0x8(%ebp),%eax
801018df:	8b 40 04             	mov    0x4(%eax),%eax
801018e2:	c1 e8 03             	shr    $0x3,%eax
801018e5:	8d 50 02             	lea    0x2(%eax),%edx
801018e8:	8b 45 08             	mov    0x8(%ebp),%eax
801018eb:	8b 00                	mov    (%eax),%eax
801018ed:	89 54 24 04          	mov    %edx,0x4(%esp)
801018f1:	89 04 24             	mov    %eax,(%esp)
801018f4:	e8 ad e8 ff ff       	call   801001a6 <bread>
801018f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ff:	8d 50 18             	lea    0x18(%eax),%edx
80101902:	8b 45 08             	mov    0x8(%ebp),%eax
80101905:	8b 40 04             	mov    0x4(%eax),%eax
80101908:	83 e0 07             	and    $0x7,%eax
8010190b:	c1 e0 06             	shl    $0x6,%eax
8010190e:	01 d0                	add    %edx,%eax
80101910:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101913:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101916:	0f b7 10             	movzwl (%eax),%edx
80101919:	8b 45 08             	mov    0x8(%ebp),%eax
8010191c:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101920:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101923:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101927:	8b 45 08             	mov    0x8(%ebp),%eax
8010192a:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010192e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101931:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101935:	8b 45 08             	mov    0x8(%ebp),%eax
80101938:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
8010193c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010193f:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101943:	8b 45 08             	mov    0x8(%ebp),%eax
80101946:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
8010194a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010194d:	8b 50 08             	mov    0x8(%eax),%edx
80101950:	8b 45 08             	mov    0x8(%ebp),%eax
80101953:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101956:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101959:	8d 50 0c             	lea    0xc(%eax),%edx
8010195c:	8b 45 08             	mov    0x8(%ebp),%eax
8010195f:	83 c0 1c             	add    $0x1c,%eax
80101962:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101969:	00 
8010196a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010196e:	89 04 24             	mov    %eax,(%esp)
80101971:	e8 b3 37 00 00       	call   80105129 <memmove>
    brelse(bp);
80101976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101979:	89 04 24             	mov    %eax,(%esp)
8010197c:	e8 96 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
80101981:	8b 45 08             	mov    0x8(%ebp),%eax
80101984:	8b 40 0c             	mov    0xc(%eax),%eax
80101987:	83 c8 02             	or     $0x2,%eax
8010198a:	89 c2                	mov    %eax,%edx
8010198c:	8b 45 08             	mov    0x8(%ebp),%eax
8010198f:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101992:	8b 45 08             	mov    0x8(%ebp),%eax
80101995:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101999:	66 85 c0             	test   %ax,%ax
8010199c:	75 0c                	jne    801019aa <ilock+0x14c>
      panic("ilock: no type");
8010199e:	c7 04 24 d1 84 10 80 	movl   $0x801084d1,(%esp)
801019a5:	e8 90 eb ff ff       	call   8010053a <panic>
  }
}
801019aa:	c9                   	leave  
801019ab:	c3                   	ret    

801019ac <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019ac:	55                   	push   %ebp
801019ad:	89 e5                	mov    %esp,%ebp
801019af:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019b6:	74 17                	je     801019cf <iunlock+0x23>
801019b8:	8b 45 08             	mov    0x8(%ebp),%eax
801019bb:	8b 40 0c             	mov    0xc(%eax),%eax
801019be:	83 e0 01             	and    $0x1,%eax
801019c1:	85 c0                	test   %eax,%eax
801019c3:	74 0a                	je     801019cf <iunlock+0x23>
801019c5:	8b 45 08             	mov    0x8(%ebp),%eax
801019c8:	8b 40 08             	mov    0x8(%eax),%eax
801019cb:	85 c0                	test   %eax,%eax
801019cd:	7f 0c                	jg     801019db <iunlock+0x2f>
    panic("iunlock");
801019cf:	c7 04 24 e0 84 10 80 	movl   $0x801084e0,(%esp)
801019d6:	e8 5f eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019db:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
801019e2:	e8 1c 34 00 00       	call   80104e03 <acquire>
  ip->flags &= ~I_BUSY;
801019e7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ea:	8b 40 0c             	mov    0xc(%eax),%eax
801019ed:	83 e0 fe             	and    $0xfffffffe,%eax
801019f0:	89 c2                	mov    %eax,%edx
801019f2:	8b 45 08             	mov    0x8(%ebp),%eax
801019f5:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
801019f8:	8b 45 08             	mov    0x8(%ebp),%eax
801019fb:	89 04 24             	mov    %eax,(%esp)
801019fe:	e8 0c 32 00 00       	call   80104c0f <wakeup>
  release(&icache.lock);
80101a03:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101a0a:	e8 56 34 00 00       	call   80104e65 <release>
}
80101a0f:	c9                   	leave  
80101a10:	c3                   	ret    

80101a11 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a11:	55                   	push   %ebp
80101a12:	89 e5                	mov    %esp,%ebp
80101a14:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a17:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101a1e:	e8 e0 33 00 00       	call   80104e03 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a23:	8b 45 08             	mov    0x8(%ebp),%eax
80101a26:	8b 40 08             	mov    0x8(%eax),%eax
80101a29:	83 f8 01             	cmp    $0x1,%eax
80101a2c:	0f 85 93 00 00 00    	jne    80101ac5 <iput+0xb4>
80101a32:	8b 45 08             	mov    0x8(%ebp),%eax
80101a35:	8b 40 0c             	mov    0xc(%eax),%eax
80101a38:	83 e0 02             	and    $0x2,%eax
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	0f 84 82 00 00 00    	je     80101ac5 <iput+0xb4>
80101a43:	8b 45 08             	mov    0x8(%ebp),%eax
80101a46:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a4a:	66 85 c0             	test   %ax,%ax
80101a4d:	75 76                	jne    80101ac5 <iput+0xb4>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101a4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a52:	8b 40 0c             	mov    0xc(%eax),%eax
80101a55:	83 e0 01             	and    $0x1,%eax
80101a58:	85 c0                	test   %eax,%eax
80101a5a:	74 0c                	je     80101a68 <iput+0x57>
      panic("iput busy");
80101a5c:	c7 04 24 e8 84 10 80 	movl   $0x801084e8,(%esp)
80101a63:	e8 d2 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a68:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6b:	8b 40 0c             	mov    0xc(%eax),%eax
80101a6e:	83 c8 01             	or     $0x1,%eax
80101a71:	89 c2                	mov    %eax,%edx
80101a73:	8b 45 08             	mov    0x8(%ebp),%eax
80101a76:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a79:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101a80:	e8 e0 33 00 00       	call   80104e65 <release>
    itrunc(ip);
80101a85:	8b 45 08             	mov    0x8(%ebp),%eax
80101a88:	89 04 24             	mov    %eax,(%esp)
80101a8b:	e8 7d 01 00 00       	call   80101c0d <itrunc>
    ip->type = 0;
80101a90:	8b 45 08             	mov    0x8(%ebp),%eax
80101a93:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	89 04 24             	mov    %eax,(%esp)
80101a9f:	e8 fe fb ff ff       	call   801016a2 <iupdate>
    acquire(&icache.lock);
80101aa4:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101aab:	e8 53 33 00 00       	call   80104e03 <acquire>
    ip->flags = 0;
80101ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101aba:	8b 45 08             	mov    0x8(%ebp),%eax
80101abd:	89 04 24             	mov    %eax,(%esp)
80101ac0:	e8 4a 31 00 00       	call   80104c0f <wakeup>
  }
  ip->ref--;
80101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac8:	8b 40 08             	mov    0x8(%eax),%eax
80101acb:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ace:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad1:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ad4:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101adb:	e8 85 33 00 00       	call   80104e65 <release>
}
80101ae0:	c9                   	leave  
80101ae1:	c3                   	ret    

80101ae2 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101ae2:	55                   	push   %ebp
80101ae3:	89 e5                	mov    %esp,%ebp
80101ae5:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aeb:	89 04 24             	mov    %eax,(%esp)
80101aee:	e8 b9 fe ff ff       	call   801019ac <iunlock>
  iput(ip);
80101af3:	8b 45 08             	mov    0x8(%ebp),%eax
80101af6:	89 04 24             	mov    %eax,(%esp)
80101af9:	e8 13 ff ff ff       	call   80101a11 <iput>
}
80101afe:	c9                   	leave  
80101aff:	c3                   	ret    

80101b00 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	53                   	push   %ebx
80101b04:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b07:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b0b:	77 3e                	ja     80101b4b <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b10:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b13:	83 c2 04             	add    $0x4,%edx
80101b16:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b21:	75 20                	jne    80101b43 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b23:	8b 45 08             	mov    0x8(%ebp),%eax
80101b26:	8b 00                	mov    (%eax),%eax
80101b28:	89 04 24             	mov    %eax,(%esp)
80101b2b:	e8 5b f8 ff ff       	call   8010138b <balloc>
80101b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b33:	8b 45 08             	mov    0x8(%ebp),%eax
80101b36:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b39:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b3f:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b46:	e9 bc 00 00 00       	jmp    80101c07 <bmap+0x107>
  }
  bn -= NDIRECT;
80101b4b:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b4f:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b53:	0f 87 a2 00 00 00    	ja     80101bfb <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b59:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5c:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b66:	75 19                	jne    80101b81 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b68:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6b:	8b 00                	mov    (%eax),%eax
80101b6d:	89 04 24             	mov    %eax,(%esp)
80101b70:	e8 16 f8 ff ff       	call   8010138b <balloc>
80101b75:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b78:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b7e:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b81:	8b 45 08             	mov    0x8(%ebp),%eax
80101b84:	8b 00                	mov    (%eax),%eax
80101b86:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b89:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b8d:	89 04 24             	mov    %eax,(%esp)
80101b90:	e8 11 e6 ff ff       	call   801001a6 <bread>
80101b95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b9b:	83 c0 18             	add    $0x18,%eax
80101b9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ba4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bae:	01 d0                	add    %edx,%eax
80101bb0:	8b 00                	mov    (%eax),%eax
80101bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bb9:	75 30                	jne    80101beb <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bbe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bc8:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bce:	8b 00                	mov    (%eax),%eax
80101bd0:	89 04 24             	mov    %eax,(%esp)
80101bd3:	e8 b3 f7 ff ff       	call   8010138b <balloc>
80101bd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bde:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101be3:	89 04 24             	mov    %eax,(%esp)
80101be6:	e8 3a 1a 00 00       	call   80103625 <log_write>
    }
    brelse(bp);
80101beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bee:	89 04 24             	mov    %eax,(%esp)
80101bf1:	e8 21 e6 ff ff       	call   80100217 <brelse>
    return addr;
80101bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bf9:	eb 0c                	jmp    80101c07 <bmap+0x107>
  }

  panic("bmap: out of range");
80101bfb:	c7 04 24 f2 84 10 80 	movl   $0x801084f2,(%esp)
80101c02:	e8 33 e9 ff ff       	call   8010053a <panic>
}
80101c07:	83 c4 24             	add    $0x24,%esp
80101c0a:	5b                   	pop    %ebx
80101c0b:	5d                   	pop    %ebp
80101c0c:	c3                   	ret    

80101c0d <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c0d:	55                   	push   %ebp
80101c0e:	89 e5                	mov    %esp,%ebp
80101c10:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c1a:	eb 44                	jmp    80101c60 <itrunc+0x53>
    if(ip->addrs[i]){
80101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c22:	83 c2 04             	add    $0x4,%edx
80101c25:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c29:	85 c0                	test   %eax,%eax
80101c2b:	74 2f                	je     80101c5c <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c33:	83 c2 04             	add    $0x4,%edx
80101c36:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3d:	8b 00                	mov    (%eax),%eax
80101c3f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c43:	89 04 24             	mov    %eax,(%esp)
80101c46:	e8 8e f8 ff ff       	call   801014d9 <bfree>
      ip->addrs[i] = 0;
80101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c51:	83 c2 04             	add    $0x4,%edx
80101c54:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c5b:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c60:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c64:	7e b6                	jle    80101c1c <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c66:	8b 45 08             	mov    0x8(%ebp),%eax
80101c69:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c6c:	85 c0                	test   %eax,%eax
80101c6e:	0f 84 9b 00 00 00    	je     80101d0f <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c74:	8b 45 08             	mov    0x8(%ebp),%eax
80101c77:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7d:	8b 00                	mov    (%eax),%eax
80101c7f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c83:	89 04 24             	mov    %eax,(%esp)
80101c86:	e8 1b e5 ff ff       	call   801001a6 <bread>
80101c8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c91:	83 c0 18             	add    $0x18,%eax
80101c94:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101c97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101c9e:	eb 3b                	jmp    80101cdb <itrunc+0xce>
      if(a[j])
80101ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101caa:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cad:	01 d0                	add    %edx,%eax
80101caf:	8b 00                	mov    (%eax),%eax
80101cb1:	85 c0                	test   %eax,%eax
80101cb3:	74 22                	je     80101cd7 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cc2:	01 d0                	add    %edx,%eax
80101cc4:	8b 10                	mov    (%eax),%edx
80101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc9:	8b 00                	mov    (%eax),%eax
80101ccb:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ccf:	89 04 24             	mov    %eax,(%esp)
80101cd2:	e8 02 f8 ff ff       	call   801014d9 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101cd7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cde:	83 f8 7f             	cmp    $0x7f,%eax
80101ce1:	76 bd                	jbe    80101ca0 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ce6:	89 04 24             	mov    %eax,(%esp)
80101ce9:	e8 29 e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101cee:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf1:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf7:	8b 00                	mov    (%eax),%eax
80101cf9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cfd:	89 04 24             	mov    %eax,(%esp)
80101d00:	e8 d4 f7 ff ff       	call   801014d9 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d05:	8b 45 08             	mov    0x8(%ebp),%eax
80101d08:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d12:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d19:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1c:	89 04 24             	mov    %eax,(%esp)
80101d1f:	e8 7e f9 ff ff       	call   801016a2 <iupdate>
}
80101d24:	c9                   	leave  
80101d25:	c3                   	ret    

80101d26 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d26:	55                   	push   %ebp
80101d27:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	8b 00                	mov    (%eax),%eax
80101d2e:	89 c2                	mov    %eax,%edx
80101d30:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d33:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d36:	8b 45 08             	mov    0x8(%ebp),%eax
80101d39:	8b 50 04             	mov    0x4(%eax),%edx
80101d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d3f:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d42:	8b 45 08             	mov    0x8(%ebp),%eax
80101d45:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d49:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d4c:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d52:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d56:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d59:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d60:	8b 50 18             	mov    0x18(%eax),%edx
80101d63:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d66:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d69:	5d                   	pop    %ebp
80101d6a:	c3                   	ret    

80101d6b <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d6b:	55                   	push   %ebp
80101d6c:	89 e5                	mov    %esp,%ebp
80101d6e:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d71:	8b 45 08             	mov    0x8(%ebp),%eax
80101d74:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d78:	66 83 f8 03          	cmp    $0x3,%ax
80101d7c:	75 60                	jne    80101dde <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d81:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d85:	66 85 c0             	test   %ax,%ax
80101d88:	78 20                	js     80101daa <readi+0x3f>
80101d8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d91:	66 83 f8 09          	cmp    $0x9,%ax
80101d95:	7f 13                	jg     80101daa <readi+0x3f>
80101d97:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d9e:	98                   	cwtl   
80101d9f:	8b 04 c5 e0 11 11 80 	mov    -0x7feeee20(,%eax,8),%eax
80101da6:	85 c0                	test   %eax,%eax
80101da8:	75 0a                	jne    80101db4 <readi+0x49>
      return -1;
80101daa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101daf:	e9 19 01 00 00       	jmp    80101ecd <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101db4:	8b 45 08             	mov    0x8(%ebp),%eax
80101db7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dbb:	98                   	cwtl   
80101dbc:	8b 04 c5 e0 11 11 80 	mov    -0x7feeee20(,%eax,8),%eax
80101dc3:	8b 55 14             	mov    0x14(%ebp),%edx
80101dc6:	89 54 24 08          	mov    %edx,0x8(%esp)
80101dca:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dcd:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dd1:	8b 55 08             	mov    0x8(%ebp),%edx
80101dd4:	89 14 24             	mov    %edx,(%esp)
80101dd7:	ff d0                	call   *%eax
80101dd9:	e9 ef 00 00 00       	jmp    80101ecd <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101dde:	8b 45 08             	mov    0x8(%ebp),%eax
80101de1:	8b 40 18             	mov    0x18(%eax),%eax
80101de4:	3b 45 10             	cmp    0x10(%ebp),%eax
80101de7:	72 0d                	jb     80101df6 <readi+0x8b>
80101de9:	8b 45 14             	mov    0x14(%ebp),%eax
80101dec:	8b 55 10             	mov    0x10(%ebp),%edx
80101def:	01 d0                	add    %edx,%eax
80101df1:	3b 45 10             	cmp    0x10(%ebp),%eax
80101df4:	73 0a                	jae    80101e00 <readi+0x95>
    return -1;
80101df6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dfb:	e9 cd 00 00 00       	jmp    80101ecd <readi+0x162>
  if(off + n > ip->size)
80101e00:	8b 45 14             	mov    0x14(%ebp),%eax
80101e03:	8b 55 10             	mov    0x10(%ebp),%edx
80101e06:	01 c2                	add    %eax,%edx
80101e08:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0b:	8b 40 18             	mov    0x18(%eax),%eax
80101e0e:	39 c2                	cmp    %eax,%edx
80101e10:	76 0c                	jbe    80101e1e <readi+0xb3>
    n = ip->size - off;
80101e12:	8b 45 08             	mov    0x8(%ebp),%eax
80101e15:	8b 40 18             	mov    0x18(%eax),%eax
80101e18:	2b 45 10             	sub    0x10(%ebp),%eax
80101e1b:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e25:	e9 94 00 00 00       	jmp    80101ebe <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e2a:	8b 45 10             	mov    0x10(%ebp),%eax
80101e2d:	c1 e8 09             	shr    $0x9,%eax
80101e30:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e34:	8b 45 08             	mov    0x8(%ebp),%eax
80101e37:	89 04 24             	mov    %eax,(%esp)
80101e3a:	e8 c1 fc ff ff       	call   80101b00 <bmap>
80101e3f:	8b 55 08             	mov    0x8(%ebp),%edx
80101e42:	8b 12                	mov    (%edx),%edx
80101e44:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e48:	89 14 24             	mov    %edx,(%esp)
80101e4b:	e8 56 e3 ff ff       	call   801001a6 <bread>
80101e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e53:	8b 45 10             	mov    0x10(%ebp),%eax
80101e56:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e5b:	89 c2                	mov    %eax,%edx
80101e5d:	b8 00 02 00 00       	mov    $0x200,%eax
80101e62:	29 d0                	sub    %edx,%eax
80101e64:	89 c2                	mov    %eax,%edx
80101e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e69:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e6c:	29 c1                	sub    %eax,%ecx
80101e6e:	89 c8                	mov    %ecx,%eax
80101e70:	39 c2                	cmp    %eax,%edx
80101e72:	0f 46 c2             	cmovbe %edx,%eax
80101e75:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e78:	8b 45 10             	mov    0x10(%ebp),%eax
80101e7b:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e80:	8d 50 10             	lea    0x10(%eax),%edx
80101e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e86:	01 d0                	add    %edx,%eax
80101e88:	8d 50 08             	lea    0x8(%eax),%edx
80101e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e8e:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e92:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e99:	89 04 24             	mov    %eax,(%esp)
80101e9c:	e8 88 32 00 00       	call   80105129 <memmove>
    brelse(bp);
80101ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ea4:	89 04 24             	mov    %eax,(%esp)
80101ea7:	e8 6b e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101eac:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eaf:	01 45 f4             	add    %eax,-0xc(%ebp)
80101eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eb5:	01 45 10             	add    %eax,0x10(%ebp)
80101eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ebb:	01 45 0c             	add    %eax,0xc(%ebp)
80101ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ec1:	3b 45 14             	cmp    0x14(%ebp),%eax
80101ec4:	0f 82 60 ff ff ff    	jb     80101e2a <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101eca:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101ecd:	c9                   	leave  
80101ece:	c3                   	ret    

80101ecf <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ecf:	55                   	push   %ebp
80101ed0:	89 e5                	mov    %esp,%ebp
80101ed2:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ed5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101edc:	66 83 f8 03          	cmp    $0x3,%ax
80101ee0:	75 60                	jne    80101f42 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ee9:	66 85 c0             	test   %ax,%ax
80101eec:	78 20                	js     80101f0e <writei+0x3f>
80101eee:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ef5:	66 83 f8 09          	cmp    $0x9,%ax
80101ef9:	7f 13                	jg     80101f0e <writei+0x3f>
80101efb:	8b 45 08             	mov    0x8(%ebp),%eax
80101efe:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f02:	98                   	cwtl   
80101f03:	8b 04 c5 e4 11 11 80 	mov    -0x7feeee1c(,%eax,8),%eax
80101f0a:	85 c0                	test   %eax,%eax
80101f0c:	75 0a                	jne    80101f18 <writei+0x49>
      return -1;
80101f0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f13:	e9 44 01 00 00       	jmp    8010205c <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f1f:	98                   	cwtl   
80101f20:	8b 04 c5 e4 11 11 80 	mov    -0x7feeee1c(,%eax,8),%eax
80101f27:	8b 55 14             	mov    0x14(%ebp),%edx
80101f2a:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f2e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f31:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f35:	8b 55 08             	mov    0x8(%ebp),%edx
80101f38:	89 14 24             	mov    %edx,(%esp)
80101f3b:	ff d0                	call   *%eax
80101f3d:	e9 1a 01 00 00       	jmp    8010205c <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f42:	8b 45 08             	mov    0x8(%ebp),%eax
80101f45:	8b 40 18             	mov    0x18(%eax),%eax
80101f48:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f4b:	72 0d                	jb     80101f5a <writei+0x8b>
80101f4d:	8b 45 14             	mov    0x14(%ebp),%eax
80101f50:	8b 55 10             	mov    0x10(%ebp),%edx
80101f53:	01 d0                	add    %edx,%eax
80101f55:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f58:	73 0a                	jae    80101f64 <writei+0x95>
    return -1;
80101f5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f5f:	e9 f8 00 00 00       	jmp    8010205c <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101f64:	8b 45 14             	mov    0x14(%ebp),%eax
80101f67:	8b 55 10             	mov    0x10(%ebp),%edx
80101f6a:	01 d0                	add    %edx,%eax
80101f6c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f71:	76 0a                	jbe    80101f7d <writei+0xae>
    return -1;
80101f73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f78:	e9 df 00 00 00       	jmp    8010205c <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f84:	e9 9f 00 00 00       	jmp    80102028 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f89:	8b 45 10             	mov    0x10(%ebp),%eax
80101f8c:	c1 e8 09             	shr    $0x9,%eax
80101f8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f93:	8b 45 08             	mov    0x8(%ebp),%eax
80101f96:	89 04 24             	mov    %eax,(%esp)
80101f99:	e8 62 fb ff ff       	call   80101b00 <bmap>
80101f9e:	8b 55 08             	mov    0x8(%ebp),%edx
80101fa1:	8b 12                	mov    (%edx),%edx
80101fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fa7:	89 14 24             	mov    %edx,(%esp)
80101faa:	e8 f7 e1 ff ff       	call   801001a6 <bread>
80101faf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fb2:	8b 45 10             	mov    0x10(%ebp),%eax
80101fb5:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fba:	89 c2                	mov    %eax,%edx
80101fbc:	b8 00 02 00 00       	mov    $0x200,%eax
80101fc1:	29 d0                	sub    %edx,%eax
80101fc3:	89 c2                	mov    %eax,%edx
80101fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fc8:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fcb:	29 c1                	sub    %eax,%ecx
80101fcd:	89 c8                	mov    %ecx,%eax
80101fcf:	39 c2                	cmp    %eax,%edx
80101fd1:	0f 46 c2             	cmovbe %edx,%eax
80101fd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fd7:	8b 45 10             	mov    0x10(%ebp),%eax
80101fda:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fdf:	8d 50 10             	lea    0x10(%eax),%edx
80101fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fe5:	01 d0                	add    %edx,%eax
80101fe7:	8d 50 08             	lea    0x8(%eax),%edx
80101fea:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fed:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ff8:	89 14 24             	mov    %edx,(%esp)
80101ffb:	e8 29 31 00 00       	call   80105129 <memmove>
    log_write(bp);
80102000:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102003:	89 04 24             	mov    %eax,(%esp)
80102006:	e8 1a 16 00 00       	call   80103625 <log_write>
    brelse(bp);
8010200b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010200e:	89 04 24             	mov    %eax,(%esp)
80102011:	e8 01 e2 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102016:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102019:	01 45 f4             	add    %eax,-0xc(%ebp)
8010201c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010201f:	01 45 10             	add    %eax,0x10(%ebp)
80102022:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102025:	01 45 0c             	add    %eax,0xc(%ebp)
80102028:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010202b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010202e:	0f 82 55 ff ff ff    	jb     80101f89 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102034:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102038:	74 1f                	je     80102059 <writei+0x18a>
8010203a:	8b 45 08             	mov    0x8(%ebp),%eax
8010203d:	8b 40 18             	mov    0x18(%eax),%eax
80102040:	3b 45 10             	cmp    0x10(%ebp),%eax
80102043:	73 14                	jae    80102059 <writei+0x18a>
    ip->size = off;
80102045:	8b 45 08             	mov    0x8(%ebp),%eax
80102048:	8b 55 10             	mov    0x10(%ebp),%edx
8010204b:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010204e:	8b 45 08             	mov    0x8(%ebp),%eax
80102051:	89 04 24             	mov    %eax,(%esp)
80102054:	e8 49 f6 ff ff       	call   801016a2 <iupdate>
  }
  return n;
80102059:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010205c:	c9                   	leave  
8010205d:	c3                   	ret    

8010205e <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010205e:	55                   	push   %ebp
8010205f:	89 e5                	mov    %esp,%ebp
80102061:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102064:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010206b:	00 
8010206c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010206f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102073:	8b 45 08             	mov    0x8(%ebp),%eax
80102076:	89 04 24             	mov    %eax,(%esp)
80102079:	e8 4e 31 00 00       	call   801051cc <strncmp>
}
8010207e:	c9                   	leave  
8010207f:	c3                   	ret    

80102080 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102086:	8b 45 08             	mov    0x8(%ebp),%eax
80102089:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010208d:	66 83 f8 01          	cmp    $0x1,%ax
80102091:	74 0c                	je     8010209f <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102093:	c7 04 24 05 85 10 80 	movl   $0x80108505,(%esp)
8010209a:	e8 9b e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010209f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020a6:	e9 88 00 00 00       	jmp    80102133 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ab:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020b2:	00 
801020b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020b6:	89 44 24 08          	mov    %eax,0x8(%esp)
801020ba:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801020c1:	8b 45 08             	mov    0x8(%ebp),%eax
801020c4:	89 04 24             	mov    %eax,(%esp)
801020c7:	e8 9f fc ff ff       	call   80101d6b <readi>
801020cc:	83 f8 10             	cmp    $0x10,%eax
801020cf:	74 0c                	je     801020dd <dirlookup+0x5d>
      panic("dirlink read");
801020d1:	c7 04 24 17 85 10 80 	movl   $0x80108517,(%esp)
801020d8:	e8 5d e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801020dd:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020e1:	66 85 c0             	test   %ax,%ax
801020e4:	75 02                	jne    801020e8 <dirlookup+0x68>
      continue;
801020e6:	eb 47                	jmp    8010212f <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
801020e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020eb:	83 c0 02             	add    $0x2,%eax
801020ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801020f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801020f5:	89 04 24             	mov    %eax,(%esp)
801020f8:	e8 61 ff ff ff       	call   8010205e <namecmp>
801020fd:	85 c0                	test   %eax,%eax
801020ff:	75 2e                	jne    8010212f <dirlookup+0xaf>
      // entry matches path element
      if(poff)
80102101:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102105:	74 08                	je     8010210f <dirlookup+0x8f>
        *poff = off;
80102107:	8b 45 10             	mov    0x10(%ebp),%eax
8010210a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010210d:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010210f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102113:	0f b7 c0             	movzwl %ax,%eax
80102116:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102119:	8b 45 08             	mov    0x8(%ebp),%eax
8010211c:	8b 00                	mov    (%eax),%eax
8010211e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102121:	89 54 24 04          	mov    %edx,0x4(%esp)
80102125:	89 04 24             	mov    %eax,(%esp)
80102128:	e8 2d f6 ff ff       	call   8010175a <iget>
8010212d:	eb 18                	jmp    80102147 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010212f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102133:	8b 45 08             	mov    0x8(%ebp),%eax
80102136:	8b 40 18             	mov    0x18(%eax),%eax
80102139:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010213c:	0f 87 69 ff ff ff    	ja     801020ab <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102142:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102147:	c9                   	leave  
80102148:	c3                   	ret    

80102149 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102149:	55                   	push   %ebp
8010214a:	89 e5                	mov    %esp,%ebp
8010214c:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010214f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102156:	00 
80102157:	8b 45 0c             	mov    0xc(%ebp),%eax
8010215a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010215e:	8b 45 08             	mov    0x8(%ebp),%eax
80102161:	89 04 24             	mov    %eax,(%esp)
80102164:	e8 17 ff ff ff       	call   80102080 <dirlookup>
80102169:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010216c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102170:	74 15                	je     80102187 <dirlink+0x3e>
    iput(ip);
80102172:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102175:	89 04 24             	mov    %eax,(%esp)
80102178:	e8 94 f8 ff ff       	call   80101a11 <iput>
    return -1;
8010217d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102182:	e9 b7 00 00 00       	jmp    8010223e <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102187:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010218e:	eb 46                	jmp    801021d6 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102193:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010219a:	00 
8010219b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010219f:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801021a6:	8b 45 08             	mov    0x8(%ebp),%eax
801021a9:	89 04 24             	mov    %eax,(%esp)
801021ac:	e8 ba fb ff ff       	call   80101d6b <readi>
801021b1:	83 f8 10             	cmp    $0x10,%eax
801021b4:	74 0c                	je     801021c2 <dirlink+0x79>
      panic("dirlink read");
801021b6:	c7 04 24 17 85 10 80 	movl   $0x80108517,(%esp)
801021bd:	e8 78 e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021c2:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021c6:	66 85 c0             	test   %ax,%ax
801021c9:	75 02                	jne    801021cd <dirlink+0x84>
      break;
801021cb:	eb 16                	jmp    801021e3 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021d0:	83 c0 10             	add    $0x10,%eax
801021d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021d9:	8b 45 08             	mov    0x8(%ebp),%eax
801021dc:	8b 40 18             	mov    0x18(%eax),%eax
801021df:	39 c2                	cmp    %eax,%edx
801021e1:	72 ad                	jb     80102190 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801021e3:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021ea:	00 
801021eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801021ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801021f2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021f5:	83 c0 02             	add    $0x2,%eax
801021f8:	89 04 24             	mov    %eax,(%esp)
801021fb:	e8 22 30 00 00       	call   80105222 <strncpy>
  de.inum = inum;
80102200:	8b 45 10             	mov    0x10(%ebp),%eax
80102203:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102207:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010220a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102211:	00 
80102212:	89 44 24 08          	mov    %eax,0x8(%esp)
80102216:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102219:	89 44 24 04          	mov    %eax,0x4(%esp)
8010221d:	8b 45 08             	mov    0x8(%ebp),%eax
80102220:	89 04 24             	mov    %eax,(%esp)
80102223:	e8 a7 fc ff ff       	call   80101ecf <writei>
80102228:	83 f8 10             	cmp    $0x10,%eax
8010222b:	74 0c                	je     80102239 <dirlink+0xf0>
    panic("dirlink");
8010222d:	c7 04 24 24 85 10 80 	movl   $0x80108524,(%esp)
80102234:	e8 01 e3 ff ff       	call   8010053a <panic>
  
  return 0;
80102239:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010223e:	c9                   	leave  
8010223f:	c3                   	ret    

80102240 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102246:	eb 04                	jmp    8010224c <skipelem+0xc>
    path++;
80102248:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010224c:	8b 45 08             	mov    0x8(%ebp),%eax
8010224f:	0f b6 00             	movzbl (%eax),%eax
80102252:	3c 2f                	cmp    $0x2f,%al
80102254:	74 f2                	je     80102248 <skipelem+0x8>
    path++;
  if(*path == 0)
80102256:	8b 45 08             	mov    0x8(%ebp),%eax
80102259:	0f b6 00             	movzbl (%eax),%eax
8010225c:	84 c0                	test   %al,%al
8010225e:	75 0a                	jne    8010226a <skipelem+0x2a>
    return 0;
80102260:	b8 00 00 00 00       	mov    $0x0,%eax
80102265:	e9 86 00 00 00       	jmp    801022f0 <skipelem+0xb0>
  s = path;
8010226a:	8b 45 08             	mov    0x8(%ebp),%eax
8010226d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102270:	eb 04                	jmp    80102276 <skipelem+0x36>
    path++;
80102272:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102276:	8b 45 08             	mov    0x8(%ebp),%eax
80102279:	0f b6 00             	movzbl (%eax),%eax
8010227c:	3c 2f                	cmp    $0x2f,%al
8010227e:	74 0a                	je     8010228a <skipelem+0x4a>
80102280:	8b 45 08             	mov    0x8(%ebp),%eax
80102283:	0f b6 00             	movzbl (%eax),%eax
80102286:	84 c0                	test   %al,%al
80102288:	75 e8                	jne    80102272 <skipelem+0x32>
    path++;
  len = path - s;
8010228a:	8b 55 08             	mov    0x8(%ebp),%edx
8010228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102290:	29 c2                	sub    %eax,%edx
80102292:	89 d0                	mov    %edx,%eax
80102294:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102297:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010229b:	7e 1c                	jle    801022b9 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
8010229d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022a4:	00 
801022a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801022ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801022af:	89 04 24             	mov    %eax,(%esp)
801022b2:	e8 72 2e 00 00       	call   80105129 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022b7:	eb 2a                	jmp    801022e3 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022bc:	89 44 24 08          	mov    %eax,0x8(%esp)
801022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801022ca:	89 04 24             	mov    %eax,(%esp)
801022cd:	e8 57 2e 00 00       	call   80105129 <memmove>
    name[len] = 0;
801022d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801022d8:	01 d0                	add    %edx,%eax
801022da:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022dd:	eb 04                	jmp    801022e3 <skipelem+0xa3>
    path++;
801022df:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022e3:	8b 45 08             	mov    0x8(%ebp),%eax
801022e6:	0f b6 00             	movzbl (%eax),%eax
801022e9:	3c 2f                	cmp    $0x2f,%al
801022eb:	74 f2                	je     801022df <skipelem+0x9f>
    path++;
  return path;
801022ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022f0:	c9                   	leave  
801022f1:	c3                   	ret    

801022f2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801022f2:	55                   	push   %ebp
801022f3:	89 e5                	mov    %esp,%ebp
801022f5:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801022f8:	8b 45 08             	mov    0x8(%ebp),%eax
801022fb:	0f b6 00             	movzbl (%eax),%eax
801022fe:	3c 2f                	cmp    $0x2f,%al
80102300:	75 1c                	jne    8010231e <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102302:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102309:	00 
8010230a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102311:	e8 44 f4 ff ff       	call   8010175a <iget>
80102316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102319:	e9 af 00 00 00       	jmp    801023cd <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010231e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102324:	8b 40 68             	mov    0x68(%eax),%eax
80102327:	89 04 24             	mov    %eax,(%esp)
8010232a:	e8 fd f4 ff ff       	call   8010182c <idup>
8010232f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102332:	e9 96 00 00 00       	jmp    801023cd <namex+0xdb>
    ilock(ip);
80102337:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010233a:	89 04 24             	mov    %eax,(%esp)
8010233d:	e8 1c f5 ff ff       	call   8010185e <ilock>
    if(ip->type != T_DIR){
80102342:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102345:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102349:	66 83 f8 01          	cmp    $0x1,%ax
8010234d:	74 15                	je     80102364 <namex+0x72>
      iunlockput(ip);
8010234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102352:	89 04 24             	mov    %eax,(%esp)
80102355:	e8 88 f7 ff ff       	call   80101ae2 <iunlockput>
      return 0;
8010235a:	b8 00 00 00 00       	mov    $0x0,%eax
8010235f:	e9 a3 00 00 00       	jmp    80102407 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
80102364:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102368:	74 1d                	je     80102387 <namex+0x95>
8010236a:	8b 45 08             	mov    0x8(%ebp),%eax
8010236d:	0f b6 00             	movzbl (%eax),%eax
80102370:	84 c0                	test   %al,%al
80102372:	75 13                	jne    80102387 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
80102374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102377:	89 04 24             	mov    %eax,(%esp)
8010237a:	e8 2d f6 ff ff       	call   801019ac <iunlock>
      return ip;
8010237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102382:	e9 80 00 00 00       	jmp    80102407 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102387:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010238e:	00 
8010238f:	8b 45 10             	mov    0x10(%ebp),%eax
80102392:	89 44 24 04          	mov    %eax,0x4(%esp)
80102396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102399:	89 04 24             	mov    %eax,(%esp)
8010239c:	e8 df fc ff ff       	call   80102080 <dirlookup>
801023a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023a8:	75 12                	jne    801023bc <namex+0xca>
      iunlockput(ip);
801023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ad:	89 04 24             	mov    %eax,(%esp)
801023b0:	e8 2d f7 ff ff       	call   80101ae2 <iunlockput>
      return 0;
801023b5:	b8 00 00 00 00       	mov    $0x0,%eax
801023ba:	eb 4b                	jmp    80102407 <namex+0x115>
    }
    iunlockput(ip);
801023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023bf:	89 04 24             	mov    %eax,(%esp)
801023c2:	e8 1b f7 ff ff       	call   80101ae2 <iunlockput>
    ip = next;
801023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023cd:	8b 45 10             	mov    0x10(%ebp),%eax
801023d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801023d4:	8b 45 08             	mov    0x8(%ebp),%eax
801023d7:	89 04 24             	mov    %eax,(%esp)
801023da:	e8 61 fe ff ff       	call   80102240 <skipelem>
801023df:	89 45 08             	mov    %eax,0x8(%ebp)
801023e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023e6:	0f 85 4b ff ff ff    	jne    80102337 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023f0:	74 12                	je     80102404 <namex+0x112>
    iput(ip);
801023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f5:	89 04 24             	mov    %eax,(%esp)
801023f8:	e8 14 f6 ff ff       	call   80101a11 <iput>
    return 0;
801023fd:	b8 00 00 00 00       	mov    $0x0,%eax
80102402:	eb 03                	jmp    80102407 <namex+0x115>
  }
  return ip;
80102404:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102407:	c9                   	leave  
80102408:	c3                   	ret    

80102409 <namei>:

struct inode*
namei(char *path)
{
80102409:	55                   	push   %ebp
8010240a:	89 e5                	mov    %esp,%ebp
8010240c:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010240f:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102412:	89 44 24 08          	mov    %eax,0x8(%esp)
80102416:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010241d:	00 
8010241e:	8b 45 08             	mov    0x8(%ebp),%eax
80102421:	89 04 24             	mov    %eax,(%esp)
80102424:	e8 c9 fe ff ff       	call   801022f2 <namex>
}
80102429:	c9                   	leave  
8010242a:	c3                   	ret    

8010242b <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010242b:	55                   	push   %ebp
8010242c:	89 e5                	mov    %esp,%ebp
8010242e:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102431:	8b 45 0c             	mov    0xc(%ebp),%eax
80102434:	89 44 24 08          	mov    %eax,0x8(%esp)
80102438:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010243f:	00 
80102440:	8b 45 08             	mov    0x8(%ebp),%eax
80102443:	89 04 24             	mov    %eax,(%esp)
80102446:	e8 a7 fe ff ff       	call   801022f2 <namex>
}
8010244b:	c9                   	leave  
8010244c:	c3                   	ret    
8010244d:	66 90                	xchg   %ax,%ax
8010244f:	90                   	nop

80102450 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	83 ec 14             	sub    $0x14,%esp
80102456:	8b 45 08             	mov    0x8(%ebp),%eax
80102459:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010245d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102461:	89 c2                	mov    %eax,%edx
80102463:	ec                   	in     (%dx),%al
80102464:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102467:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010246b:	c9                   	leave  
8010246c:	c3                   	ret    

8010246d <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010246d:	55                   	push   %ebp
8010246e:	89 e5                	mov    %esp,%ebp
80102470:	57                   	push   %edi
80102471:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102472:	8b 55 08             	mov    0x8(%ebp),%edx
80102475:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102478:	8b 45 10             	mov    0x10(%ebp),%eax
8010247b:	89 cb                	mov    %ecx,%ebx
8010247d:	89 df                	mov    %ebx,%edi
8010247f:	89 c1                	mov    %eax,%ecx
80102481:	fc                   	cld    
80102482:	f3 6d                	rep insl (%dx),%es:(%edi)
80102484:	89 c8                	mov    %ecx,%eax
80102486:	89 fb                	mov    %edi,%ebx
80102488:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010248b:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010248e:	5b                   	pop    %ebx
8010248f:	5f                   	pop    %edi
80102490:	5d                   	pop    %ebp
80102491:	c3                   	ret    

80102492 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102492:	55                   	push   %ebp
80102493:	89 e5                	mov    %esp,%ebp
80102495:	83 ec 08             	sub    $0x8,%esp
80102498:	8b 55 08             	mov    0x8(%ebp),%edx
8010249b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010249e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024a2:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024a5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024a9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024ad:	ee                   	out    %al,(%dx)
}
801024ae:	c9                   	leave  
801024af:	c3                   	ret    

801024b0 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	56                   	push   %esi
801024b4:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024b5:	8b 55 08             	mov    0x8(%ebp),%edx
801024b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024bb:	8b 45 10             	mov    0x10(%ebp),%eax
801024be:	89 cb                	mov    %ecx,%ebx
801024c0:	89 de                	mov    %ebx,%esi
801024c2:	89 c1                	mov    %eax,%ecx
801024c4:	fc                   	cld    
801024c5:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024c7:	89 c8                	mov    %ecx,%eax
801024c9:	89 f3                	mov    %esi,%ebx
801024cb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024ce:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024d1:	5b                   	pop    %ebx
801024d2:	5e                   	pop    %esi
801024d3:	5d                   	pop    %ebp
801024d4:	c3                   	ret    

801024d5 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024d5:	55                   	push   %ebp
801024d6:	89 e5                	mov    %esp,%ebp
801024d8:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024db:	90                   	nop
801024dc:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024e3:	e8 68 ff ff ff       	call   80102450 <inb>
801024e8:	0f b6 c0             	movzbl %al,%eax
801024eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024f1:	25 c0 00 00 00       	and    $0xc0,%eax
801024f6:	83 f8 40             	cmp    $0x40,%eax
801024f9:	75 e1                	jne    801024dc <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024ff:	74 11                	je     80102512 <idewait+0x3d>
80102501:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102504:	83 e0 21             	and    $0x21,%eax
80102507:	85 c0                	test   %eax,%eax
80102509:	74 07                	je     80102512 <idewait+0x3d>
    return -1;
8010250b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102510:	eb 05                	jmp    80102517 <idewait+0x42>
  return 0;
80102512:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102517:	c9                   	leave  
80102518:	c3                   	ret    

80102519 <ideinit>:

void
ideinit(void)
{
80102519:	55                   	push   %ebp
8010251a:	89 e5                	mov    %esp,%ebp
8010251c:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010251f:	c7 44 24 04 2c 85 10 	movl   $0x8010852c,0x4(%esp)
80102526:	80 
80102527:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010252e:	e8 af 28 00 00       	call   80104de2 <initlock>
  picenable(IRQ_IDE);
80102533:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010253a:	e8 86 18 00 00       	call   80103dc5 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010253f:	a1 40 29 11 80       	mov    0x80112940,%eax
80102544:	83 e8 01             	sub    $0x1,%eax
80102547:	89 44 24 04          	mov    %eax,0x4(%esp)
8010254b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102552:	e8 0d 04 00 00       	call   80102964 <ioapicenable>
  idewait(0);
80102557:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010255e:	e8 72 ff ff ff       	call   801024d5 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102563:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
8010256a:	00 
8010256b:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102572:	e8 1b ff ff ff       	call   80102492 <outb>
  for(i=0; i<1000; i++){
80102577:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010257e:	eb 20                	jmp    801025a0 <ideinit+0x87>
    if(inb(0x1f7) != 0){
80102580:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102587:	e8 c4 fe ff ff       	call   80102450 <inb>
8010258c:	84 c0                	test   %al,%al
8010258e:	74 0c                	je     8010259c <ideinit+0x83>
      havedisk1 = 1;
80102590:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
80102597:	00 00 00 
      break;
8010259a:	eb 0d                	jmp    801025a9 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010259c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025a0:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025a7:	7e d7                	jle    80102580 <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025a9:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025b0:	00 
801025b1:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025b8:	e8 d5 fe ff ff       	call   80102492 <outb>
}
801025bd:	c9                   	leave  
801025be:	c3                   	ret    

801025bf <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025bf:	55                   	push   %ebp
801025c0:	89 e5                	mov    %esp,%ebp
801025c2:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025c9:	75 0c                	jne    801025d7 <idestart+0x18>
    panic("idestart");
801025cb:	c7 04 24 30 85 10 80 	movl   $0x80108530,(%esp)
801025d2:	e8 63 df ff ff       	call   8010053a <panic>

  idewait(0);
801025d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025de:	e8 f2 fe ff ff       	call   801024d5 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025ea:	00 
801025eb:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025f2:	e8 9b fe ff ff       	call   80102492 <outb>
  outb(0x1f2, 1);  // number of sectors
801025f7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801025fe:	00 
801025ff:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102606:	e8 87 fe ff ff       	call   80102492 <outb>
  outb(0x1f3, b->sector & 0xff);
8010260b:	8b 45 08             	mov    0x8(%ebp),%eax
8010260e:	8b 40 08             	mov    0x8(%eax),%eax
80102611:	0f b6 c0             	movzbl %al,%eax
80102614:	89 44 24 04          	mov    %eax,0x4(%esp)
80102618:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010261f:	e8 6e fe ff ff       	call   80102492 <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102624:	8b 45 08             	mov    0x8(%ebp),%eax
80102627:	8b 40 08             	mov    0x8(%eax),%eax
8010262a:	c1 e8 08             	shr    $0x8,%eax
8010262d:	0f b6 c0             	movzbl %al,%eax
80102630:	89 44 24 04          	mov    %eax,0x4(%esp)
80102634:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
8010263b:	e8 52 fe ff ff       	call   80102492 <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
80102640:	8b 45 08             	mov    0x8(%ebp),%eax
80102643:	8b 40 08             	mov    0x8(%eax),%eax
80102646:	c1 e8 10             	shr    $0x10,%eax
80102649:	0f b6 c0             	movzbl %al,%eax
8010264c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102650:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102657:	e8 36 fe ff ff       	call   80102492 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
8010265c:	8b 45 08             	mov    0x8(%ebp),%eax
8010265f:	8b 40 04             	mov    0x4(%eax),%eax
80102662:	83 e0 01             	and    $0x1,%eax
80102665:	c1 e0 04             	shl    $0x4,%eax
80102668:	89 c2                	mov    %eax,%edx
8010266a:	8b 45 08             	mov    0x8(%ebp),%eax
8010266d:	8b 40 08             	mov    0x8(%eax),%eax
80102670:	c1 e8 18             	shr    $0x18,%eax
80102673:	83 e0 0f             	and    $0xf,%eax
80102676:	09 d0                	or     %edx,%eax
80102678:	83 c8 e0             	or     $0xffffffe0,%eax
8010267b:	0f b6 c0             	movzbl %al,%eax
8010267e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102682:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102689:	e8 04 fe ff ff       	call   80102492 <outb>
  if(b->flags & B_DIRTY){
8010268e:	8b 45 08             	mov    0x8(%ebp),%eax
80102691:	8b 00                	mov    (%eax),%eax
80102693:	83 e0 04             	and    $0x4,%eax
80102696:	85 c0                	test   %eax,%eax
80102698:	74 34                	je     801026ce <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
8010269a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026a1:	00 
801026a2:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026a9:	e8 e4 fd ff ff       	call   80102492 <outb>
    outsl(0x1f0, b->data, 512/4);
801026ae:	8b 45 08             	mov    0x8(%ebp),%eax
801026b1:	83 c0 18             	add    $0x18,%eax
801026b4:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026bb:	00 
801026bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801026c0:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026c7:	e8 e4 fd ff ff       	call   801024b0 <outsl>
801026cc:	eb 14                	jmp    801026e2 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026ce:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026d5:	00 
801026d6:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026dd:	e8 b0 fd ff ff       	call   80102492 <outb>
  }
}
801026e2:	c9                   	leave  
801026e3:	c3                   	ret    

801026e4 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026e4:	55                   	push   %ebp
801026e5:	89 e5                	mov    %esp,%ebp
801026e7:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026ea:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801026f1:	e8 0d 27 00 00       	call   80104e03 <acquire>
  if((b = idequeue) == 0){
801026f6:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801026fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102702:	75 11                	jne    80102715 <ideintr+0x31>
    release(&idelock);
80102704:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010270b:	e8 55 27 00 00       	call   80104e65 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102710:	e9 90 00 00 00       	jmp    801027a5 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102718:	8b 40 14             	mov    0x14(%eax),%eax
8010271b:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102723:	8b 00                	mov    (%eax),%eax
80102725:	83 e0 04             	and    $0x4,%eax
80102728:	85 c0                	test   %eax,%eax
8010272a:	75 2e                	jne    8010275a <ideintr+0x76>
8010272c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102733:	e8 9d fd ff ff       	call   801024d5 <idewait>
80102738:	85 c0                	test   %eax,%eax
8010273a:	78 1e                	js     8010275a <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
8010273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010273f:	83 c0 18             	add    $0x18,%eax
80102742:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102749:	00 
8010274a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010274e:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102755:	e8 13 fd ff ff       	call   8010246d <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010275d:	8b 00                	mov    (%eax),%eax
8010275f:	83 c8 02             	or     $0x2,%eax
80102762:	89 c2                	mov    %eax,%edx
80102764:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102767:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102769:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010276c:	8b 00                	mov    (%eax),%eax
8010276e:	83 e0 fb             	and    $0xfffffffb,%eax
80102771:	89 c2                	mov    %eax,%edx
80102773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102776:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102778:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010277b:	89 04 24             	mov    %eax,(%esp)
8010277e:	e8 8c 24 00 00       	call   80104c0f <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102783:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0d                	je     80102799 <ideintr+0xb5>
    idestart(idequeue);
8010278c:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102791:	89 04 24             	mov    %eax,(%esp)
80102794:	e8 26 fe ff ff       	call   801025bf <idestart>

  release(&idelock);
80102799:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027a0:	e8 c0 26 00 00       	call   80104e65 <release>
}
801027a5:	c9                   	leave  
801027a6:	c3                   	ret    

801027a7 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027a7:	55                   	push   %ebp
801027a8:	89 e5                	mov    %esp,%ebp
801027aa:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027ad:	8b 45 08             	mov    0x8(%ebp),%eax
801027b0:	8b 00                	mov    (%eax),%eax
801027b2:	83 e0 01             	and    $0x1,%eax
801027b5:	85 c0                	test   %eax,%eax
801027b7:	75 0c                	jne    801027c5 <iderw+0x1e>
    panic("iderw: buf not busy");
801027b9:	c7 04 24 39 85 10 80 	movl   $0x80108539,(%esp)
801027c0:	e8 75 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027c5:	8b 45 08             	mov    0x8(%ebp),%eax
801027c8:	8b 00                	mov    (%eax),%eax
801027ca:	83 e0 06             	and    $0x6,%eax
801027cd:	83 f8 02             	cmp    $0x2,%eax
801027d0:	75 0c                	jne    801027de <iderw+0x37>
    panic("iderw: nothing to do");
801027d2:	c7 04 24 4d 85 10 80 	movl   $0x8010854d,(%esp)
801027d9:	e8 5c dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027de:	8b 45 08             	mov    0x8(%ebp),%eax
801027e1:	8b 40 04             	mov    0x4(%eax),%eax
801027e4:	85 c0                	test   %eax,%eax
801027e6:	74 15                	je     801027fd <iderw+0x56>
801027e8:	a1 38 b6 10 80       	mov    0x8010b638,%eax
801027ed:	85 c0                	test   %eax,%eax
801027ef:	75 0c                	jne    801027fd <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027f1:	c7 04 24 62 85 10 80 	movl   $0x80108562,(%esp)
801027f8:	e8 3d dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
801027fd:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102804:	e8 fa 25 00 00       	call   80104e03 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102809:	8b 45 08             	mov    0x8(%ebp),%eax
8010280c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102813:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
8010281a:	eb 0b                	jmp    80102827 <iderw+0x80>
8010281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010281f:	8b 00                	mov    (%eax),%eax
80102821:	83 c0 14             	add    $0x14,%eax
80102824:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282a:	8b 00                	mov    (%eax),%eax
8010282c:	85 c0                	test   %eax,%eax
8010282e:	75 ec                	jne    8010281c <iderw+0x75>
    ;
  *pp = b;
80102830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102833:	8b 55 08             	mov    0x8(%ebp),%edx
80102836:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102838:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010283d:	3b 45 08             	cmp    0x8(%ebp),%eax
80102840:	75 0d                	jne    8010284f <iderw+0xa8>
    idestart(b);
80102842:	8b 45 08             	mov    0x8(%ebp),%eax
80102845:	89 04 24             	mov    %eax,(%esp)
80102848:	e8 72 fd ff ff       	call   801025bf <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010284d:	eb 15                	jmp    80102864 <iderw+0xbd>
8010284f:	eb 13                	jmp    80102864 <iderw+0xbd>
    sleep(b, &idelock);
80102851:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
80102858:	80 
80102859:	8b 45 08             	mov    0x8(%ebp),%eax
8010285c:	89 04 24             	mov    %eax,(%esp)
8010285f:	e8 d2 22 00 00       	call   80104b36 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102864:	8b 45 08             	mov    0x8(%ebp),%eax
80102867:	8b 00                	mov    (%eax),%eax
80102869:	83 e0 06             	and    $0x6,%eax
8010286c:	83 f8 02             	cmp    $0x2,%eax
8010286f:	75 e0                	jne    80102851 <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
80102871:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102878:	e8 e8 25 00 00       	call   80104e65 <release>
}
8010287d:	c9                   	leave  
8010287e:	c3                   	ret    
8010287f:	90                   	nop

80102880 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102883:	a1 14 22 11 80       	mov    0x80112214,%eax
80102888:	8b 55 08             	mov    0x8(%ebp),%edx
8010288b:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
8010288d:	a1 14 22 11 80       	mov    0x80112214,%eax
80102892:	8b 40 10             	mov    0x10(%eax),%eax
}
80102895:	5d                   	pop    %ebp
80102896:	c3                   	ret    

80102897 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102897:	55                   	push   %ebp
80102898:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010289a:	a1 14 22 11 80       	mov    0x80112214,%eax
8010289f:	8b 55 08             	mov    0x8(%ebp),%edx
801028a2:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028a4:	a1 14 22 11 80       	mov    0x80112214,%eax
801028a9:	8b 55 0c             	mov    0xc(%ebp),%edx
801028ac:	89 50 10             	mov    %edx,0x10(%eax)
}
801028af:	5d                   	pop    %ebp
801028b0:	c3                   	ret    

801028b1 <ioapicinit>:

void
ioapicinit(void)
{
801028b1:	55                   	push   %ebp
801028b2:	89 e5                	mov    %esp,%ebp
801028b4:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028b7:	a1 44 23 11 80       	mov    0x80112344,%eax
801028bc:	85 c0                	test   %eax,%eax
801028be:	75 05                	jne    801028c5 <ioapicinit+0x14>
    return;
801028c0:	e9 9d 00 00 00       	jmp    80102962 <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028c5:	c7 05 14 22 11 80 00 	movl   $0xfec00000,0x80112214
801028cc:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028d6:	e8 a5 ff ff ff       	call   80102880 <ioapicread>
801028db:	c1 e8 10             	shr    $0x10,%eax
801028de:	25 ff 00 00 00       	and    $0xff,%eax
801028e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028ed:	e8 8e ff ff ff       	call   80102880 <ioapicread>
801028f2:	c1 e8 18             	shr    $0x18,%eax
801028f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801028f8:	0f b6 05 40 23 11 80 	movzbl 0x80112340,%eax
801028ff:	0f b6 c0             	movzbl %al,%eax
80102902:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102905:	74 0c                	je     80102913 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102907:	c7 04 24 80 85 10 80 	movl   $0x80108580,(%esp)
8010290e:	e8 8d da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102913:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010291a:	eb 3e                	jmp    8010295a <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291f:	83 c0 20             	add    $0x20,%eax
80102922:	0d 00 00 01 00       	or     $0x10000,%eax
80102927:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010292a:	83 c2 08             	add    $0x8,%edx
8010292d:	01 d2                	add    %edx,%edx
8010292f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102933:	89 14 24             	mov    %edx,(%esp)
80102936:	e8 5c ff ff ff       	call   80102897 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
8010293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010293e:	83 c0 08             	add    $0x8,%eax
80102941:	01 c0                	add    %eax,%eax
80102943:	83 c0 01             	add    $0x1,%eax
80102946:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010294d:	00 
8010294e:	89 04 24             	mov    %eax,(%esp)
80102951:	e8 41 ff ff ff       	call   80102897 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102956:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010295d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102960:	7e ba                	jle    8010291c <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102962:	c9                   	leave  
80102963:	c3                   	ret    

80102964 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102964:	55                   	push   %ebp
80102965:	89 e5                	mov    %esp,%ebp
80102967:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
8010296a:	a1 44 23 11 80       	mov    0x80112344,%eax
8010296f:	85 c0                	test   %eax,%eax
80102971:	75 02                	jne    80102975 <ioapicenable+0x11>
    return;
80102973:	eb 37                	jmp    801029ac <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102975:	8b 45 08             	mov    0x8(%ebp),%eax
80102978:	83 c0 20             	add    $0x20,%eax
8010297b:	8b 55 08             	mov    0x8(%ebp),%edx
8010297e:	83 c2 08             	add    $0x8,%edx
80102981:	01 d2                	add    %edx,%edx
80102983:	89 44 24 04          	mov    %eax,0x4(%esp)
80102987:	89 14 24             	mov    %edx,(%esp)
8010298a:	e8 08 ff ff ff       	call   80102897 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010298f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102992:	c1 e0 18             	shl    $0x18,%eax
80102995:	8b 55 08             	mov    0x8(%ebp),%edx
80102998:	83 c2 08             	add    $0x8,%edx
8010299b:	01 d2                	add    %edx,%edx
8010299d:	83 c2 01             	add    $0x1,%edx
801029a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801029a4:	89 14 24             	mov    %edx,(%esp)
801029a7:	e8 eb fe ff ff       	call   80102897 <ioapicwrite>
}
801029ac:	c9                   	leave  
801029ad:	c3                   	ret    
801029ae:	66 90                	xchg   %ax,%ax

801029b0 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	8b 45 08             	mov    0x8(%ebp),%eax
801029b6:	05 00 00 00 80       	add    $0x80000000,%eax
801029bb:	5d                   	pop    %ebp
801029bc:	c3                   	ret    

801029bd <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029bd:	55                   	push   %ebp
801029be:	89 e5                	mov    %esp,%ebp
801029c0:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029c3:	c7 44 24 04 b2 85 10 	movl   $0x801085b2,0x4(%esp)
801029ca:	80 
801029cb:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
801029d2:	e8 0b 24 00 00       	call   80104de2 <initlock>
  kmem.use_lock = 0;
801029d7:	c7 05 54 22 11 80 00 	movl   $0x0,0x80112254
801029de:	00 00 00 
  freerange(vstart, vend);
801029e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801029e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801029e8:	8b 45 08             	mov    0x8(%ebp),%eax
801029eb:	89 04 24             	mov    %eax,(%esp)
801029ee:	e8 26 00 00 00       	call   80102a19 <freerange>
}
801029f3:	c9                   	leave  
801029f4:	c3                   	ret    

801029f5 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801029f5:	55                   	push   %ebp
801029f6:	89 e5                	mov    %esp,%ebp
801029f8:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
801029fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801029fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a02:	8b 45 08             	mov    0x8(%ebp),%eax
80102a05:	89 04 24             	mov    %eax,(%esp)
80102a08:	e8 0c 00 00 00       	call   80102a19 <freerange>
  kmem.use_lock = 1;
80102a0d:	c7 05 54 22 11 80 01 	movl   $0x1,0x80112254
80102a14:	00 00 00 
}
80102a17:	c9                   	leave  
80102a18:	c3                   	ret    

80102a19 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a19:	55                   	push   %ebp
80102a1a:	89 e5                	mov    %esp,%ebp
80102a1c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a1f:	8b 45 08             	mov    0x8(%ebp),%eax
80102a22:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a2f:	eb 12                	jmp    80102a43 <freerange+0x2a>
    kfree(p);
80102a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a34:	89 04 24             	mov    %eax,(%esp)
80102a37:	e8 16 00 00 00       	call   80102a52 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a3c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a46:	05 00 10 00 00       	add    $0x1000,%eax
80102a4b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a4e:	76 e1                	jbe    80102a31 <freerange+0x18>
    kfree(p);
}
80102a50:	c9                   	leave  
80102a51:	c3                   	ret    

80102a52 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a52:	55                   	push   %ebp
80102a53:	89 e5                	mov    %esp,%ebp
80102a55:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a58:	8b 45 08             	mov    0x8(%ebp),%eax
80102a5b:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a60:	85 c0                	test   %eax,%eax
80102a62:	75 1b                	jne    80102a7f <kfree+0x2d>
80102a64:	81 7d 08 3c 51 11 80 	cmpl   $0x8011513c,0x8(%ebp)
80102a6b:	72 12                	jb     80102a7f <kfree+0x2d>
80102a6d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a70:	89 04 24             	mov    %eax,(%esp)
80102a73:	e8 38 ff ff ff       	call   801029b0 <v2p>
80102a78:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a7d:	76 0c                	jbe    80102a8b <kfree+0x39>
    panic("kfree");
80102a7f:	c7 04 24 b7 85 10 80 	movl   $0x801085b7,(%esp)
80102a86:	e8 af da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a8b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a92:	00 
80102a93:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a9a:	00 
80102a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a9e:	89 04 24             	mov    %eax,(%esp)
80102aa1:	e8 b4 25 00 00       	call   8010505a <memset>

  if(kmem.use_lock)
80102aa6:	a1 54 22 11 80       	mov    0x80112254,%eax
80102aab:	85 c0                	test   %eax,%eax
80102aad:	74 0c                	je     80102abb <kfree+0x69>
    acquire(&kmem.lock);
80102aaf:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80102ab6:	e8 48 23 00 00       	call   80104e03 <acquire>
  r = (struct run*)v;
80102abb:	8b 45 08             	mov    0x8(%ebp),%eax
80102abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ac1:	8b 15 58 22 11 80    	mov    0x80112258,%edx
80102ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aca:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102acf:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102ad4:	a1 54 22 11 80       	mov    0x80112254,%eax
80102ad9:	85 c0                	test   %eax,%eax
80102adb:	74 0c                	je     80102ae9 <kfree+0x97>
    release(&kmem.lock);
80102add:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80102ae4:	e8 7c 23 00 00       	call   80104e65 <release>
}
80102ae9:	c9                   	leave  
80102aea:	c3                   	ret    

80102aeb <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102aeb:	55                   	push   %ebp
80102aec:	89 e5                	mov    %esp,%ebp
80102aee:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102af1:	a1 54 22 11 80       	mov    0x80112254,%eax
80102af6:	85 c0                	test   %eax,%eax
80102af8:	74 0c                	je     80102b06 <kalloc+0x1b>
    acquire(&kmem.lock);
80102afa:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80102b01:	e8 fd 22 00 00       	call   80104e03 <acquire>
  r = kmem.freelist;
80102b06:	a1 58 22 11 80       	mov    0x80112258,%eax
80102b0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b12:	74 0a                	je     80102b1e <kalloc+0x33>
    kmem.freelist = r->next;
80102b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b17:	8b 00                	mov    (%eax),%eax
80102b19:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102b1e:	a1 54 22 11 80       	mov    0x80112254,%eax
80102b23:	85 c0                	test   %eax,%eax
80102b25:	74 0c                	je     80102b33 <kalloc+0x48>
    release(&kmem.lock);
80102b27:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80102b2e:	e8 32 23 00 00       	call   80104e65 <release>
  return (char*)r;
80102b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b36:	c9                   	leave  
80102b37:	c3                   	ret    

80102b38 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b38:	55                   	push   %ebp
80102b39:	89 e5                	mov    %esp,%ebp
80102b3b:	83 ec 14             	sub    $0x14,%esp
80102b3e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b41:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b45:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b49:	89 c2                	mov    %eax,%edx
80102b4b:	ec                   	in     (%dx),%al
80102b4c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b4f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b53:	c9                   	leave  
80102b54:	c3                   	ret    

80102b55 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b55:	55                   	push   %ebp
80102b56:	89 e5                	mov    %esp,%ebp
80102b58:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b5b:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b62:	e8 d1 ff ff ff       	call   80102b38 <inb>
80102b67:	0f b6 c0             	movzbl %al,%eax
80102b6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b70:	83 e0 01             	and    $0x1,%eax
80102b73:	85 c0                	test   %eax,%eax
80102b75:	75 0a                	jne    80102b81 <kbdgetc+0x2c>
    return -1;
80102b77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b7c:	e9 25 01 00 00       	jmp    80102ca6 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102b81:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102b88:	e8 ab ff ff ff       	call   80102b38 <inb>
80102b8d:	0f b6 c0             	movzbl %al,%eax
80102b90:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102b93:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102b9a:	75 17                	jne    80102bb3 <kbdgetc+0x5e>
    shift |= E0ESC;
80102b9c:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102ba1:	83 c8 40             	or     $0x40,%eax
80102ba4:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102ba9:	b8 00 00 00 00       	mov    $0x0,%eax
80102bae:	e9 f3 00 00 00       	jmp    80102ca6 <kbdgetc+0x151>
  } else if(data & 0x80){
80102bb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bb6:	25 80 00 00 00       	and    $0x80,%eax
80102bbb:	85 c0                	test   %eax,%eax
80102bbd:	74 45                	je     80102c04 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bbf:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bc4:	83 e0 40             	and    $0x40,%eax
80102bc7:	85 c0                	test   %eax,%eax
80102bc9:	75 08                	jne    80102bd3 <kbdgetc+0x7e>
80102bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bce:	83 e0 7f             	and    $0x7f,%eax
80102bd1:	eb 03                	jmp    80102bd6 <kbdgetc+0x81>
80102bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102bd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bdc:	05 20 90 10 80       	add    $0x80109020,%eax
80102be1:	0f b6 00             	movzbl (%eax),%eax
80102be4:	83 c8 40             	or     $0x40,%eax
80102be7:	0f b6 c0             	movzbl %al,%eax
80102bea:	f7 d0                	not    %eax
80102bec:	89 c2                	mov    %eax,%edx
80102bee:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bf3:	21 d0                	and    %edx,%eax
80102bf5:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102bfa:	b8 00 00 00 00       	mov    $0x0,%eax
80102bff:	e9 a2 00 00 00       	jmp    80102ca6 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102c04:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c09:	83 e0 40             	and    $0x40,%eax
80102c0c:	85 c0                	test   %eax,%eax
80102c0e:	74 14                	je     80102c24 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c10:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c17:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c1c:	83 e0 bf             	and    $0xffffffbf,%eax
80102c1f:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c27:	05 20 90 10 80       	add    $0x80109020,%eax
80102c2c:	0f b6 00             	movzbl (%eax),%eax
80102c2f:	0f b6 d0             	movzbl %al,%edx
80102c32:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c37:	09 d0                	or     %edx,%eax
80102c39:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c41:	05 20 91 10 80       	add    $0x80109120,%eax
80102c46:	0f b6 00             	movzbl (%eax),%eax
80102c49:	0f b6 d0             	movzbl %al,%edx
80102c4c:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c51:	31 d0                	xor    %edx,%eax
80102c53:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c58:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c5d:	83 e0 03             	and    $0x3,%eax
80102c60:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102c67:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c6a:	01 d0                	add    %edx,%eax
80102c6c:	0f b6 00             	movzbl (%eax),%eax
80102c6f:	0f b6 c0             	movzbl %al,%eax
80102c72:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c75:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c7a:	83 e0 08             	and    $0x8,%eax
80102c7d:	85 c0                	test   %eax,%eax
80102c7f:	74 22                	je     80102ca3 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102c81:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102c85:	76 0c                	jbe    80102c93 <kbdgetc+0x13e>
80102c87:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102c8b:	77 06                	ja     80102c93 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102c8d:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102c91:	eb 10                	jmp    80102ca3 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102c93:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102c97:	76 0a                	jbe    80102ca3 <kbdgetc+0x14e>
80102c99:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102c9d:	77 04                	ja     80102ca3 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102c9f:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102ca3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102ca6:	c9                   	leave  
80102ca7:	c3                   	ret    

80102ca8 <kbdintr>:

void
kbdintr(void)
{
80102ca8:	55                   	push   %ebp
80102ca9:	89 e5                	mov    %esp,%ebp
80102cab:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102cae:	c7 04 24 55 2b 10 80 	movl   $0x80102b55,(%esp)
80102cb5:	e8 f3 da ff ff       	call   801007ad <consoleintr>
}
80102cba:	c9                   	leave  
80102cbb:	c3                   	ret    

80102cbc <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102cbc:	55                   	push   %ebp
80102cbd:	89 e5                	mov    %esp,%ebp
80102cbf:	83 ec 14             	sub    $0x14,%esp
80102cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80102cc5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cc9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ccd:	89 c2                	mov    %eax,%edx
80102ccf:	ec                   	in     (%dx),%al
80102cd0:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cd3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102cd7:	c9                   	leave  
80102cd8:	c3                   	ret    

80102cd9 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102cd9:	55                   	push   %ebp
80102cda:	89 e5                	mov    %esp,%ebp
80102cdc:	83 ec 08             	sub    $0x8,%esp
80102cdf:	8b 55 08             	mov    0x8(%ebp),%edx
80102ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ce5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102ce9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cec:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102cf0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102cf4:	ee                   	out    %al,(%dx)
}
80102cf5:	c9                   	leave  
80102cf6:	c3                   	ret    

80102cf7 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102cf7:	55                   	push   %ebp
80102cf8:	89 e5                	mov    %esp,%ebp
80102cfa:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102cfd:	9c                   	pushf  
80102cfe:	58                   	pop    %eax
80102cff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d05:	c9                   	leave  
80102d06:	c3                   	ret    

80102d07 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d07:	55                   	push   %ebp
80102d08:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d0a:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102d0f:	8b 55 08             	mov    0x8(%ebp),%edx
80102d12:	c1 e2 02             	shl    $0x2,%edx
80102d15:	01 c2                	add    %eax,%edx
80102d17:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d1a:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d1c:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102d21:	83 c0 20             	add    $0x20,%eax
80102d24:	8b 00                	mov    (%eax),%eax
}
80102d26:	5d                   	pop    %ebp
80102d27:	c3                   	ret    

80102d28 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d28:	55                   	push   %ebp
80102d29:	89 e5                	mov    %esp,%ebp
80102d2b:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d2e:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102d33:	85 c0                	test   %eax,%eax
80102d35:	75 05                	jne    80102d3c <lapicinit+0x14>
    return;
80102d37:	e9 43 01 00 00       	jmp    80102e7f <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d3c:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d43:	00 
80102d44:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d4b:	e8 b7 ff ff ff       	call   80102d07 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d50:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d57:	00 
80102d58:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d5f:	e8 a3 ff ff ff       	call   80102d07 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d64:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d6b:	00 
80102d6c:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d73:	e8 8f ff ff ff       	call   80102d07 <lapicw>
  lapicw(TICR, 10000000); 
80102d78:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d7f:	00 
80102d80:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d87:	e8 7b ff ff ff       	call   80102d07 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d8c:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d93:	00 
80102d94:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102d9b:	e8 67 ff ff ff       	call   80102d07 <lapicw>
  lapicw(LINT1, MASKED);
80102da0:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102da7:	00 
80102da8:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102daf:	e8 53 ff ff ff       	call   80102d07 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102db4:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102db9:	83 c0 30             	add    $0x30,%eax
80102dbc:	8b 00                	mov    (%eax),%eax
80102dbe:	c1 e8 10             	shr    $0x10,%eax
80102dc1:	0f b6 c0             	movzbl %al,%eax
80102dc4:	83 f8 03             	cmp    $0x3,%eax
80102dc7:	76 14                	jbe    80102ddd <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102dc9:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dd0:	00 
80102dd1:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102dd8:	e8 2a ff ff ff       	call   80102d07 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102ddd:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102de4:	00 
80102de5:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102dec:	e8 16 ff ff ff       	call   80102d07 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102df1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102df8:	00 
80102df9:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e00:	e8 02 ff ff ff       	call   80102d07 <lapicw>
  lapicw(ESR, 0);
80102e05:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e0c:	00 
80102e0d:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e14:	e8 ee fe ff ff       	call   80102d07 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e19:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e20:	00 
80102e21:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e28:	e8 da fe ff ff       	call   80102d07 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e2d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e34:	00 
80102e35:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e3c:	e8 c6 fe ff ff       	call   80102d07 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e41:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e48:	00 
80102e49:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e50:	e8 b2 fe ff ff       	call   80102d07 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e55:	90                   	nop
80102e56:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102e5b:	05 00 03 00 00       	add    $0x300,%eax
80102e60:	8b 00                	mov    (%eax),%eax
80102e62:	25 00 10 00 00       	and    $0x1000,%eax
80102e67:	85 c0                	test   %eax,%eax
80102e69:	75 eb                	jne    80102e56 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e6b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e72:	00 
80102e73:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e7a:	e8 88 fe ff ff       	call   80102d07 <lapicw>
}
80102e7f:	c9                   	leave  
80102e80:	c3                   	ret    

80102e81 <cpunum>:

int
cpunum(void)
{
80102e81:	55                   	push   %ebp
80102e82:	89 e5                	mov    %esp,%ebp
80102e84:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e87:	e8 6b fe ff ff       	call   80102cf7 <readeflags>
80102e8c:	25 00 02 00 00       	and    $0x200,%eax
80102e91:	85 c0                	test   %eax,%eax
80102e93:	74 25                	je     80102eba <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102e95:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102e9a:	8d 50 01             	lea    0x1(%eax),%edx
80102e9d:	89 15 40 b6 10 80    	mov    %edx,0x8010b640
80102ea3:	85 c0                	test   %eax,%eax
80102ea5:	75 13                	jne    80102eba <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102ea7:	8b 45 04             	mov    0x4(%ebp),%eax
80102eaa:	89 44 24 04          	mov    %eax,0x4(%esp)
80102eae:	c7 04 24 c0 85 10 80 	movl   $0x801085c0,(%esp)
80102eb5:	e8 e6 d4 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102eba:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102ebf:	85 c0                	test   %eax,%eax
80102ec1:	74 0f                	je     80102ed2 <cpunum+0x51>
    return lapic[ID]>>24;
80102ec3:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102ec8:	83 c0 20             	add    $0x20,%eax
80102ecb:	8b 00                	mov    (%eax),%eax
80102ecd:	c1 e8 18             	shr    $0x18,%eax
80102ed0:	eb 05                	jmp    80102ed7 <cpunum+0x56>
  return 0;
80102ed2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ed7:	c9                   	leave  
80102ed8:	c3                   	ret    

80102ed9 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ed9:	55                   	push   %ebp
80102eda:	89 e5                	mov    %esp,%ebp
80102edc:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102edf:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102ee4:	85 c0                	test   %eax,%eax
80102ee6:	74 14                	je     80102efc <lapiceoi+0x23>
    lapicw(EOI, 0);
80102ee8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eef:	00 
80102ef0:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ef7:	e8 0b fe ff ff       	call   80102d07 <lapicw>
}
80102efc:	c9                   	leave  
80102efd:	c3                   	ret    

80102efe <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102efe:	55                   	push   %ebp
80102eff:	89 e5                	mov    %esp,%ebp
}
80102f01:	5d                   	pop    %ebp
80102f02:	c3                   	ret    

80102f03 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f03:	55                   	push   %ebp
80102f04:	89 e5                	mov    %esp,%ebp
80102f06:	83 ec 1c             	sub    $0x1c,%esp
80102f09:	8b 45 08             	mov    0x8(%ebp),%eax
80102f0c:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f0f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f16:	00 
80102f17:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f1e:	e8 b6 fd ff ff       	call   80102cd9 <outb>
  outb(CMOS_PORT+1, 0x0A);
80102f23:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f2a:	00 
80102f2b:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f32:	e8 a2 fd ff ff       	call   80102cd9 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f37:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f41:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f49:	8d 50 02             	lea    0x2(%eax),%edx
80102f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f4f:	c1 e8 04             	shr    $0x4,%eax
80102f52:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f55:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f59:	c1 e0 18             	shl    $0x18,%eax
80102f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f60:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f67:	e8 9b fd ff ff       	call   80102d07 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f6c:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f73:	00 
80102f74:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f7b:	e8 87 fd ff ff       	call   80102d07 <lapicw>
  microdelay(200);
80102f80:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f87:	e8 72 ff ff ff       	call   80102efe <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f8c:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102f93:	00 
80102f94:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f9b:	e8 67 fd ff ff       	call   80102d07 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fa0:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102fa7:	e8 52 ff ff ff       	call   80102efe <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102fb3:	eb 40                	jmp    80102ff5 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102fb5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fb9:	c1 e0 18             	shl    $0x18,%eax
80102fbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fc0:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fc7:	e8 3b fd ff ff       	call   80102d07 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fcf:	c1 e8 0c             	shr    $0xc,%eax
80102fd2:	80 cc 06             	or     $0x6,%ah
80102fd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fd9:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fe0:	e8 22 fd ff ff       	call   80102d07 <lapicw>
    microdelay(200);
80102fe5:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fec:	e8 0d ff ff ff       	call   80102efe <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102ff1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102ff5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102ff9:	7e ba                	jle    80102fb5 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102ffb:	c9                   	leave  
80102ffc:	c3                   	ret    

80102ffd <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80102ffd:	55                   	push   %ebp
80102ffe:	89 e5                	mov    %esp,%ebp
80103000:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
80103003:	8b 45 08             	mov    0x8(%ebp),%eax
80103006:	0f b6 c0             	movzbl %al,%eax
80103009:	89 44 24 04          	mov    %eax,0x4(%esp)
8010300d:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103014:	e8 c0 fc ff ff       	call   80102cd9 <outb>
  microdelay(200);
80103019:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103020:	e8 d9 fe ff ff       	call   80102efe <microdelay>

  return inb(CMOS_RETURN);
80103025:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
8010302c:	e8 8b fc ff ff       	call   80102cbc <inb>
80103031:	0f b6 c0             	movzbl %al,%eax
}
80103034:	c9                   	leave  
80103035:	c3                   	ret    

80103036 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103036:	55                   	push   %ebp
80103037:	89 e5                	mov    %esp,%ebp
80103039:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
8010303c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80103043:	e8 b5 ff ff ff       	call   80102ffd <cmos_read>
80103048:	8b 55 08             	mov    0x8(%ebp),%edx
8010304b:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
8010304d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80103054:	e8 a4 ff ff ff       	call   80102ffd <cmos_read>
80103059:	8b 55 08             	mov    0x8(%ebp),%edx
8010305c:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
8010305f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80103066:	e8 92 ff ff ff       	call   80102ffd <cmos_read>
8010306b:	8b 55 08             	mov    0x8(%ebp),%edx
8010306e:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103071:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103078:	e8 80 ff ff ff       	call   80102ffd <cmos_read>
8010307d:	8b 55 08             	mov    0x8(%ebp),%edx
80103080:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80103083:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010308a:	e8 6e ff ff ff       	call   80102ffd <cmos_read>
8010308f:	8b 55 08             	mov    0x8(%ebp),%edx
80103092:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80103095:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
8010309c:	e8 5c ff ff ff       	call   80102ffd <cmos_read>
801030a1:	8b 55 08             	mov    0x8(%ebp),%edx
801030a4:	89 42 14             	mov    %eax,0x14(%edx)
}
801030a7:	c9                   	leave  
801030a8:	c3                   	ret    

801030a9 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801030a9:	55                   	push   %ebp
801030aa:	89 e5                	mov    %esp,%ebp
801030ac:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801030af:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
801030b6:	e8 42 ff ff ff       	call   80102ffd <cmos_read>
801030bb:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030c1:	83 e0 04             	and    $0x4,%eax
801030c4:	85 c0                	test   %eax,%eax
801030c6:	0f 94 c0             	sete   %al
801030c9:	0f b6 c0             	movzbl %al,%eax
801030cc:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801030cf:	8d 45 d8             	lea    -0x28(%ebp),%eax
801030d2:	89 04 24             	mov    %eax,(%esp)
801030d5:	e8 5c ff ff ff       	call   80103036 <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801030da:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801030e1:	e8 17 ff ff ff       	call   80102ffd <cmos_read>
801030e6:	25 80 00 00 00       	and    $0x80,%eax
801030eb:	85 c0                	test   %eax,%eax
801030ed:	74 02                	je     801030f1 <cmostime+0x48>
        continue;
801030ef:	eb 36                	jmp    80103127 <cmostime+0x7e>
    fill_rtcdate(&t2);
801030f1:	8d 45 c0             	lea    -0x40(%ebp),%eax
801030f4:	89 04 24             	mov    %eax,(%esp)
801030f7:	e8 3a ff ff ff       	call   80103036 <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801030fc:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80103103:	00 
80103104:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103107:	89 44 24 04          	mov    %eax,0x4(%esp)
8010310b:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010310e:	89 04 24             	mov    %eax,(%esp)
80103111:	e8 bb 1f 00 00       	call   801050d1 <memcmp>
80103116:	85 c0                	test   %eax,%eax
80103118:	75 0d                	jne    80103127 <cmostime+0x7e>
      break;
8010311a:	90                   	nop
  }

  // convert
  if (bcd) {
8010311b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010311f:	0f 84 ac 00 00 00    	je     801031d1 <cmostime+0x128>
80103125:	eb 02                	jmp    80103129 <cmostime+0x80>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103127:	eb a6                	jmp    801030cf <cmostime+0x26>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103129:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010312c:	c1 e8 04             	shr    $0x4,%eax
8010312f:	89 c2                	mov    %eax,%edx
80103131:	89 d0                	mov    %edx,%eax
80103133:	c1 e0 02             	shl    $0x2,%eax
80103136:	01 d0                	add    %edx,%eax
80103138:	01 c0                	add    %eax,%eax
8010313a:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010313d:	83 e2 0f             	and    $0xf,%edx
80103140:	01 d0                	add    %edx,%eax
80103142:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103145:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103148:	c1 e8 04             	shr    $0x4,%eax
8010314b:	89 c2                	mov    %eax,%edx
8010314d:	89 d0                	mov    %edx,%eax
8010314f:	c1 e0 02             	shl    $0x2,%eax
80103152:	01 d0                	add    %edx,%eax
80103154:	01 c0                	add    %eax,%eax
80103156:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103159:	83 e2 0f             	and    $0xf,%edx
8010315c:	01 d0                	add    %edx,%eax
8010315e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103161:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103164:	c1 e8 04             	shr    $0x4,%eax
80103167:	89 c2                	mov    %eax,%edx
80103169:	89 d0                	mov    %edx,%eax
8010316b:	c1 e0 02             	shl    $0x2,%eax
8010316e:	01 d0                	add    %edx,%eax
80103170:	01 c0                	add    %eax,%eax
80103172:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103175:	83 e2 0f             	and    $0xf,%edx
80103178:	01 d0                	add    %edx,%eax
8010317a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
8010317d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103180:	c1 e8 04             	shr    $0x4,%eax
80103183:	89 c2                	mov    %eax,%edx
80103185:	89 d0                	mov    %edx,%eax
80103187:	c1 e0 02             	shl    $0x2,%eax
8010318a:	01 d0                	add    %edx,%eax
8010318c:	01 c0                	add    %eax,%eax
8010318e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103191:	83 e2 0f             	and    $0xf,%edx
80103194:	01 d0                	add    %edx,%eax
80103196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103199:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010319c:	c1 e8 04             	shr    $0x4,%eax
8010319f:	89 c2                	mov    %eax,%edx
801031a1:	89 d0                	mov    %edx,%eax
801031a3:	c1 e0 02             	shl    $0x2,%eax
801031a6:	01 d0                	add    %edx,%eax
801031a8:	01 c0                	add    %eax,%eax
801031aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
801031ad:	83 e2 0f             	and    $0xf,%edx
801031b0:	01 d0                	add    %edx,%eax
801031b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801031b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031b8:	c1 e8 04             	shr    $0x4,%eax
801031bb:	89 c2                	mov    %eax,%edx
801031bd:	89 d0                	mov    %edx,%eax
801031bf:	c1 e0 02             	shl    $0x2,%eax
801031c2:	01 d0                	add    %edx,%eax
801031c4:	01 c0                	add    %eax,%eax
801031c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801031c9:	83 e2 0f             	and    $0xf,%edx
801031cc:	01 d0                	add    %edx,%eax
801031ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801031d1:	8b 45 08             	mov    0x8(%ebp),%eax
801031d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
801031d7:	89 10                	mov    %edx,(%eax)
801031d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801031dc:	89 50 04             	mov    %edx,0x4(%eax)
801031df:	8b 55 e0             	mov    -0x20(%ebp),%edx
801031e2:	89 50 08             	mov    %edx,0x8(%eax)
801031e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801031e8:	89 50 0c             	mov    %edx,0xc(%eax)
801031eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
801031ee:	89 50 10             	mov    %edx,0x10(%eax)
801031f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
801031f4:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801031f7:	8b 45 08             	mov    0x8(%ebp),%eax
801031fa:	8b 40 14             	mov    0x14(%eax),%eax
801031fd:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103203:	8b 45 08             	mov    0x8(%ebp),%eax
80103206:	89 50 14             	mov    %edx,0x14(%eax)
}
80103209:	c9                   	leave  
8010320a:	c3                   	ret    
8010320b:	90                   	nop

8010320c <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
8010320c:	55                   	push   %ebp
8010320d:	89 e5                	mov    %esp,%ebp
8010320f:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103212:	c7 44 24 04 ec 85 10 	movl   $0x801085ec,0x4(%esp)
80103219:	80 
8010321a:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103221:	e8 bc 1b 00 00       	call   80104de2 <initlock>
  readsb(ROOTDEV, &sb);
80103226:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103229:	89 44 24 04          	mov    %eax,0x4(%esp)
8010322d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103234:	e8 bb e0 ff ff       	call   801012f4 <readsb>
  log.start = sb.size - sb.nlog;
80103239:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010323c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010323f:	29 c2                	sub    %eax,%edx
80103241:	89 d0                	mov    %edx,%eax
80103243:	a3 94 22 11 80       	mov    %eax,0x80112294
  log.size = sb.nlog;
80103248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010324b:	a3 98 22 11 80       	mov    %eax,0x80112298
  log.dev = ROOTDEV;
80103250:	c7 05 a4 22 11 80 01 	movl   $0x1,0x801122a4
80103257:	00 00 00 
  recover_from_log();
8010325a:	e8 9a 01 00 00       	call   801033f9 <recover_from_log>
}
8010325f:	c9                   	leave  
80103260:	c3                   	ret    

80103261 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103261:	55                   	push   %ebp
80103262:	89 e5                	mov    %esp,%ebp
80103264:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010326e:	e9 8c 00 00 00       	jmp    801032ff <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103273:	8b 15 94 22 11 80    	mov    0x80112294,%edx
80103279:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010327c:	01 d0                	add    %edx,%eax
8010327e:	83 c0 01             	add    $0x1,%eax
80103281:	89 c2                	mov    %eax,%edx
80103283:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103288:	89 54 24 04          	mov    %edx,0x4(%esp)
8010328c:	89 04 24             	mov    %eax,(%esp)
8010328f:	e8 12 cf ff ff       	call   801001a6 <bread>
80103294:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103297:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010329a:	83 c0 10             	add    $0x10,%eax
8010329d:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
801032a4:	89 c2                	mov    %eax,%edx
801032a6:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801032ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801032af:	89 04 24             	mov    %eax,(%esp)
801032b2:	e8 ef ce ff ff       	call   801001a6 <bread>
801032b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032bd:	8d 50 18             	lea    0x18(%eax),%edx
801032c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032c3:	83 c0 18             	add    $0x18,%eax
801032c6:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801032cd:	00 
801032ce:	89 54 24 04          	mov    %edx,0x4(%esp)
801032d2:	89 04 24             	mov    %eax,(%esp)
801032d5:	e8 4f 1e 00 00       	call   80105129 <memmove>
    bwrite(dbuf);  // write dst to disk
801032da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032dd:	89 04 24             	mov    %eax,(%esp)
801032e0:	e8 f8 ce ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801032e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032e8:	89 04 24             	mov    %eax,(%esp)
801032eb:	e8 27 cf ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801032f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032f3:	89 04 24             	mov    %eax,(%esp)
801032f6:	e8 1c cf ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032ff:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103304:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103307:	0f 8f 66 ff ff ff    	jg     80103273 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010330d:	c9                   	leave  
8010330e:	c3                   	ret    

8010330f <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010330f:	55                   	push   %ebp
80103310:	89 e5                	mov    %esp,%ebp
80103312:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103315:	a1 94 22 11 80       	mov    0x80112294,%eax
8010331a:	89 c2                	mov    %eax,%edx
8010331c:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103321:	89 54 24 04          	mov    %edx,0x4(%esp)
80103325:	89 04 24             	mov    %eax,(%esp)
80103328:	e8 79 ce ff ff       	call   801001a6 <bread>
8010332d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103330:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103333:	83 c0 18             	add    $0x18,%eax
80103336:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103339:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010333c:	8b 00                	mov    (%eax),%eax
8010333e:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  for (i = 0; i < log.lh.n; i++) {
80103343:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010334a:	eb 1b                	jmp    80103367 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
8010334c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010334f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103352:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103356:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103359:	83 c2 10             	add    $0x10,%edx
8010335c:	89 04 95 6c 22 11 80 	mov    %eax,-0x7feedd94(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103363:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103367:	a1 a8 22 11 80       	mov    0x801122a8,%eax
8010336c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010336f:	7f db                	jg     8010334c <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103371:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103374:	89 04 24             	mov    %eax,(%esp)
80103377:	e8 9b ce ff ff       	call   80100217 <brelse>
}
8010337c:	c9                   	leave  
8010337d:	c3                   	ret    

8010337e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010337e:	55                   	push   %ebp
8010337f:	89 e5                	mov    %esp,%ebp
80103381:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103384:	a1 94 22 11 80       	mov    0x80112294,%eax
80103389:	89 c2                	mov    %eax,%edx
8010338b:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103390:	89 54 24 04          	mov    %edx,0x4(%esp)
80103394:	89 04 24             	mov    %eax,(%esp)
80103397:	e8 0a ce ff ff       	call   801001a6 <bread>
8010339c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010339f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033a2:	83 c0 18             	add    $0x18,%eax
801033a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801033a8:	8b 15 a8 22 11 80    	mov    0x801122a8,%edx
801033ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033b1:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801033b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033ba:	eb 1b                	jmp    801033d7 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033bf:	83 c0 10             	add    $0x10,%eax
801033c2:	8b 0c 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%ecx
801033c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033cf:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801033d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033d7:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801033dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033df:	7f db                	jg     801033bc <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801033e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033e4:	89 04 24             	mov    %eax,(%esp)
801033e7:	e8 f1 cd ff ff       	call   801001dd <bwrite>
  brelse(buf);
801033ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033ef:	89 04 24             	mov    %eax,(%esp)
801033f2:	e8 20 ce ff ff       	call   80100217 <brelse>
}
801033f7:	c9                   	leave  
801033f8:	c3                   	ret    

801033f9 <recover_from_log>:

static void
recover_from_log(void)
{
801033f9:	55                   	push   %ebp
801033fa:	89 e5                	mov    %esp,%ebp
801033fc:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801033ff:	e8 0b ff ff ff       	call   8010330f <read_head>
  install_trans(); // if committed, copy from log to disk
80103404:	e8 58 fe ff ff       	call   80103261 <install_trans>
  log.lh.n = 0;
80103409:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
80103410:	00 00 00 
  write_head(); // clear the log
80103413:	e8 66 ff ff ff       	call   8010337e <write_head>
}
80103418:	c9                   	leave  
80103419:	c3                   	ret    

8010341a <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010341a:	55                   	push   %ebp
8010341b:	89 e5                	mov    %esp,%ebp
8010341d:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103420:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103427:	e8 d7 19 00 00       	call   80104e03 <acquire>
  while(1){
    if(log.committing){
8010342c:	a1 a0 22 11 80       	mov    0x801122a0,%eax
80103431:	85 c0                	test   %eax,%eax
80103433:	74 16                	je     8010344b <begin_op+0x31>
      sleep(&log, &log.lock);
80103435:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
8010343c:	80 
8010343d:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103444:	e8 ed 16 00 00       	call   80104b36 <sleep>
80103449:	eb 4f                	jmp    8010349a <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010344b:	8b 0d a8 22 11 80    	mov    0x801122a8,%ecx
80103451:	a1 9c 22 11 80       	mov    0x8011229c,%eax
80103456:	8d 50 01             	lea    0x1(%eax),%edx
80103459:	89 d0                	mov    %edx,%eax
8010345b:	c1 e0 02             	shl    $0x2,%eax
8010345e:	01 d0                	add    %edx,%eax
80103460:	01 c0                	add    %eax,%eax
80103462:	01 c8                	add    %ecx,%eax
80103464:	83 f8 1e             	cmp    $0x1e,%eax
80103467:	7e 16                	jle    8010347f <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103469:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
80103470:	80 
80103471:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103478:	e8 b9 16 00 00       	call   80104b36 <sleep>
8010347d:	eb 1b                	jmp    8010349a <begin_op+0x80>
    } else {
      log.outstanding += 1;
8010347f:	a1 9c 22 11 80       	mov    0x8011229c,%eax
80103484:	83 c0 01             	add    $0x1,%eax
80103487:	a3 9c 22 11 80       	mov    %eax,0x8011229c
      release(&log.lock);
8010348c:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103493:	e8 cd 19 00 00       	call   80104e65 <release>
      break;
80103498:	eb 02                	jmp    8010349c <begin_op+0x82>
    }
  }
8010349a:	eb 90                	jmp    8010342c <begin_op+0x12>
}
8010349c:	c9                   	leave  
8010349d:	c3                   	ret    

8010349e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010349e:	55                   	push   %ebp
8010349f:	89 e5                	mov    %esp,%ebp
801034a1:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
801034a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801034ab:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801034b2:	e8 4c 19 00 00       	call   80104e03 <acquire>
  log.outstanding -= 1;
801034b7:	a1 9c 22 11 80       	mov    0x8011229c,%eax
801034bc:	83 e8 01             	sub    $0x1,%eax
801034bf:	a3 9c 22 11 80       	mov    %eax,0x8011229c
  if(log.committing)
801034c4:	a1 a0 22 11 80       	mov    0x801122a0,%eax
801034c9:	85 c0                	test   %eax,%eax
801034cb:	74 0c                	je     801034d9 <end_op+0x3b>
    panic("log.committing");
801034cd:	c7 04 24 f0 85 10 80 	movl   $0x801085f0,(%esp)
801034d4:	e8 61 d0 ff ff       	call   8010053a <panic>
  if(log.outstanding == 0){
801034d9:	a1 9c 22 11 80       	mov    0x8011229c,%eax
801034de:	85 c0                	test   %eax,%eax
801034e0:	75 13                	jne    801034f5 <end_op+0x57>
    do_commit = 1;
801034e2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801034e9:	c7 05 a0 22 11 80 01 	movl   $0x1,0x801122a0
801034f0:	00 00 00 
801034f3:	eb 0c                	jmp    80103501 <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801034f5:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801034fc:	e8 0e 17 00 00       	call   80104c0f <wakeup>
  }
  release(&log.lock);
80103501:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103508:	e8 58 19 00 00       	call   80104e65 <release>

  if(do_commit){
8010350d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103511:	74 33                	je     80103546 <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103513:	e8 de 00 00 00       	call   801035f6 <commit>
    acquire(&log.lock);
80103518:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010351f:	e8 df 18 00 00       	call   80104e03 <acquire>
    log.committing = 0;
80103524:	c7 05 a0 22 11 80 00 	movl   $0x0,0x801122a0
8010352b:	00 00 00 
    wakeup(&log);
8010352e:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103535:	e8 d5 16 00 00       	call   80104c0f <wakeup>
    release(&log.lock);
8010353a:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103541:	e8 1f 19 00 00       	call   80104e65 <release>
  }
}
80103546:	c9                   	leave  
80103547:	c3                   	ret    

80103548 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103548:	55                   	push   %ebp
80103549:	89 e5                	mov    %esp,%ebp
8010354b:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010354e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103555:	e9 8c 00 00 00       	jmp    801035e6 <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010355a:	8b 15 94 22 11 80    	mov    0x80112294,%edx
80103560:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103563:	01 d0                	add    %edx,%eax
80103565:	83 c0 01             	add    $0x1,%eax
80103568:	89 c2                	mov    %eax,%edx
8010356a:	a1 a4 22 11 80       	mov    0x801122a4,%eax
8010356f:	89 54 24 04          	mov    %edx,0x4(%esp)
80103573:	89 04 24             	mov    %eax,(%esp)
80103576:	e8 2b cc ff ff       	call   801001a6 <bread>
8010357b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
8010357e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103581:	83 c0 10             	add    $0x10,%eax
80103584:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
8010358b:	89 c2                	mov    %eax,%edx
8010358d:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103592:	89 54 24 04          	mov    %edx,0x4(%esp)
80103596:	89 04 24             	mov    %eax,(%esp)
80103599:	e8 08 cc ff ff       	call   801001a6 <bread>
8010359e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801035a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035a4:	8d 50 18             	lea    0x18(%eax),%edx
801035a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035aa:	83 c0 18             	add    $0x18,%eax
801035ad:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801035b4:	00 
801035b5:	89 54 24 04          	mov    %edx,0x4(%esp)
801035b9:	89 04 24             	mov    %eax,(%esp)
801035bc:	e8 68 1b 00 00       	call   80105129 <memmove>
    bwrite(to);  // write the log
801035c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035c4:	89 04 24             	mov    %eax,(%esp)
801035c7:	e8 11 cc ff ff       	call   801001dd <bwrite>
    brelse(from); 
801035cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035cf:	89 04 24             	mov    %eax,(%esp)
801035d2:	e8 40 cc ff ff       	call   80100217 <brelse>
    brelse(to);
801035d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035da:	89 04 24             	mov    %eax,(%esp)
801035dd:	e8 35 cc ff ff       	call   80100217 <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035e2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035e6:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801035eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035ee:	0f 8f 66 ff ff ff    	jg     8010355a <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801035f4:	c9                   	leave  
801035f5:	c3                   	ret    

801035f6 <commit>:

static void
commit()
{
801035f6:	55                   	push   %ebp
801035f7:	89 e5                	mov    %esp,%ebp
801035f9:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801035fc:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103601:	85 c0                	test   %eax,%eax
80103603:	7e 1e                	jle    80103623 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103605:	e8 3e ff ff ff       	call   80103548 <write_log>
    write_head();    // Write header to disk -- the real commit
8010360a:	e8 6f fd ff ff       	call   8010337e <write_head>
    install_trans(); // Now install writes to home locations
8010360f:	e8 4d fc ff ff       	call   80103261 <install_trans>
    log.lh.n = 0; 
80103614:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
8010361b:	00 00 00 
    write_head();    // Erase the transaction from the log
8010361e:	e8 5b fd ff ff       	call   8010337e <write_head>
  }
}
80103623:	c9                   	leave  
80103624:	c3                   	ret    

80103625 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103625:	55                   	push   %ebp
80103626:	89 e5                	mov    %esp,%ebp
80103628:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010362b:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103630:	83 f8 1d             	cmp    $0x1d,%eax
80103633:	7f 12                	jg     80103647 <log_write+0x22>
80103635:	a1 a8 22 11 80       	mov    0x801122a8,%eax
8010363a:	8b 15 98 22 11 80    	mov    0x80112298,%edx
80103640:	83 ea 01             	sub    $0x1,%edx
80103643:	39 d0                	cmp    %edx,%eax
80103645:	7c 0c                	jl     80103653 <log_write+0x2e>
    panic("too big a transaction");
80103647:	c7 04 24 ff 85 10 80 	movl   $0x801085ff,(%esp)
8010364e:	e8 e7 ce ff ff       	call   8010053a <panic>
  if (log.outstanding < 1)
80103653:	a1 9c 22 11 80       	mov    0x8011229c,%eax
80103658:	85 c0                	test   %eax,%eax
8010365a:	7f 0c                	jg     80103668 <log_write+0x43>
    panic("log_write outside of trans");
8010365c:	c7 04 24 15 86 10 80 	movl   $0x80108615,(%esp)
80103663:	e8 d2 ce ff ff       	call   8010053a <panic>

  acquire(&log.lock);
80103668:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010366f:	e8 8f 17 00 00       	call   80104e03 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103674:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010367b:	eb 1f                	jmp    8010369c <log_write+0x77>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
8010367d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103680:	83 c0 10             	add    $0x10,%eax
80103683:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
8010368a:	89 c2                	mov    %eax,%edx
8010368c:	8b 45 08             	mov    0x8(%ebp),%eax
8010368f:	8b 40 08             	mov    0x8(%eax),%eax
80103692:	39 c2                	cmp    %eax,%edx
80103694:	75 02                	jne    80103698 <log_write+0x73>
      break;
80103696:	eb 0e                	jmp    801036a6 <log_write+0x81>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103698:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010369c:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801036a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036a4:	7f d7                	jg     8010367d <log_write+0x58>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
  }
  log.lh.sector[i] = b->sector;
801036a6:	8b 45 08             	mov    0x8(%ebp),%eax
801036a9:	8b 40 08             	mov    0x8(%eax),%eax
801036ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036af:	83 c2 10             	add    $0x10,%edx
801036b2:	89 04 95 6c 22 11 80 	mov    %eax,-0x7feedd94(,%edx,4)
  if (i == log.lh.n)
801036b9:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801036be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036c1:	75 0d                	jne    801036d0 <log_write+0xab>
    log.lh.n++;
801036c3:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801036c8:	83 c0 01             	add    $0x1,%eax
801036cb:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  b->flags |= B_DIRTY; // prevent eviction
801036d0:	8b 45 08             	mov    0x8(%ebp),%eax
801036d3:	8b 00                	mov    (%eax),%eax
801036d5:	83 c8 04             	or     $0x4,%eax
801036d8:	89 c2                	mov    %eax,%edx
801036da:	8b 45 08             	mov    0x8(%ebp),%eax
801036dd:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801036df:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801036e6:	e8 7a 17 00 00       	call   80104e65 <release>
}
801036eb:	c9                   	leave  
801036ec:	c3                   	ret    
801036ed:	66 90                	xchg   %ax,%ax
801036ef:	90                   	nop

801036f0 <v2p>:
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	8b 45 08             	mov    0x8(%ebp),%eax
801036f6:	05 00 00 00 80       	add    $0x80000000,%eax
801036fb:	5d                   	pop    %ebp
801036fc:	c3                   	ret    

801036fd <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801036fd:	55                   	push   %ebp
801036fe:	89 e5                	mov    %esp,%ebp
80103700:	8b 45 08             	mov    0x8(%ebp),%eax
80103703:	05 00 00 00 80       	add    $0x80000000,%eax
80103708:	5d                   	pop    %ebp
80103709:	c3                   	ret    

8010370a <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010370a:	55                   	push   %ebp
8010370b:	89 e5                	mov    %esp,%ebp
8010370d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103710:	8b 55 08             	mov    0x8(%ebp),%edx
80103713:	8b 45 0c             	mov    0xc(%ebp),%eax
80103716:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103719:	f0 87 02             	lock xchg %eax,(%edx)
8010371c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010371f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103722:	c9                   	leave  
80103723:	c3                   	ret    

80103724 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103724:	55                   	push   %ebp
80103725:	89 e5                	mov    %esp,%ebp
80103727:	83 e4 f0             	and    $0xfffffff0,%esp
8010372a:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010372d:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103734:	80 
80103735:	c7 04 24 3c 51 11 80 	movl   $0x8011513c,(%esp)
8010373c:	e8 7c f2 ff ff       	call   801029bd <kinit1>
  kvmalloc();      // kernel page table
80103741:	e8 ec 44 00 00       	call   80107c32 <kvmalloc>
  mpinit();        // collect info about this machine
80103746:	e8 47 04 00 00       	call   80103b92 <mpinit>
  lapicinit();
8010374b:	e8 d8 f5 ff ff       	call   80102d28 <lapicinit>
  seginit();       // set up segments
80103750:	e8 70 3e 00 00       	call   801075c5 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103755:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010375b:	0f b6 00             	movzbl (%eax),%eax
8010375e:	0f b6 c0             	movzbl %al,%eax
80103761:	89 44 24 04          	mov    %eax,0x4(%esp)
80103765:	c7 04 24 30 86 10 80 	movl   $0x80108630,(%esp)
8010376c:	e8 2f cc ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
80103771:	e8 7d 06 00 00       	call   80103df3 <picinit>
  ioapicinit();    // another interrupt controller
80103776:	e8 36 f1 ff ff       	call   801028b1 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010377b:	e8 01 d3 ff ff       	call   80100a81 <consoleinit>
  uartinit();      // serial port
80103780:	e8 8a 31 00 00       	call   8010690f <uartinit>
  pinit();         // process table
80103785:	e8 78 0b 00 00       	call   80104302 <pinit>
  tvinit();        // trap vectors
8010378a:	e8 2f 2d 00 00       	call   801064be <tvinit>
  binit();         // buffer cache
8010378f:	e8 a0 c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103794:	e8 73 d7 ff ff       	call   80100f0c <fileinit>
  iinit();         // inode cache
80103799:	e8 09 de ff ff       	call   801015a7 <iinit>
  ideinit();       // disk
8010379e:	e8 76 ed ff ff       	call   80102519 <ideinit>
  if(!ismp)
801037a3:	a1 44 23 11 80       	mov    0x80112344,%eax
801037a8:	85 c0                	test   %eax,%eax
801037aa:	75 05                	jne    801037b1 <main+0x8d>
    timerinit();   // uniprocessor timer
801037ac:	e8 55 2c 00 00       	call   80106406 <timerinit>
  startothers();   // start other processors
801037b1:	e8 7f 00 00 00       	call   80103835 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037b6:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801037bd:	8e 
801037be:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801037c5:	e8 2b f2 ff ff       	call   801029f5 <kinit2>
  userinit();      // first user process
801037ca:	e8 4e 0c 00 00       	call   8010441d <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801037cf:	e8 1a 00 00 00       	call   801037ee <mpmain>

801037d4 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801037d4:	55                   	push   %ebp
801037d5:	89 e5                	mov    %esp,%ebp
801037d7:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801037da:	e8 6a 44 00 00       	call   80107c49 <switchkvm>
  seginit();
801037df:	e8 e1 3d 00 00       	call   801075c5 <seginit>
  lapicinit();
801037e4:	e8 3f f5 ff ff       	call   80102d28 <lapicinit>
  mpmain();
801037e9:	e8 00 00 00 00       	call   801037ee <mpmain>

801037ee <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801037ee:	55                   	push   %ebp
801037ef:	89 e5                	mov    %esp,%ebp
801037f1:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801037f4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801037fa:	0f b6 00             	movzbl (%eax),%eax
801037fd:	0f b6 c0             	movzbl %al,%eax
80103800:	89 44 24 04          	mov    %eax,0x4(%esp)
80103804:	c7 04 24 47 86 10 80 	movl   $0x80108647,(%esp)
8010380b:	e8 90 cb ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
80103810:	e8 1d 2e 00 00       	call   80106632 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103815:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010381b:	05 a8 00 00 00       	add    $0xa8,%eax
80103820:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103827:	00 
80103828:	89 04 24             	mov    %eax,(%esp)
8010382b:	e8 da fe ff ff       	call   8010370a <xchg>
  scheduler();     // start running processes
80103830:	e8 59 11 00 00       	call   8010498e <scheduler>

80103835 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103835:	55                   	push   %ebp
80103836:	89 e5                	mov    %esp,%ebp
80103838:	53                   	push   %ebx
80103839:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010383c:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103843:	e8 b5 fe ff ff       	call   801036fd <p2v>
80103848:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010384b:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103850:	89 44 24 08          	mov    %eax,0x8(%esp)
80103854:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
8010385b:	80 
8010385c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010385f:	89 04 24             	mov    %eax,(%esp)
80103862:	e8 c2 18 00 00       	call   80105129 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103867:	c7 45 f4 60 23 11 80 	movl   $0x80112360,-0xc(%ebp)
8010386e:	e9 85 00 00 00       	jmp    801038f8 <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
80103873:	e8 09 f6 ff ff       	call   80102e81 <cpunum>
80103878:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010387e:	05 60 23 11 80       	add    $0x80112360,%eax
80103883:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103886:	75 02                	jne    8010388a <startothers+0x55>
      continue;
80103888:	eb 67                	jmp    801038f1 <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010388a:	e8 5c f2 ff ff       	call   80102aeb <kalloc>
8010388f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103892:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103895:	83 e8 04             	sub    $0x4,%eax
80103898:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010389b:	81 c2 00 10 00 00    	add    $0x1000,%edx
801038a1:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801038a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a6:	83 e8 08             	sub    $0x8,%eax
801038a9:	c7 00 d4 37 10 80    	movl   $0x801037d4,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801038af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038b2:	8d 58 f4             	lea    -0xc(%eax),%ebx
801038b5:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
801038bc:	e8 2f fe ff ff       	call   801036f0 <v2p>
801038c1:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801038c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c6:	89 04 24             	mov    %eax,(%esp)
801038c9:	e8 22 fe ff ff       	call   801036f0 <v2p>
801038ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038d1:	0f b6 12             	movzbl (%edx),%edx
801038d4:	0f b6 d2             	movzbl %dl,%edx
801038d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801038db:	89 14 24             	mov    %edx,(%esp)
801038de:	e8 20 f6 ff ff       	call   80102f03 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801038e3:	90                   	nop
801038e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038e7:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801038ed:	85 c0                	test   %eax,%eax
801038ef:	74 f3                	je     801038e4 <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801038f1:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801038f8:	a1 40 29 11 80       	mov    0x80112940,%eax
801038fd:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103903:	05 60 23 11 80       	add    $0x80112360,%eax
80103908:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010390b:	0f 87 62 ff ff ff    	ja     80103873 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103911:	83 c4 24             	add    $0x24,%esp
80103914:	5b                   	pop    %ebx
80103915:	5d                   	pop    %ebp
80103916:	c3                   	ret    
80103917:	90                   	nop

80103918 <p2v>:
80103918:	55                   	push   %ebp
80103919:	89 e5                	mov    %esp,%ebp
8010391b:	8b 45 08             	mov    0x8(%ebp),%eax
8010391e:	05 00 00 00 80       	add    $0x80000000,%eax
80103923:	5d                   	pop    %ebp
80103924:	c3                   	ret    

80103925 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103925:	55                   	push   %ebp
80103926:	89 e5                	mov    %esp,%ebp
80103928:	83 ec 14             	sub    $0x14,%esp
8010392b:	8b 45 08             	mov    0x8(%ebp),%eax
8010392e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103932:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103936:	89 c2                	mov    %eax,%edx
80103938:	ec                   	in     (%dx),%al
80103939:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010393c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103940:	c9                   	leave  
80103941:	c3                   	ret    

80103942 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103942:	55                   	push   %ebp
80103943:	89 e5                	mov    %esp,%ebp
80103945:	83 ec 08             	sub    $0x8,%esp
80103948:	8b 55 08             	mov    0x8(%ebp),%edx
8010394b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010394e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103952:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103955:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103959:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010395d:	ee                   	out    %al,(%dx)
}
8010395e:	c9                   	leave  
8010395f:	c3                   	ret    

80103960 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103963:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80103968:	89 c2                	mov    %eax,%edx
8010396a:	b8 60 23 11 80       	mov    $0x80112360,%eax
8010396f:	29 c2                	sub    %eax,%edx
80103971:	89 d0                	mov    %edx,%eax
80103973:	c1 f8 02             	sar    $0x2,%eax
80103976:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
8010397c:	5d                   	pop    %ebp
8010397d:	c3                   	ret    

8010397e <sum>:

static uchar
sum(uchar *addr, int len)
{
8010397e:	55                   	push   %ebp
8010397f:	89 e5                	mov    %esp,%ebp
80103981:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103984:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010398b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103992:	eb 15                	jmp    801039a9 <sum+0x2b>
    sum += addr[i];
80103994:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103997:	8b 45 08             	mov    0x8(%ebp),%eax
8010399a:	01 d0                	add    %edx,%eax
8010399c:	0f b6 00             	movzbl (%eax),%eax
8010399f:	0f b6 c0             	movzbl %al,%eax
801039a2:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
801039a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801039a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801039ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
801039af:	7c e3                	jl     80103994 <sum+0x16>
    sum += addr[i];
  return sum;
801039b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801039b4:	c9                   	leave  
801039b5:	c3                   	ret    

801039b6 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801039b6:	55                   	push   %ebp
801039b7:	89 e5                	mov    %esp,%ebp
801039b9:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801039bc:	8b 45 08             	mov    0x8(%ebp),%eax
801039bf:	89 04 24             	mov    %eax,(%esp)
801039c2:	e8 51 ff ff ff       	call   80103918 <p2v>
801039c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801039ca:	8b 55 0c             	mov    0xc(%ebp),%edx
801039cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039d0:	01 d0                	add    %edx,%eax
801039d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801039d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801039db:	eb 3f                	jmp    80103a1c <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039dd:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801039e4:	00 
801039e5:	c7 44 24 04 58 86 10 	movl   $0x80108658,0x4(%esp)
801039ec:	80 
801039ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039f0:	89 04 24             	mov    %eax,(%esp)
801039f3:	e8 d9 16 00 00       	call   801050d1 <memcmp>
801039f8:	85 c0                	test   %eax,%eax
801039fa:	75 1c                	jne    80103a18 <mpsearch1+0x62>
801039fc:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103a03:	00 
80103a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a07:	89 04 24             	mov    %eax,(%esp)
80103a0a:	e8 6f ff ff ff       	call   8010397e <sum>
80103a0f:	84 c0                	test   %al,%al
80103a11:	75 05                	jne    80103a18 <mpsearch1+0x62>
      return (struct mp*)p;
80103a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a16:	eb 11                	jmp    80103a29 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103a18:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a1f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a22:	72 b9                	jb     801039dd <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103a24:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a29:	c9                   	leave  
80103a2a:	c3                   	ret    

80103a2b <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103a2b:	55                   	push   %ebp
80103a2c:	89 e5                	mov    %esp,%ebp
80103a2e:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103a31:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a3b:	83 c0 0f             	add    $0xf,%eax
80103a3e:	0f b6 00             	movzbl (%eax),%eax
80103a41:	0f b6 c0             	movzbl %al,%eax
80103a44:	c1 e0 08             	shl    $0x8,%eax
80103a47:	89 c2                	mov    %eax,%edx
80103a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a4c:	83 c0 0e             	add    $0xe,%eax
80103a4f:	0f b6 00             	movzbl (%eax),%eax
80103a52:	0f b6 c0             	movzbl %al,%eax
80103a55:	09 d0                	or     %edx,%eax
80103a57:	c1 e0 04             	shl    $0x4,%eax
80103a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103a61:	74 21                	je     80103a84 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103a63:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a6a:	00 
80103a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a6e:	89 04 24             	mov    %eax,(%esp)
80103a71:	e8 40 ff ff ff       	call   801039b6 <mpsearch1>
80103a76:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a7d:	74 50                	je     80103acf <mpsearch+0xa4>
      return mp;
80103a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a82:	eb 5f                	jmp    80103ae3 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a87:	83 c0 14             	add    $0x14,%eax
80103a8a:	0f b6 00             	movzbl (%eax),%eax
80103a8d:	0f b6 c0             	movzbl %al,%eax
80103a90:	c1 e0 08             	shl    $0x8,%eax
80103a93:	89 c2                	mov    %eax,%edx
80103a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a98:	83 c0 13             	add    $0x13,%eax
80103a9b:	0f b6 00             	movzbl (%eax),%eax
80103a9e:	0f b6 c0             	movzbl %al,%eax
80103aa1:	09 d0                	or     %edx,%eax
80103aa3:	c1 e0 0a             	shl    $0xa,%eax
80103aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aac:	2d 00 04 00 00       	sub    $0x400,%eax
80103ab1:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103ab8:	00 
80103ab9:	89 04 24             	mov    %eax,(%esp)
80103abc:	e8 f5 fe ff ff       	call   801039b6 <mpsearch1>
80103ac1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ac4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ac8:	74 05                	je     80103acf <mpsearch+0xa4>
      return mp;
80103aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103acd:	eb 14                	jmp    80103ae3 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103acf:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103ad6:	00 
80103ad7:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103ade:	e8 d3 fe ff ff       	call   801039b6 <mpsearch1>
}
80103ae3:	c9                   	leave  
80103ae4:	c3                   	ret    

80103ae5 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ae5:	55                   	push   %ebp
80103ae6:	89 e5                	mov    %esp,%ebp
80103ae8:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103aeb:	e8 3b ff ff ff       	call   80103a2b <mpsearch>
80103af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103af7:	74 0a                	je     80103b03 <mpconfig+0x1e>
80103af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103afc:	8b 40 04             	mov    0x4(%eax),%eax
80103aff:	85 c0                	test   %eax,%eax
80103b01:	75 0a                	jne    80103b0d <mpconfig+0x28>
    return 0;
80103b03:	b8 00 00 00 00       	mov    $0x0,%eax
80103b08:	e9 83 00 00 00       	jmp    80103b90 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b10:	8b 40 04             	mov    0x4(%eax),%eax
80103b13:	89 04 24             	mov    %eax,(%esp)
80103b16:	e8 fd fd ff ff       	call   80103918 <p2v>
80103b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b1e:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103b25:	00 
80103b26:	c7 44 24 04 5d 86 10 	movl   $0x8010865d,0x4(%esp)
80103b2d:	80 
80103b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b31:	89 04 24             	mov    %eax,(%esp)
80103b34:	e8 98 15 00 00       	call   801050d1 <memcmp>
80103b39:	85 c0                	test   %eax,%eax
80103b3b:	74 07                	je     80103b44 <mpconfig+0x5f>
    return 0;
80103b3d:	b8 00 00 00 00       	mov    $0x0,%eax
80103b42:	eb 4c                	jmp    80103b90 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b47:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b4b:	3c 01                	cmp    $0x1,%al
80103b4d:	74 12                	je     80103b61 <mpconfig+0x7c>
80103b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b52:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b56:	3c 04                	cmp    $0x4,%al
80103b58:	74 07                	je     80103b61 <mpconfig+0x7c>
    return 0;
80103b5a:	b8 00 00 00 00       	mov    $0x0,%eax
80103b5f:	eb 2f                	jmp    80103b90 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b64:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103b68:	0f b7 c0             	movzwl %ax,%eax
80103b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b72:	89 04 24             	mov    %eax,(%esp)
80103b75:	e8 04 fe ff ff       	call   8010397e <sum>
80103b7a:	84 c0                	test   %al,%al
80103b7c:	74 07                	je     80103b85 <mpconfig+0xa0>
    return 0;
80103b7e:	b8 00 00 00 00       	mov    $0x0,%eax
80103b83:	eb 0b                	jmp    80103b90 <mpconfig+0xab>
  *pmp = mp;
80103b85:	8b 45 08             	mov    0x8(%ebp),%eax
80103b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b8b:	89 10                	mov    %edx,(%eax)
  return conf;
80103b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103b90:	c9                   	leave  
80103b91:	c3                   	ret    

80103b92 <mpinit>:

void
mpinit(void)
{
80103b92:	55                   	push   %ebp
80103b93:	89 e5                	mov    %esp,%ebp
80103b95:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103b98:	c7 05 44 b6 10 80 60 	movl   $0x80112360,0x8010b644
80103b9f:	23 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103ba2:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103ba5:	89 04 24             	mov    %eax,(%esp)
80103ba8:	e8 38 ff ff ff       	call   80103ae5 <mpconfig>
80103bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103bb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103bb4:	75 05                	jne    80103bbb <mpinit+0x29>
    return;
80103bb6:	e9 9c 01 00 00       	jmp    80103d57 <mpinit+0x1c5>
  ismp = 1;
80103bbb:	c7 05 44 23 11 80 01 	movl   $0x1,0x80112344
80103bc2:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bc8:	8b 40 24             	mov    0x24(%eax),%eax
80103bcb:	a3 5c 22 11 80       	mov    %eax,0x8011225c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bd3:	83 c0 2c             	add    $0x2c,%eax
80103bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bdc:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103be0:	0f b7 d0             	movzwl %ax,%edx
80103be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103be6:	01 d0                	add    %edx,%eax
80103be8:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103beb:	e9 f4 00 00 00       	jmp    80103ce4 <mpinit+0x152>
    switch(*p){
80103bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf3:	0f b6 00             	movzbl (%eax),%eax
80103bf6:	0f b6 c0             	movzbl %al,%eax
80103bf9:	83 f8 04             	cmp    $0x4,%eax
80103bfc:	0f 87 bf 00 00 00    	ja     80103cc1 <mpinit+0x12f>
80103c02:	8b 04 85 a0 86 10 80 	mov    -0x7fef7960(,%eax,4),%eax
80103c09:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103c11:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c14:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c18:	0f b6 d0             	movzbl %al,%edx
80103c1b:	a1 40 29 11 80       	mov    0x80112940,%eax
80103c20:	39 c2                	cmp    %eax,%edx
80103c22:	74 2d                	je     80103c51 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103c24:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c27:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c2b:	0f b6 d0             	movzbl %al,%edx
80103c2e:	a1 40 29 11 80       	mov    0x80112940,%eax
80103c33:	89 54 24 08          	mov    %edx,0x8(%esp)
80103c37:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c3b:	c7 04 24 62 86 10 80 	movl   $0x80108662,(%esp)
80103c42:	e8 59 c7 ff ff       	call   801003a0 <cprintf>
        ismp = 0;
80103c47:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103c4e:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103c51:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c54:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103c58:	0f b6 c0             	movzbl %al,%eax
80103c5b:	83 e0 02             	and    $0x2,%eax
80103c5e:	85 c0                	test   %eax,%eax
80103c60:	74 15                	je     80103c77 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103c62:	a1 40 29 11 80       	mov    0x80112940,%eax
80103c67:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103c6d:	05 60 23 11 80       	add    $0x80112360,%eax
80103c72:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103c77:	8b 15 40 29 11 80    	mov    0x80112940,%edx
80103c7d:	a1 40 29 11 80       	mov    0x80112940,%eax
80103c82:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103c88:	81 c2 60 23 11 80    	add    $0x80112360,%edx
80103c8e:	88 02                	mov    %al,(%edx)
      ncpu++;
80103c90:	a1 40 29 11 80       	mov    0x80112940,%eax
80103c95:	83 c0 01             	add    $0x1,%eax
80103c98:	a3 40 29 11 80       	mov    %eax,0x80112940
      p += sizeof(struct mpproc);
80103c9d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103ca1:	eb 41                	jmp    80103ce4 <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103cac:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cb0:	a2 40 23 11 80       	mov    %al,0x80112340
      p += sizeof(struct mpioapic);
80103cb5:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cb9:	eb 29                	jmp    80103ce4 <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103cbb:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cbf:	eb 23                	jmp    80103ce4 <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc4:	0f b6 00             	movzbl (%eax),%eax
80103cc7:	0f b6 c0             	movzbl %al,%eax
80103cca:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cce:	c7 04 24 80 86 10 80 	movl   $0x80108680,(%esp)
80103cd5:	e8 c6 c6 ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103cda:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103ce1:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ce7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103cea:	0f 82 00 ff ff ff    	jb     80103bf0 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103cf0:	a1 44 23 11 80       	mov    0x80112344,%eax
80103cf5:	85 c0                	test   %eax,%eax
80103cf7:	75 1d                	jne    80103d16 <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103cf9:	c7 05 40 29 11 80 01 	movl   $0x1,0x80112940
80103d00:	00 00 00 
    lapic = 0;
80103d03:	c7 05 5c 22 11 80 00 	movl   $0x0,0x8011225c
80103d0a:	00 00 00 
    ioapicid = 0;
80103d0d:	c6 05 40 23 11 80 00 	movb   $0x0,0x80112340
    return;
80103d14:	eb 41                	jmp    80103d57 <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103d16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d19:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103d1d:	84 c0                	test   %al,%al
80103d1f:	74 36                	je     80103d57 <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103d21:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103d28:	00 
80103d29:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103d30:	e8 0d fc ff ff       	call   80103942 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103d35:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d3c:	e8 e4 fb ff ff       	call   80103925 <inb>
80103d41:	83 c8 01             	or     $0x1,%eax
80103d44:	0f b6 c0             	movzbl %al,%eax
80103d47:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d4b:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d52:	e8 eb fb ff ff       	call   80103942 <outb>
  }
}
80103d57:	c9                   	leave  
80103d58:	c3                   	ret    
80103d59:	66 90                	xchg   %ax,%ax
80103d5b:	90                   	nop

80103d5c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d5c:	55                   	push   %ebp
80103d5d:	89 e5                	mov    %esp,%ebp
80103d5f:	83 ec 08             	sub    $0x8,%esp
80103d62:	8b 55 08             	mov    0x8(%ebp),%edx
80103d65:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d68:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103d6c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d6f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103d73:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103d77:	ee                   	out    %al,(%dx)
}
80103d78:	c9                   	leave  
80103d79:	c3                   	ret    

80103d7a <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103d7a:	55                   	push   %ebp
80103d7b:	89 e5                	mov    %esp,%ebp
80103d7d:	83 ec 0c             	sub    $0xc,%esp
80103d80:	8b 45 08             	mov    0x8(%ebp),%eax
80103d83:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103d87:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103d8b:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103d91:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103d95:	0f b6 c0             	movzbl %al,%eax
80103d98:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d9c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103da3:	e8 b4 ff ff ff       	call   80103d5c <outb>
  outb(IO_PIC2+1, mask >> 8);
80103da8:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103dac:	66 c1 e8 08          	shr    $0x8,%ax
80103db0:	0f b6 c0             	movzbl %al,%eax
80103db3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103db7:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103dbe:	e8 99 ff ff ff       	call   80103d5c <outb>
}
80103dc3:	c9                   	leave  
80103dc4:	c3                   	ret    

80103dc5 <picenable>:

void
picenable(int irq)
{
80103dc5:	55                   	push   %ebp
80103dc6:	89 e5                	mov    %esp,%ebp
80103dc8:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dce:	ba 01 00 00 00       	mov    $0x1,%edx
80103dd3:	89 c1                	mov    %eax,%ecx
80103dd5:	d3 e2                	shl    %cl,%edx
80103dd7:	89 d0                	mov    %edx,%eax
80103dd9:	f7 d0                	not    %eax
80103ddb:	89 c2                	mov    %eax,%edx
80103ddd:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103de4:	21 d0                	and    %edx,%eax
80103de6:	0f b7 c0             	movzwl %ax,%eax
80103de9:	89 04 24             	mov    %eax,(%esp)
80103dec:	e8 89 ff ff ff       	call   80103d7a <picsetmask>
}
80103df1:	c9                   	leave  
80103df2:	c3                   	ret    

80103df3 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103df3:	55                   	push   %ebp
80103df4:	89 e5                	mov    %esp,%ebp
80103df6:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103df9:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e00:	00 
80103e01:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e08:	e8 4f ff ff ff       	call   80103d5c <outb>
  outb(IO_PIC2+1, 0xFF);
80103e0d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e14:	00 
80103e15:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e1c:	e8 3b ff ff ff       	call   80103d5c <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103e21:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103e28:	00 
80103e29:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103e30:	e8 27 ff ff ff       	call   80103d5c <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103e35:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103e3c:	00 
80103e3d:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e44:	e8 13 ff ff ff       	call   80103d5c <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103e49:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103e50:	00 
80103e51:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e58:	e8 ff fe ff ff       	call   80103d5c <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103e5d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103e64:	00 
80103e65:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e6c:	e8 eb fe ff ff       	call   80103d5c <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103e71:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103e78:	00 
80103e79:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103e80:	e8 d7 fe ff ff       	call   80103d5c <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103e85:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103e8c:	00 
80103e8d:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e94:	e8 c3 fe ff ff       	call   80103d5c <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103e99:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103ea0:	00 
80103ea1:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ea8:	e8 af fe ff ff       	call   80103d5c <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103ead:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103eb4:	00 
80103eb5:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ebc:	e8 9b fe ff ff       	call   80103d5c <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103ec1:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103ec8:	00 
80103ec9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ed0:	e8 87 fe ff ff       	call   80103d5c <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103ed5:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103edc:	00 
80103edd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ee4:	e8 73 fe ff ff       	call   80103d5c <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103ee9:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103ef0:	00 
80103ef1:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103ef8:	e8 5f fe ff ff       	call   80103d5c <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103efd:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f04:	00 
80103f05:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f0c:	e8 4b fe ff ff       	call   80103d5c <outb>

  if(irqmask != 0xFFFF)
80103f11:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f18:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f1c:	74 12                	je     80103f30 <picinit+0x13d>
    picsetmask(irqmask);
80103f1e:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f25:	0f b7 c0             	movzwl %ax,%eax
80103f28:	89 04 24             	mov    %eax,(%esp)
80103f2b:	e8 4a fe ff ff       	call   80103d7a <picsetmask>
}
80103f30:	c9                   	leave  
80103f31:	c3                   	ret    
80103f32:	66 90                	xchg   %ax,%ax

80103f34 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f34:	55                   	push   %ebp
80103f35:	89 e5                	mov    %esp,%ebp
80103f37:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103f3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f41:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f4d:	8b 10                	mov    (%eax),%edx
80103f4f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f52:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103f54:	e8 cf cf ff ff       	call   80100f28 <filealloc>
80103f59:	8b 55 08             	mov    0x8(%ebp),%edx
80103f5c:	89 02                	mov    %eax,(%edx)
80103f5e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f61:	8b 00                	mov    (%eax),%eax
80103f63:	85 c0                	test   %eax,%eax
80103f65:	0f 84 c8 00 00 00    	je     80104033 <pipealloc+0xff>
80103f6b:	e8 b8 cf ff ff       	call   80100f28 <filealloc>
80103f70:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f73:	89 02                	mov    %eax,(%edx)
80103f75:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f78:	8b 00                	mov    (%eax),%eax
80103f7a:	85 c0                	test   %eax,%eax
80103f7c:	0f 84 b1 00 00 00    	je     80104033 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103f82:	e8 64 eb ff ff       	call   80102aeb <kalloc>
80103f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f8e:	75 05                	jne    80103f95 <pipealloc+0x61>
    goto bad;
80103f90:	e9 9e 00 00 00       	jmp    80104033 <pipealloc+0xff>
  p->readopen = 1;
80103f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f98:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103f9f:	00 00 00 
  p->writeopen = 1;
80103fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fa5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103fac:	00 00 00 
  p->nwrite = 0;
80103faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fb2:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103fb9:	00 00 00 
  p->nread = 0;
80103fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fbf:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103fc6:	00 00 00 
  initlock(&p->lock, "pipe");
80103fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fcc:	c7 44 24 04 b4 86 10 	movl   $0x801086b4,0x4(%esp)
80103fd3:	80 
80103fd4:	89 04 24             	mov    %eax,(%esp)
80103fd7:	e8 06 0e 00 00       	call   80104de2 <initlock>
  (*f0)->type = FD_PIPE;
80103fdc:	8b 45 08             	mov    0x8(%ebp),%eax
80103fdf:	8b 00                	mov    (%eax),%eax
80103fe1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103fe7:	8b 45 08             	mov    0x8(%ebp),%eax
80103fea:	8b 00                	mov    (%eax),%eax
80103fec:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff3:	8b 00                	mov    (%eax),%eax
80103ff5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103ff9:	8b 45 08             	mov    0x8(%ebp),%eax
80103ffc:	8b 00                	mov    (%eax),%eax
80103ffe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104001:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104004:	8b 45 0c             	mov    0xc(%ebp),%eax
80104007:	8b 00                	mov    (%eax),%eax
80104009:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010400f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104012:	8b 00                	mov    (%eax),%eax
80104014:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104018:	8b 45 0c             	mov    0xc(%ebp),%eax
8010401b:	8b 00                	mov    (%eax),%eax
8010401d:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104021:	8b 45 0c             	mov    0xc(%ebp),%eax
80104024:	8b 00                	mov    (%eax),%eax
80104026:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104029:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010402c:	b8 00 00 00 00       	mov    $0x0,%eax
80104031:	eb 42                	jmp    80104075 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80104033:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104037:	74 0b                	je     80104044 <pipealloc+0x110>
    kfree((char*)p);
80104039:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403c:	89 04 24             	mov    %eax,(%esp)
8010403f:	e8 0e ea ff ff       	call   80102a52 <kfree>
  if(*f0)
80104044:	8b 45 08             	mov    0x8(%ebp),%eax
80104047:	8b 00                	mov    (%eax),%eax
80104049:	85 c0                	test   %eax,%eax
8010404b:	74 0d                	je     8010405a <pipealloc+0x126>
    fileclose(*f0);
8010404d:	8b 45 08             	mov    0x8(%ebp),%eax
80104050:	8b 00                	mov    (%eax),%eax
80104052:	89 04 24             	mov    %eax,(%esp)
80104055:	e8 76 cf ff ff       	call   80100fd0 <fileclose>
  if(*f1)
8010405a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010405d:	8b 00                	mov    (%eax),%eax
8010405f:	85 c0                	test   %eax,%eax
80104061:	74 0d                	je     80104070 <pipealloc+0x13c>
    fileclose(*f1);
80104063:	8b 45 0c             	mov    0xc(%ebp),%eax
80104066:	8b 00                	mov    (%eax),%eax
80104068:	89 04 24             	mov    %eax,(%esp)
8010406b:	e8 60 cf ff ff       	call   80100fd0 <fileclose>
  return -1;
80104070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104075:	c9                   	leave  
80104076:	c3                   	ret    

80104077 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104077:	55                   	push   %ebp
80104078:	89 e5                	mov    %esp,%ebp
8010407a:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
8010407d:	8b 45 08             	mov    0x8(%ebp),%eax
80104080:	89 04 24             	mov    %eax,(%esp)
80104083:	e8 7b 0d 00 00       	call   80104e03 <acquire>
  if(writable){
80104088:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010408c:	74 1f                	je     801040ad <pipeclose+0x36>
    p->writeopen = 0;
8010408e:	8b 45 08             	mov    0x8(%ebp),%eax
80104091:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104098:	00 00 00 
    wakeup(&p->nread);
8010409b:	8b 45 08             	mov    0x8(%ebp),%eax
8010409e:	05 34 02 00 00       	add    $0x234,%eax
801040a3:	89 04 24             	mov    %eax,(%esp)
801040a6:	e8 64 0b 00 00       	call   80104c0f <wakeup>
801040ab:	eb 1d                	jmp    801040ca <pipeclose+0x53>
  } else {
    p->readopen = 0;
801040ad:	8b 45 08             	mov    0x8(%ebp),%eax
801040b0:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801040b7:	00 00 00 
    wakeup(&p->nwrite);
801040ba:	8b 45 08             	mov    0x8(%ebp),%eax
801040bd:	05 38 02 00 00       	add    $0x238,%eax
801040c2:	89 04 24             	mov    %eax,(%esp)
801040c5:	e8 45 0b 00 00       	call   80104c0f <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
801040ca:	8b 45 08             	mov    0x8(%ebp),%eax
801040cd:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801040d3:	85 c0                	test   %eax,%eax
801040d5:	75 25                	jne    801040fc <pipeclose+0x85>
801040d7:	8b 45 08             	mov    0x8(%ebp),%eax
801040da:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801040e0:	85 c0                	test   %eax,%eax
801040e2:	75 18                	jne    801040fc <pipeclose+0x85>
    release(&p->lock);
801040e4:	8b 45 08             	mov    0x8(%ebp),%eax
801040e7:	89 04 24             	mov    %eax,(%esp)
801040ea:	e8 76 0d 00 00       	call   80104e65 <release>
    kfree((char*)p);
801040ef:	8b 45 08             	mov    0x8(%ebp),%eax
801040f2:	89 04 24             	mov    %eax,(%esp)
801040f5:	e8 58 e9 ff ff       	call   80102a52 <kfree>
801040fa:	eb 0b                	jmp    80104107 <pipeclose+0x90>
  } else
    release(&p->lock);
801040fc:	8b 45 08             	mov    0x8(%ebp),%eax
801040ff:	89 04 24             	mov    %eax,(%esp)
80104102:	e8 5e 0d 00 00       	call   80104e65 <release>
}
80104107:	c9                   	leave  
80104108:	c3                   	ret    

80104109 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104109:	55                   	push   %ebp
8010410a:	89 e5                	mov    %esp,%ebp
8010410c:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
8010410f:	8b 45 08             	mov    0x8(%ebp),%eax
80104112:	89 04 24             	mov    %eax,(%esp)
80104115:	e8 e9 0c 00 00       	call   80104e03 <acquire>
  for(i = 0; i < n; i++){
8010411a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104121:	e9 a6 00 00 00       	jmp    801041cc <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104126:	eb 57                	jmp    8010417f <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
80104128:	8b 45 08             	mov    0x8(%ebp),%eax
8010412b:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104131:	85 c0                	test   %eax,%eax
80104133:	74 0d                	je     80104142 <pipewrite+0x39>
80104135:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010413b:	8b 40 24             	mov    0x24(%eax),%eax
8010413e:	85 c0                	test   %eax,%eax
80104140:	74 15                	je     80104157 <pipewrite+0x4e>
        release(&p->lock);
80104142:	8b 45 08             	mov    0x8(%ebp),%eax
80104145:	89 04 24             	mov    %eax,(%esp)
80104148:	e8 18 0d 00 00       	call   80104e65 <release>
        return -1;
8010414d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104152:	e9 9f 00 00 00       	jmp    801041f6 <pipewrite+0xed>
      }
      wakeup(&p->nread);
80104157:	8b 45 08             	mov    0x8(%ebp),%eax
8010415a:	05 34 02 00 00       	add    $0x234,%eax
8010415f:	89 04 24             	mov    %eax,(%esp)
80104162:	e8 a8 0a 00 00       	call   80104c0f <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104167:	8b 45 08             	mov    0x8(%ebp),%eax
8010416a:	8b 55 08             	mov    0x8(%ebp),%edx
8010416d:	81 c2 38 02 00 00    	add    $0x238,%edx
80104173:	89 44 24 04          	mov    %eax,0x4(%esp)
80104177:	89 14 24             	mov    %edx,(%esp)
8010417a:	e8 b7 09 00 00       	call   80104b36 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010417f:	8b 45 08             	mov    0x8(%ebp),%eax
80104182:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104188:	8b 45 08             	mov    0x8(%ebp),%eax
8010418b:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104191:	05 00 02 00 00       	add    $0x200,%eax
80104196:	39 c2                	cmp    %eax,%edx
80104198:	74 8e                	je     80104128 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010419a:	8b 45 08             	mov    0x8(%ebp),%eax
8010419d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801041a3:	8d 48 01             	lea    0x1(%eax),%ecx
801041a6:	8b 55 08             	mov    0x8(%ebp),%edx
801041a9:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801041af:	25 ff 01 00 00       	and    $0x1ff,%eax
801041b4:	89 c1                	mov    %eax,%ecx
801041b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801041bc:	01 d0                	add    %edx,%eax
801041be:	0f b6 10             	movzbl (%eax),%edx
801041c1:	8b 45 08             	mov    0x8(%ebp),%eax
801041c4:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801041c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801041cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041cf:	3b 45 10             	cmp    0x10(%ebp),%eax
801041d2:	0f 8c 4e ff ff ff    	jl     80104126 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801041d8:	8b 45 08             	mov    0x8(%ebp),%eax
801041db:	05 34 02 00 00       	add    $0x234,%eax
801041e0:	89 04 24             	mov    %eax,(%esp)
801041e3:	e8 27 0a 00 00       	call   80104c0f <wakeup>
  release(&p->lock);
801041e8:	8b 45 08             	mov    0x8(%ebp),%eax
801041eb:	89 04 24             	mov    %eax,(%esp)
801041ee:	e8 72 0c 00 00       	call   80104e65 <release>
  return n;
801041f3:	8b 45 10             	mov    0x10(%ebp),%eax
}
801041f6:	c9                   	leave  
801041f7:	c3                   	ret    

801041f8 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801041f8:	55                   	push   %ebp
801041f9:	89 e5                	mov    %esp,%ebp
801041fb:	53                   	push   %ebx
801041fc:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
801041ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104202:	89 04 24             	mov    %eax,(%esp)
80104205:	e8 f9 0b 00 00       	call   80104e03 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010420a:	eb 3a                	jmp    80104246 <piperead+0x4e>
    if(proc->killed){
8010420c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104212:	8b 40 24             	mov    0x24(%eax),%eax
80104215:	85 c0                	test   %eax,%eax
80104217:	74 15                	je     8010422e <piperead+0x36>
      release(&p->lock);
80104219:	8b 45 08             	mov    0x8(%ebp),%eax
8010421c:	89 04 24             	mov    %eax,(%esp)
8010421f:	e8 41 0c 00 00       	call   80104e65 <release>
      return -1;
80104224:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104229:	e9 b5 00 00 00       	jmp    801042e3 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010422e:	8b 45 08             	mov    0x8(%ebp),%eax
80104231:	8b 55 08             	mov    0x8(%ebp),%edx
80104234:	81 c2 34 02 00 00    	add    $0x234,%edx
8010423a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010423e:	89 14 24             	mov    %edx,(%esp)
80104241:	e8 f0 08 00 00       	call   80104b36 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104246:	8b 45 08             	mov    0x8(%ebp),%eax
80104249:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010424f:	8b 45 08             	mov    0x8(%ebp),%eax
80104252:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104258:	39 c2                	cmp    %eax,%edx
8010425a:	75 0d                	jne    80104269 <piperead+0x71>
8010425c:	8b 45 08             	mov    0x8(%ebp),%eax
8010425f:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104265:	85 c0                	test   %eax,%eax
80104267:	75 a3                	jne    8010420c <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104270:	eb 4b                	jmp    801042bd <piperead+0xc5>
    if(p->nread == p->nwrite)
80104272:	8b 45 08             	mov    0x8(%ebp),%eax
80104275:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010427b:	8b 45 08             	mov    0x8(%ebp),%eax
8010427e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104284:	39 c2                	cmp    %eax,%edx
80104286:	75 02                	jne    8010428a <piperead+0x92>
      break;
80104288:	eb 3b                	jmp    801042c5 <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010428a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010428d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104290:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104293:	8b 45 08             	mov    0x8(%ebp),%eax
80104296:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010429c:	8d 48 01             	lea    0x1(%eax),%ecx
8010429f:	8b 55 08             	mov    0x8(%ebp),%edx
801042a2:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801042a8:	25 ff 01 00 00       	and    $0x1ff,%eax
801042ad:	89 c2                	mov    %eax,%edx
801042af:	8b 45 08             	mov    0x8(%ebp),%eax
801042b2:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801042b7:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c0:	3b 45 10             	cmp    0x10(%ebp),%eax
801042c3:	7c ad                	jl     80104272 <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801042c5:	8b 45 08             	mov    0x8(%ebp),%eax
801042c8:	05 38 02 00 00       	add    $0x238,%eax
801042cd:	89 04 24             	mov    %eax,(%esp)
801042d0:	e8 3a 09 00 00       	call   80104c0f <wakeup>
  release(&p->lock);
801042d5:	8b 45 08             	mov    0x8(%ebp),%eax
801042d8:	89 04 24             	mov    %eax,(%esp)
801042db:	e8 85 0b 00 00       	call   80104e65 <release>
  return i;
801042e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801042e3:	83 c4 24             	add    $0x24,%esp
801042e6:	5b                   	pop    %ebx
801042e7:	5d                   	pop    %ebp
801042e8:	c3                   	ret    
801042e9:	66 90                	xchg   %ax,%ax
801042eb:	90                   	nop

801042ec <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801042ec:	55                   	push   %ebp
801042ed:	89 e5                	mov    %esp,%ebp
801042ef:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042f2:	9c                   	pushf  
801042f3:	58                   	pop    %eax
801042f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801042f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801042fa:	c9                   	leave  
801042fb:	c3                   	ret    

801042fc <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801042fc:	55                   	push   %ebp
801042fd:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801042ff:	fb                   	sti    
}
80104300:	5d                   	pop    %ebp
80104301:	c3                   	ret    

80104302 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104302:	55                   	push   %ebp
80104303:	89 e5                	mov    %esp,%ebp
80104305:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104308:	c7 44 24 04 b9 86 10 	movl   $0x801086b9,0x4(%esp)
8010430f:	80 
80104310:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104317:	e8 c6 0a 00 00       	call   80104de2 <initlock>
}
8010431c:	c9                   	leave  
8010431d:	c3                   	ret    

8010431e <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010431e:	55                   	push   %ebp
8010431f:	89 e5                	mov    %esp,%ebp
80104321:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104324:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
8010432b:	e8 d3 0a 00 00       	call   80104e03 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104330:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104337:	eb 50                	jmp    80104389 <allocproc+0x6b>
    if(p->state == UNUSED)
80104339:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010433c:	8b 40 0c             	mov    0xc(%eax),%eax
8010433f:	85 c0                	test   %eax,%eax
80104341:	75 42                	jne    80104385 <allocproc+0x67>
      goto found;
80104343:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104344:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104347:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010434e:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104353:	8d 50 01             	lea    0x1(%eax),%edx
80104356:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
8010435c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010435f:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80104362:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104369:	e8 f7 0a 00 00       	call   80104e65 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010436e:	e8 78 e7 ff ff       	call   80102aeb <kalloc>
80104373:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104376:	89 42 08             	mov    %eax,0x8(%edx)
80104379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010437c:	8b 40 08             	mov    0x8(%eax),%eax
8010437f:	85 c0                	test   %eax,%eax
80104381:	75 33                	jne    801043b6 <allocproc+0x98>
80104383:	eb 20                	jmp    801043a5 <allocproc+0x87>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104385:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104389:	81 7d f4 94 48 11 80 	cmpl   $0x80114894,-0xc(%ebp)
80104390:	72 a7                	jb     80104339 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104392:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104399:	e8 c7 0a 00 00       	call   80104e65 <release>
  return 0;
8010439e:	b8 00 00 00 00       	mov    $0x0,%eax
801043a3:	eb 76                	jmp    8010441b <allocproc+0xfd>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801043a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801043af:	b8 00 00 00 00       	mov    $0x0,%eax
801043b4:	eb 65                	jmp    8010441b <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
801043b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b9:	8b 40 08             	mov    0x8(%eax),%eax
801043bc:	05 00 10 00 00       	add    $0x1000,%eax
801043c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801043c4:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801043c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043ce:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801043d1:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801043d5:	ba 78 64 10 80       	mov    $0x80106478,%edx
801043da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043dd:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801043df:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801043e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043e9:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801043ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ef:	8b 40 1c             	mov    0x1c(%eax),%eax
801043f2:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801043f9:	00 
801043fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104401:	00 
80104402:	89 04 24             	mov    %eax,(%esp)
80104405:	e8 50 0c 00 00       	call   8010505a <memset>
  p->context->eip = (uint)forkret;
8010440a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010440d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104410:	ba 0a 4b 10 80       	mov    $0x80104b0a,%edx
80104415:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104418:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010441b:	c9                   	leave  
8010441c:	c3                   	ret    

8010441d <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010441d:	55                   	push   %ebp
8010441e:	89 e5                	mov    %esp,%ebp
80104420:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104423:	e8 f6 fe ff ff       	call   8010431e <allocproc>
80104428:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010442b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010442e:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
80104433:	e8 3d 37 00 00       	call   80107b75 <setupkvm>
80104438:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010443b:	89 42 04             	mov    %eax,0x4(%edx)
8010443e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104441:	8b 40 04             	mov    0x4(%eax),%eax
80104444:	85 c0                	test   %eax,%eax
80104446:	75 0c                	jne    80104454 <userinit+0x37>
    panic("userinit: out of memory?");
80104448:	c7 04 24 c0 86 10 80 	movl   $0x801086c0,(%esp)
8010444f:	e8 e6 c0 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104454:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104459:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010445c:	8b 40 04             	mov    0x4(%eax),%eax
8010445f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104463:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
8010446a:	80 
8010446b:	89 04 24             	mov    %eax,(%esp)
8010446e:	e8 5a 39 00 00       	call   80107dcd <inituvm>
  p->sz = PGSIZE;
80104473:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104476:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010447c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447f:	8b 40 18             	mov    0x18(%eax),%eax
80104482:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104489:	00 
8010448a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104491:	00 
80104492:	89 04 24             	mov    %eax,(%esp)
80104495:	e8 c0 0b 00 00       	call   8010505a <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010449a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010449d:	8b 40 18             	mov    0x18(%eax),%eax
801044a0:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801044a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a9:	8b 40 18             	mov    0x18(%eax),%eax
801044ac:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801044b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b5:	8b 40 18             	mov    0x18(%eax),%eax
801044b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044bb:	8b 52 18             	mov    0x18(%edx),%edx
801044be:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801044c2:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801044c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c9:	8b 40 18             	mov    0x18(%eax),%eax
801044cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044cf:	8b 52 18             	mov    0x18(%edx),%edx
801044d2:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801044d6:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801044da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044dd:	8b 40 18             	mov    0x18(%eax),%eax
801044e0:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801044e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ea:	8b 40 18             	mov    0x18(%eax),%eax
801044ed:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801044f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f7:	8b 40 18             	mov    0x18(%eax),%eax
801044fa:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104501:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104504:	83 c0 6c             	add    $0x6c,%eax
80104507:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010450e:	00 
8010450f:	c7 44 24 04 d9 86 10 	movl   $0x801086d9,0x4(%esp)
80104516:	80 
80104517:	89 04 24             	mov    %eax,(%esp)
8010451a:	e8 5b 0d 00 00       	call   8010527a <safestrcpy>
  p->cwd = namei("/");
8010451f:	c7 04 24 e2 86 10 80 	movl   $0x801086e2,(%esp)
80104526:	e8 de de ff ff       	call   80102409 <namei>
8010452b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010452e:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104534:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
8010453b:	c9                   	leave  
8010453c:	c3                   	ret    

8010453d <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010453d:	55                   	push   %ebp
8010453e:	89 e5                	mov    %esp,%ebp
80104540:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104543:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104549:	8b 00                	mov    (%eax),%eax
8010454b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010454e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104552:	7e 34                	jle    80104588 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104554:	8b 55 08             	mov    0x8(%ebp),%edx
80104557:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455a:	01 c2                	add    %eax,%edx
8010455c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104562:	8b 40 04             	mov    0x4(%eax),%eax
80104565:	89 54 24 08          	mov    %edx,0x8(%esp)
80104569:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010456c:	89 54 24 04          	mov    %edx,0x4(%esp)
80104570:	89 04 24             	mov    %eax,(%esp)
80104573:	e8 cb 39 00 00       	call   80107f43 <allocuvm>
80104578:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010457b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010457f:	75 41                	jne    801045c2 <growproc+0x85>
      return -1;
80104581:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104586:	eb 58                	jmp    801045e0 <growproc+0xa3>
  } else if(n < 0){
80104588:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010458c:	79 34                	jns    801045c2 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010458e:	8b 55 08             	mov    0x8(%ebp),%edx
80104591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104594:	01 c2                	add    %eax,%edx
80104596:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010459c:	8b 40 04             	mov    0x4(%eax),%eax
8010459f:	89 54 24 08          	mov    %edx,0x8(%esp)
801045a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045a6:	89 54 24 04          	mov    %edx,0x4(%esp)
801045aa:	89 04 24             	mov    %eax,(%esp)
801045ad:	e8 6b 3a 00 00       	call   8010801d <deallocuvm>
801045b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801045b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045b9:	75 07                	jne    801045c2 <growproc+0x85>
      return -1;
801045bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045c0:	eb 1e                	jmp    801045e0 <growproc+0xa3>
  }
  proc->sz = sz;
801045c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045cb:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801045cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045d3:	89 04 24             	mov    %eax,(%esp)
801045d6:	e8 8b 36 00 00       	call   80107c66 <switchuvm>
  return 0;
801045db:	b8 00 00 00 00       	mov    $0x0,%eax
}
801045e0:	c9                   	leave  
801045e1:	c3                   	ret    

801045e2 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801045e2:	55                   	push   %ebp
801045e3:	89 e5                	mov    %esp,%ebp
801045e5:	57                   	push   %edi
801045e6:	56                   	push   %esi
801045e7:	53                   	push   %ebx
801045e8:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801045eb:	e8 2e fd ff ff       	call   8010431e <allocproc>
801045f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801045f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801045f7:	75 0a                	jne    80104603 <fork+0x21>
    return -1;
801045f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045fe:	e9 52 01 00 00       	jmp    80104755 <fork+0x173>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104603:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104609:	8b 10                	mov    (%eax),%edx
8010460b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104611:	8b 40 04             	mov    0x4(%eax),%eax
80104614:	89 54 24 04          	mov    %edx,0x4(%esp)
80104618:	89 04 24             	mov    %eax,(%esp)
8010461b:	e8 99 3b 00 00       	call   801081b9 <copyuvm>
80104620:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104623:	89 42 04             	mov    %eax,0x4(%edx)
80104626:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104629:	8b 40 04             	mov    0x4(%eax),%eax
8010462c:	85 c0                	test   %eax,%eax
8010462e:	75 2c                	jne    8010465c <fork+0x7a>
    kfree(np->kstack);
80104630:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104633:	8b 40 08             	mov    0x8(%eax),%eax
80104636:	89 04 24             	mov    %eax,(%esp)
80104639:	e8 14 e4 ff ff       	call   80102a52 <kfree>
    np->kstack = 0;
8010463e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104641:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104648:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010464b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104652:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104657:	e9 f9 00 00 00       	jmp    80104755 <fork+0x173>
  }
  np->sz = proc->sz;
8010465c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104662:	8b 10                	mov    (%eax),%edx
80104664:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104667:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104669:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104670:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104673:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104676:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104679:	8b 50 18             	mov    0x18(%eax),%edx
8010467c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104682:	8b 40 18             	mov    0x18(%eax),%eax
80104685:	89 c3                	mov    %eax,%ebx
80104687:	b8 13 00 00 00       	mov    $0x13,%eax
8010468c:	89 d7                	mov    %edx,%edi
8010468e:	89 de                	mov    %ebx,%esi
80104690:	89 c1                	mov    %eax,%ecx
80104692:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104694:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104697:	8b 40 18             	mov    0x18(%eax),%eax
8010469a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801046a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801046a8:	eb 3d                	jmp    801046e7 <fork+0x105>
    if(proc->ofile[i])
801046aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801046b3:	83 c2 08             	add    $0x8,%edx
801046b6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046ba:	85 c0                	test   %eax,%eax
801046bc:	74 25                	je     801046e3 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
801046be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801046c7:	83 c2 08             	add    $0x8,%edx
801046ca:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046ce:	89 04 24             	mov    %eax,(%esp)
801046d1:	e8 b2 c8 ff ff       	call   80100f88 <filedup>
801046d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
801046d9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801046dc:	83 c1 08             	add    $0x8,%ecx
801046df:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801046e3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801046e7:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801046eb:	7e bd                	jle    801046aa <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801046ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046f3:	8b 40 68             	mov    0x68(%eax),%eax
801046f6:	89 04 24             	mov    %eax,(%esp)
801046f9:	e8 2e d1 ff ff       	call   8010182c <idup>
801046fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104701:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104704:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010470a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010470d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104710:	83 c0 6c             	add    $0x6c,%eax
80104713:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010471a:	00 
8010471b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010471f:	89 04 24             	mov    %eax,(%esp)
80104722:	e8 53 0b 00 00       	call   8010527a <safestrcpy>
 
  pid = np->pid;
80104727:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010472a:	8b 40 10             	mov    0x10(%eax),%eax
8010472d:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104730:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104737:	e8 c7 06 00 00       	call   80104e03 <acquire>
  np->state = RUNNABLE;
8010473c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010473f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104746:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
8010474d:	e8 13 07 00 00       	call   80104e65 <release>
  
  return pid;
80104752:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104755:	83 c4 2c             	add    $0x2c,%esp
80104758:	5b                   	pop    %ebx
80104759:	5e                   	pop    %esi
8010475a:	5f                   	pop    %edi
8010475b:	5d                   	pop    %ebp
8010475c:	c3                   	ret    

8010475d <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010475d:	55                   	push   %ebp
8010475e:	89 e5                	mov    %esp,%ebp
80104760:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104763:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010476a:	a1 48 b6 10 80       	mov    0x8010b648,%eax
8010476f:	39 c2                	cmp    %eax,%edx
80104771:	75 0c                	jne    8010477f <exit+0x22>
    panic("init exiting");
80104773:	c7 04 24 e4 86 10 80 	movl   $0x801086e4,(%esp)
8010477a:	e8 bb bd ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010477f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104786:	eb 44                	jmp    801047cc <exit+0x6f>
    if(proc->ofile[fd]){
80104788:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010478e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104791:	83 c2 08             	add    $0x8,%edx
80104794:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104798:	85 c0                	test   %eax,%eax
8010479a:	74 2c                	je     801047c8 <exit+0x6b>
      fileclose(proc->ofile[fd]);
8010479c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047a5:	83 c2 08             	add    $0x8,%edx
801047a8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047ac:	89 04 24             	mov    %eax,(%esp)
801047af:	e8 1c c8 ff ff       	call   80100fd0 <fileclose>
      proc->ofile[fd] = 0;
801047b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047bd:	83 c2 08             	add    $0x8,%edx
801047c0:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801047c7:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801047c8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801047cc:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801047d0:	7e b6                	jle    80104788 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
801047d2:	e8 43 ec ff ff       	call   8010341a <begin_op>
  iput(proc->cwd);
801047d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047dd:	8b 40 68             	mov    0x68(%eax),%eax
801047e0:	89 04 24             	mov    %eax,(%esp)
801047e3:	e8 29 d2 ff ff       	call   80101a11 <iput>
  end_op();
801047e8:	e8 b1 ec ff ff       	call   8010349e <end_op>
  proc->cwd = 0;
801047ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f3:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801047fa:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104801:	e8 fd 05 00 00       	call   80104e03 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104806:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010480c:	8b 40 14             	mov    0x14(%eax),%eax
8010480f:	89 04 24             	mov    %eax,(%esp)
80104812:	e8 ba 03 00 00       	call   80104bd1 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104817:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
8010481e:	eb 38                	jmp    80104858 <exit+0xfb>
    if(p->parent == proc){
80104820:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104823:	8b 50 14             	mov    0x14(%eax),%edx
80104826:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010482c:	39 c2                	cmp    %eax,%edx
8010482e:	75 24                	jne    80104854 <exit+0xf7>
      p->parent = initproc;
80104830:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
80104836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104839:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010483c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483f:	8b 40 0c             	mov    0xc(%eax),%eax
80104842:	83 f8 05             	cmp    $0x5,%eax
80104845:	75 0d                	jne    80104854 <exit+0xf7>
        wakeup1(initproc);
80104847:	a1 48 b6 10 80       	mov    0x8010b648,%eax
8010484c:	89 04 24             	mov    %eax,(%esp)
8010484f:	e8 7d 03 00 00       	call   80104bd1 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104854:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104858:	81 7d f4 94 48 11 80 	cmpl   $0x80114894,-0xc(%ebp)
8010485f:	72 bf                	jb     80104820 <exit+0xc3>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104861:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104867:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010486e:	e8 b3 01 00 00       	call   80104a26 <sched>
  panic("zombie exit");
80104873:	c7 04 24 f1 86 10 80 	movl   $0x801086f1,(%esp)
8010487a:	e8 bb bc ff ff       	call   8010053a <panic>

8010487f <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010487f:	55                   	push   %ebp
80104880:	89 e5                	mov    %esp,%ebp
80104882:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104885:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
8010488c:	e8 72 05 00 00       	call   80104e03 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104891:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104898:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
8010489f:	e9 9a 00 00 00       	jmp    8010493e <wait+0xbf>
      if(p->parent != proc)
801048a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a7:	8b 50 14             	mov    0x14(%eax),%edx
801048aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b0:	39 c2                	cmp    %eax,%edx
801048b2:	74 05                	je     801048b9 <wait+0x3a>
        continue;
801048b4:	e9 81 00 00 00       	jmp    8010493a <wait+0xbb>
      havekids = 1;
801048b9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801048c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c3:	8b 40 0c             	mov    0xc(%eax),%eax
801048c6:	83 f8 05             	cmp    $0x5,%eax
801048c9:	75 6f                	jne    8010493a <wait+0xbb>
        // Found one.
        pid = p->pid;
801048cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ce:	8b 40 10             	mov    0x10(%eax),%eax
801048d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801048d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d7:	8b 40 08             	mov    0x8(%eax),%eax
801048da:	89 04 24             	mov    %eax,(%esp)
801048dd:	e8 70 e1 ff ff       	call   80102a52 <kfree>
        p->kstack = 0;
801048e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801048ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ef:	8b 40 04             	mov    0x4(%eax),%eax
801048f2:	89 04 24             	mov    %eax,(%esp)
801048f5:	e8 df 37 00 00       	call   801080d9 <freevm>
        p->state = UNUSED;
801048fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104904:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104907:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010490e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104911:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104918:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010491f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104922:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104929:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104930:	e8 30 05 00 00       	call   80104e65 <release>
        return pid;
80104935:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104938:	eb 52                	jmp    8010498c <wait+0x10d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010493a:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010493e:	81 7d f4 94 48 11 80 	cmpl   $0x80114894,-0xc(%ebp)
80104945:	0f 82 59 ff ff ff    	jb     801048a4 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
8010494b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010494f:	74 0d                	je     8010495e <wait+0xdf>
80104951:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104957:	8b 40 24             	mov    0x24(%eax),%eax
8010495a:	85 c0                	test   %eax,%eax
8010495c:	74 13                	je     80104971 <wait+0xf2>
      release(&ptable.lock);
8010495e:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104965:	e8 fb 04 00 00       	call   80104e65 <release>
      return -1;
8010496a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010496f:	eb 1b                	jmp    8010498c <wait+0x10d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104971:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104977:	c7 44 24 04 60 29 11 	movl   $0x80112960,0x4(%esp)
8010497e:	80 
8010497f:	89 04 24             	mov    %eax,(%esp)
80104982:	e8 af 01 00 00       	call   80104b36 <sleep>
  }
80104987:	e9 05 ff ff ff       	jmp    80104891 <wait+0x12>
}
8010498c:	c9                   	leave  
8010498d:	c3                   	ret    

8010498e <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
8010498e:	55                   	push   %ebp
8010498f:	89 e5                	mov    %esp,%ebp
80104991:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104994:	e8 63 f9 ff ff       	call   801042fc <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104999:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
801049a0:	e8 5e 04 00 00       	call   80104e03 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049a5:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
801049ac:	eb 5e                	jmp    80104a0c <scheduler+0x7e>
      if(p->state != RUNNABLE)
801049ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b1:	8b 40 0c             	mov    0xc(%eax),%eax
801049b4:	83 f8 03             	cmp    $0x3,%eax
801049b7:	74 02                	je     801049bb <scheduler+0x2d>
        continue;
801049b9:	eb 4d                	jmp    80104a08 <scheduler+0x7a>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
801049bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049be:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
801049c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c7:	89 04 24             	mov    %eax,(%esp)
801049ca:	e8 97 32 00 00       	call   80107c66 <switchuvm>
      p->state = RUNNING;
801049cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d2:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
801049d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049df:	8b 40 1c             	mov    0x1c(%eax),%eax
801049e2:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801049e9:	83 c2 04             	add    $0x4,%edx
801049ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801049f0:	89 14 24             	mov    %edx,(%esp)
801049f3:	e8 f4 08 00 00       	call   801052ec <swtch>
      switchkvm();
801049f8:	e8 4c 32 00 00       	call   80107c49 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
801049fd:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104a04:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a08:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a0c:	81 7d f4 94 48 11 80 	cmpl   $0x80114894,-0xc(%ebp)
80104a13:	72 99                	jb     801049ae <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104a15:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104a1c:	e8 44 04 00 00       	call   80104e65 <release>

  }
80104a21:	e9 6e ff ff ff       	jmp    80104994 <scheduler+0x6>

80104a26 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104a26:	55                   	push   %ebp
80104a27:	89 e5                	mov    %esp,%ebp
80104a29:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104a2c:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104a33:	e8 f5 04 00 00       	call   80104f2d <holding>
80104a38:	85 c0                	test   %eax,%eax
80104a3a:	75 0c                	jne    80104a48 <sched+0x22>
    panic("sched ptable.lock");
80104a3c:	c7 04 24 fd 86 10 80 	movl   $0x801086fd,(%esp)
80104a43:	e8 f2 ba ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
80104a48:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a4e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104a54:	83 f8 01             	cmp    $0x1,%eax
80104a57:	74 0c                	je     80104a65 <sched+0x3f>
    panic("sched locks");
80104a59:	c7 04 24 0f 87 10 80 	movl   $0x8010870f,(%esp)
80104a60:	e8 d5 ba ff ff       	call   8010053a <panic>
  if(proc->state == RUNNING)
80104a65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a6b:	8b 40 0c             	mov    0xc(%eax),%eax
80104a6e:	83 f8 04             	cmp    $0x4,%eax
80104a71:	75 0c                	jne    80104a7f <sched+0x59>
    panic("sched running");
80104a73:	c7 04 24 1b 87 10 80 	movl   $0x8010871b,(%esp)
80104a7a:	e8 bb ba ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
80104a7f:	e8 68 f8 ff ff       	call   801042ec <readeflags>
80104a84:	25 00 02 00 00       	and    $0x200,%eax
80104a89:	85 c0                	test   %eax,%eax
80104a8b:	74 0c                	je     80104a99 <sched+0x73>
    panic("sched interruptible");
80104a8d:	c7 04 24 29 87 10 80 	movl   $0x80108729,(%esp)
80104a94:	e8 a1 ba ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104a99:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a9f:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104aa8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104aae:	8b 40 04             	mov    0x4(%eax),%eax
80104ab1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ab8:	83 c2 1c             	add    $0x1c,%edx
80104abb:	89 44 24 04          	mov    %eax,0x4(%esp)
80104abf:	89 14 24             	mov    %edx,(%esp)
80104ac2:	e8 25 08 00 00       	call   801052ec <swtch>
  cpu->intena = intena;
80104ac7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ad0:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104ad6:	c9                   	leave  
80104ad7:	c3                   	ret    

80104ad8 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104ad8:	55                   	push   %ebp
80104ad9:	89 e5                	mov    %esp,%ebp
80104adb:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104ade:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104ae5:	e8 19 03 00 00       	call   80104e03 <acquire>
  proc->state = RUNNABLE;
80104aea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104af7:	e8 2a ff ff ff       	call   80104a26 <sched>
  release(&ptable.lock);
80104afc:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104b03:	e8 5d 03 00 00       	call   80104e65 <release>
}
80104b08:	c9                   	leave  
80104b09:	c3                   	ret    

80104b0a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104b0a:	55                   	push   %ebp
80104b0b:	89 e5                	mov    %esp,%ebp
80104b0d:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104b10:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104b17:	e8 49 03 00 00       	call   80104e65 <release>

  if (first) {
80104b1c:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104b21:	85 c0                	test   %eax,%eax
80104b23:	74 0f                	je     80104b34 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104b25:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104b2c:	00 00 00 
    initlog();
80104b2f:	e8 d8 e6 ff ff       	call   8010320c <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104b34:	c9                   	leave  
80104b35:	c3                   	ret    

80104b36 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104b36:	55                   	push   %ebp
80104b37:	89 e5                	mov    %esp,%ebp
80104b39:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104b3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b42:	85 c0                	test   %eax,%eax
80104b44:	75 0c                	jne    80104b52 <sleep+0x1c>
    panic("sleep");
80104b46:	c7 04 24 3d 87 10 80 	movl   $0x8010873d,(%esp)
80104b4d:	e8 e8 b9 ff ff       	call   8010053a <panic>

  if(lk == 0)
80104b52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104b56:	75 0c                	jne    80104b64 <sleep+0x2e>
    panic("sleep without lk");
80104b58:	c7 04 24 43 87 10 80 	movl   $0x80108743,(%esp)
80104b5f:	e8 d6 b9 ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104b64:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104b6b:	74 17                	je     80104b84 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104b6d:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104b74:	e8 8a 02 00 00       	call   80104e03 <acquire>
    release(lk);
80104b79:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b7c:	89 04 24             	mov    %eax,(%esp)
80104b7f:	e8 e1 02 00 00       	call   80104e65 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104b84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b8a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b8d:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104b90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b96:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104b9d:	e8 84 fe ff ff       	call   80104a26 <sched>

  // Tidy up.
  proc->chan = 0;
80104ba2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ba8:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104baf:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104bb6:	74 17                	je     80104bcf <sleep+0x99>
    release(&ptable.lock);
80104bb8:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104bbf:	e8 a1 02 00 00       	call   80104e65 <release>
    acquire(lk);
80104bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bc7:	89 04 24             	mov    %eax,(%esp)
80104bca:	e8 34 02 00 00       	call   80104e03 <acquire>
  }
}
80104bcf:	c9                   	leave  
80104bd0:	c3                   	ret    

80104bd1 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104bd1:	55                   	push   %ebp
80104bd2:	89 e5                	mov    %esp,%ebp
80104bd4:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bd7:	c7 45 fc 94 29 11 80 	movl   $0x80112994,-0x4(%ebp)
80104bde:	eb 24                	jmp    80104c04 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104be3:	8b 40 0c             	mov    0xc(%eax),%eax
80104be6:	83 f8 02             	cmp    $0x2,%eax
80104be9:	75 15                	jne    80104c00 <wakeup1+0x2f>
80104beb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bee:	8b 40 20             	mov    0x20(%eax),%eax
80104bf1:	3b 45 08             	cmp    0x8(%ebp),%eax
80104bf4:	75 0a                	jne    80104c00 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104bf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bf9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c00:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104c04:	81 7d fc 94 48 11 80 	cmpl   $0x80114894,-0x4(%ebp)
80104c0b:	72 d3                	jb     80104be0 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104c0d:	c9                   	leave  
80104c0e:	c3                   	ret    

80104c0f <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104c0f:	55                   	push   %ebp
80104c10:	89 e5                	mov    %esp,%ebp
80104c12:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104c15:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104c1c:	e8 e2 01 00 00       	call   80104e03 <acquire>
  wakeup1(chan);
80104c21:	8b 45 08             	mov    0x8(%ebp),%eax
80104c24:	89 04 24             	mov    %eax,(%esp)
80104c27:	e8 a5 ff ff ff       	call   80104bd1 <wakeup1>
  release(&ptable.lock);
80104c2c:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104c33:	e8 2d 02 00 00       	call   80104e65 <release>
}
80104c38:	c9                   	leave  
80104c39:	c3                   	ret    

80104c3a <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104c3a:	55                   	push   %ebp
80104c3b:	89 e5                	mov    %esp,%ebp
80104c3d:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104c40:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104c47:	e8 b7 01 00 00       	call   80104e03 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c4c:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104c53:	eb 41                	jmp    80104c96 <kill+0x5c>
    if(p->pid == pid){
80104c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c58:	8b 40 10             	mov    0x10(%eax),%eax
80104c5b:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c5e:	75 32                	jne    80104c92 <kill+0x58>
      p->killed = 1;
80104c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c63:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c6d:	8b 40 0c             	mov    0xc(%eax),%eax
80104c70:	83 f8 02             	cmp    $0x2,%eax
80104c73:	75 0a                	jne    80104c7f <kill+0x45>
        p->state = RUNNABLE;
80104c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c78:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104c7f:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104c86:	e8 da 01 00 00       	call   80104e65 <release>
      return 0;
80104c8b:	b8 00 00 00 00       	mov    $0x0,%eax
80104c90:	eb 1e                	jmp    80104cb0 <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c92:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104c96:	81 7d f4 94 48 11 80 	cmpl   $0x80114894,-0xc(%ebp)
80104c9d:	72 b6                	jb     80104c55 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104c9f:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104ca6:	e8 ba 01 00 00       	call   80104e65 <release>
  return -1;
80104cab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cb0:	c9                   	leave  
80104cb1:	c3                   	ret    

80104cb2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104cb2:	55                   	push   %ebp
80104cb3:	89 e5                	mov    %esp,%ebp
80104cb5:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cb8:	c7 45 f0 94 29 11 80 	movl   $0x80112994,-0x10(%ebp)
80104cbf:	e9 d6 00 00 00       	jmp    80104d9a <procdump+0xe8>
    if(p->state == UNUSED)
80104cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cc7:	8b 40 0c             	mov    0xc(%eax),%eax
80104cca:	85 c0                	test   %eax,%eax
80104ccc:	75 05                	jne    80104cd3 <procdump+0x21>
      continue;
80104cce:	e9 c3 00 00 00       	jmp    80104d96 <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cd6:	8b 40 0c             	mov    0xc(%eax),%eax
80104cd9:	83 f8 05             	cmp    $0x5,%eax
80104cdc:	77 23                	ja     80104d01 <procdump+0x4f>
80104cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ce1:	8b 40 0c             	mov    0xc(%eax),%eax
80104ce4:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104ceb:	85 c0                	test   %eax,%eax
80104ced:	74 12                	je     80104d01 <procdump+0x4f>
      state = states[p->state];
80104cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cf2:	8b 40 0c             	mov    0xc(%eax),%eax
80104cf5:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104cfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104cff:	eb 07                	jmp    80104d08 <procdump+0x56>
    else
      state = "???";
80104d01:	c7 45 ec 54 87 10 80 	movl   $0x80108754,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d0b:	8d 50 6c             	lea    0x6c(%eax),%edx
80104d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d11:	8b 40 10             	mov    0x10(%eax),%eax
80104d14:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104d18:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104d1b:	89 54 24 08          	mov    %edx,0x8(%esp)
80104d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d23:	c7 04 24 58 87 10 80 	movl   $0x80108758,(%esp)
80104d2a:	e8 71 b6 ff ff       	call   801003a0 <cprintf>
    if(p->state == SLEEPING){
80104d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d32:	8b 40 0c             	mov    0xc(%eax),%eax
80104d35:	83 f8 02             	cmp    $0x2,%eax
80104d38:	75 50                	jne    80104d8a <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d3d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d40:	8b 40 0c             	mov    0xc(%eax),%eax
80104d43:	83 c0 08             	add    $0x8,%eax
80104d46:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104d49:	89 54 24 04          	mov    %edx,0x4(%esp)
80104d4d:	89 04 24             	mov    %eax,(%esp)
80104d50:	e8 5f 01 00 00       	call   80104eb4 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104d5c:	eb 1b                	jmp    80104d79 <procdump+0xc7>
        cprintf(" %p", pc[i]);
80104d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d61:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d65:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d69:	c7 04 24 61 87 10 80 	movl   $0x80108761,(%esp)
80104d70:	e8 2b b6 ff ff       	call   801003a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104d75:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104d79:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104d7d:	7f 0b                	jg     80104d8a <procdump+0xd8>
80104d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d82:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d86:	85 c0                	test   %eax,%eax
80104d88:	75 d4                	jne    80104d5e <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104d8a:	c7 04 24 65 87 10 80 	movl   $0x80108765,(%esp)
80104d91:	e8 0a b6 ff ff       	call   801003a0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d96:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104d9a:	81 7d f0 94 48 11 80 	cmpl   $0x80114894,-0x10(%ebp)
80104da1:	0f 82 1d ff ff ff    	jb     80104cc4 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104da7:	c9                   	leave  
80104da8:	c3                   	ret    
80104da9:	66 90                	xchg   %ax,%ax
80104dab:	90                   	nop

80104dac <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104dac:	55                   	push   %ebp
80104dad:	89 e5                	mov    %esp,%ebp
80104daf:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104db2:	9c                   	pushf  
80104db3:	58                   	pop    %eax
80104db4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104dba:	c9                   	leave  
80104dbb:	c3                   	ret    

80104dbc <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104dbc:	55                   	push   %ebp
80104dbd:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104dbf:	fa                   	cli    
}
80104dc0:	5d                   	pop    %ebp
80104dc1:	c3                   	ret    

80104dc2 <sti>:

static inline void
sti(void)
{
80104dc2:	55                   	push   %ebp
80104dc3:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104dc5:	fb                   	sti    
}
80104dc6:	5d                   	pop    %ebp
80104dc7:	c3                   	ret    

80104dc8 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104dc8:	55                   	push   %ebp
80104dc9:	89 e5                	mov    %esp,%ebp
80104dcb:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104dce:	8b 55 08             	mov    0x8(%ebp),%edx
80104dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dd7:	f0 87 02             	lock xchg %eax,(%edx)
80104dda:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104de0:	c9                   	leave  
80104de1:	c3                   	ret    

80104de2 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104de2:	55                   	push   %ebp
80104de3:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104de5:	8b 45 08             	mov    0x8(%ebp),%eax
80104de8:	8b 55 0c             	mov    0xc(%ebp),%edx
80104deb:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104dee:	8b 45 08             	mov    0x8(%ebp),%eax
80104df1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104df7:	8b 45 08             	mov    0x8(%ebp),%eax
80104dfa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e01:	5d                   	pop    %ebp
80104e02:	c3                   	ret    

80104e03 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104e03:	55                   	push   %ebp
80104e04:	89 e5                	mov    %esp,%ebp
80104e06:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104e09:	e8 49 01 00 00       	call   80104f57 <pushcli>
  if(holding(lk))
80104e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80104e11:	89 04 24             	mov    %eax,(%esp)
80104e14:	e8 14 01 00 00       	call   80104f2d <holding>
80104e19:	85 c0                	test   %eax,%eax
80104e1b:	74 0c                	je     80104e29 <acquire+0x26>
    panic("acquire");
80104e1d:	c7 04 24 91 87 10 80 	movl   $0x80108791,(%esp)
80104e24:	e8 11 b7 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104e29:	90                   	nop
80104e2a:	8b 45 08             	mov    0x8(%ebp),%eax
80104e2d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104e34:	00 
80104e35:	89 04 24             	mov    %eax,(%esp)
80104e38:	e8 8b ff ff ff       	call   80104dc8 <xchg>
80104e3d:	85 c0                	test   %eax,%eax
80104e3f:	75 e9                	jne    80104e2a <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104e41:	8b 45 08             	mov    0x8(%ebp),%eax
80104e44:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104e4b:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104e4e:	8b 45 08             	mov    0x8(%ebp),%eax
80104e51:	83 c0 0c             	add    $0xc,%eax
80104e54:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e58:	8d 45 08             	lea    0x8(%ebp),%eax
80104e5b:	89 04 24             	mov    %eax,(%esp)
80104e5e:	e8 51 00 00 00       	call   80104eb4 <getcallerpcs>
}
80104e63:	c9                   	leave  
80104e64:	c3                   	ret    

80104e65 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104e65:	55                   	push   %ebp
80104e66:	89 e5                	mov    %esp,%ebp
80104e68:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80104e6e:	89 04 24             	mov    %eax,(%esp)
80104e71:	e8 b7 00 00 00       	call   80104f2d <holding>
80104e76:	85 c0                	test   %eax,%eax
80104e78:	75 0c                	jne    80104e86 <release+0x21>
    panic("release");
80104e7a:	c7 04 24 99 87 10 80 	movl   $0x80108799,(%esp)
80104e81:	e8 b4 b6 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80104e86:	8b 45 08             	mov    0x8(%ebp),%eax
80104e89:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104e90:	8b 45 08             	mov    0x8(%ebp),%eax
80104e93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104e9a:	8b 45 08             	mov    0x8(%ebp),%eax
80104e9d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104ea4:	00 
80104ea5:	89 04 24             	mov    %eax,(%esp)
80104ea8:	e8 1b ff ff ff       	call   80104dc8 <xchg>

  popcli();
80104ead:	e8 e9 00 00 00       	call   80104f9b <popcli>
}
80104eb2:	c9                   	leave  
80104eb3:	c3                   	ret    

80104eb4 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104eba:	8b 45 08             	mov    0x8(%ebp),%eax
80104ebd:	83 e8 08             	sub    $0x8,%eax
80104ec0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104ec3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104eca:	eb 38                	jmp    80104f04 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ecc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104ed0:	74 38                	je     80104f0a <getcallerpcs+0x56>
80104ed2:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104ed9:	76 2f                	jbe    80104f0a <getcallerpcs+0x56>
80104edb:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104edf:	74 29                	je     80104f0a <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ee4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eee:	01 c2                	add    %eax,%edx
80104ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ef3:	8b 40 04             	mov    0x4(%eax),%eax
80104ef6:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104efb:	8b 00                	mov    (%eax),%eax
80104efd:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f00:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104f04:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104f08:	7e c2                	jle    80104ecc <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104f0a:	eb 19                	jmp    80104f25 <getcallerpcs+0x71>
    pcs[i] = 0;
80104f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104f16:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f19:	01 d0                	add    %edx,%eax
80104f1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104f21:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104f25:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104f29:	7e e1                	jle    80104f0c <getcallerpcs+0x58>
    pcs[i] = 0;
}
80104f2b:	c9                   	leave  
80104f2c:	c3                   	ret    

80104f2d <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104f2d:	55                   	push   %ebp
80104f2e:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104f30:	8b 45 08             	mov    0x8(%ebp),%eax
80104f33:	8b 00                	mov    (%eax),%eax
80104f35:	85 c0                	test   %eax,%eax
80104f37:	74 17                	je     80104f50 <holding+0x23>
80104f39:	8b 45 08             	mov    0x8(%ebp),%eax
80104f3c:	8b 50 08             	mov    0x8(%eax),%edx
80104f3f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f45:	39 c2                	cmp    %eax,%edx
80104f47:	75 07                	jne    80104f50 <holding+0x23>
80104f49:	b8 01 00 00 00       	mov    $0x1,%eax
80104f4e:	eb 05                	jmp    80104f55 <holding+0x28>
80104f50:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f55:	5d                   	pop    %ebp
80104f56:	c3                   	ret    

80104f57 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104f57:	55                   	push   %ebp
80104f58:	89 e5                	mov    %esp,%ebp
80104f5a:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104f5d:	e8 4a fe ff ff       	call   80104dac <readeflags>
80104f62:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104f65:	e8 52 fe ff ff       	call   80104dbc <cli>
  if(cpu->ncli++ == 0)
80104f6a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104f71:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104f77:	8d 48 01             	lea    0x1(%eax),%ecx
80104f7a:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80104f80:	85 c0                	test   %eax,%eax
80104f82:	75 15                	jne    80104f99 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80104f84:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104f8d:	81 e2 00 02 00 00    	and    $0x200,%edx
80104f93:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104f99:	c9                   	leave  
80104f9a:	c3                   	ret    

80104f9b <popcli>:

void
popcli(void)
{
80104f9b:	55                   	push   %ebp
80104f9c:	89 e5                	mov    %esp,%ebp
80104f9e:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104fa1:	e8 06 fe ff ff       	call   80104dac <readeflags>
80104fa6:	25 00 02 00 00       	and    $0x200,%eax
80104fab:	85 c0                	test   %eax,%eax
80104fad:	74 0c                	je     80104fbb <popcli+0x20>
    panic("popcli - interruptible");
80104faf:	c7 04 24 a1 87 10 80 	movl   $0x801087a1,(%esp)
80104fb6:	e8 7f b5 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80104fbb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104fc1:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104fc7:	83 ea 01             	sub    $0x1,%edx
80104fca:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104fd0:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104fd6:	85 c0                	test   %eax,%eax
80104fd8:	79 0c                	jns    80104fe6 <popcli+0x4b>
    panic("popcli");
80104fda:	c7 04 24 b8 87 10 80 	movl   $0x801087b8,(%esp)
80104fe1:	e8 54 b5 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104fe6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104fec:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104ff2:	85 c0                	test   %eax,%eax
80104ff4:	75 15                	jne    8010500b <popcli+0x70>
80104ff6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ffc:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105002:	85 c0                	test   %eax,%eax
80105004:	74 05                	je     8010500b <popcli+0x70>
    sti();
80105006:	e8 b7 fd ff ff       	call   80104dc2 <sti>
}
8010500b:	c9                   	leave  
8010500c:	c3                   	ret    
8010500d:	66 90                	xchg   %ax,%ax
8010500f:	90                   	nop

80105010 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	57                   	push   %edi
80105014:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105015:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105018:	8b 55 10             	mov    0x10(%ebp),%edx
8010501b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010501e:	89 cb                	mov    %ecx,%ebx
80105020:	89 df                	mov    %ebx,%edi
80105022:	89 d1                	mov    %edx,%ecx
80105024:	fc                   	cld    
80105025:	f3 aa                	rep stos %al,%es:(%edi)
80105027:	89 ca                	mov    %ecx,%edx
80105029:	89 fb                	mov    %edi,%ebx
8010502b:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010502e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105031:	5b                   	pop    %ebx
80105032:	5f                   	pop    %edi
80105033:	5d                   	pop    %ebp
80105034:	c3                   	ret    

80105035 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105035:	55                   	push   %ebp
80105036:	89 e5                	mov    %esp,%ebp
80105038:	57                   	push   %edi
80105039:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010503a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010503d:	8b 55 10             	mov    0x10(%ebp),%edx
80105040:	8b 45 0c             	mov    0xc(%ebp),%eax
80105043:	89 cb                	mov    %ecx,%ebx
80105045:	89 df                	mov    %ebx,%edi
80105047:	89 d1                	mov    %edx,%ecx
80105049:	fc                   	cld    
8010504a:	f3 ab                	rep stos %eax,%es:(%edi)
8010504c:	89 ca                	mov    %ecx,%edx
8010504e:	89 fb                	mov    %edi,%ebx
80105050:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105053:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105056:	5b                   	pop    %ebx
80105057:	5f                   	pop    %edi
80105058:	5d                   	pop    %ebp
80105059:	c3                   	ret    

8010505a <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010505a:	55                   	push   %ebp
8010505b:	89 e5                	mov    %esp,%ebp
8010505d:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105060:	8b 45 08             	mov    0x8(%ebp),%eax
80105063:	83 e0 03             	and    $0x3,%eax
80105066:	85 c0                	test   %eax,%eax
80105068:	75 49                	jne    801050b3 <memset+0x59>
8010506a:	8b 45 10             	mov    0x10(%ebp),%eax
8010506d:	83 e0 03             	and    $0x3,%eax
80105070:	85 c0                	test   %eax,%eax
80105072:	75 3f                	jne    801050b3 <memset+0x59>
    c &= 0xFF;
80105074:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010507b:	8b 45 10             	mov    0x10(%ebp),%eax
8010507e:	c1 e8 02             	shr    $0x2,%eax
80105081:	89 c2                	mov    %eax,%edx
80105083:	8b 45 0c             	mov    0xc(%ebp),%eax
80105086:	c1 e0 18             	shl    $0x18,%eax
80105089:	89 c1                	mov    %eax,%ecx
8010508b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010508e:	c1 e0 10             	shl    $0x10,%eax
80105091:	09 c1                	or     %eax,%ecx
80105093:	8b 45 0c             	mov    0xc(%ebp),%eax
80105096:	c1 e0 08             	shl    $0x8,%eax
80105099:	09 c8                	or     %ecx,%eax
8010509b:	0b 45 0c             	or     0xc(%ebp),%eax
8010509e:	89 54 24 08          	mov    %edx,0x8(%esp)
801050a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801050a6:	8b 45 08             	mov    0x8(%ebp),%eax
801050a9:	89 04 24             	mov    %eax,(%esp)
801050ac:	e8 84 ff ff ff       	call   80105035 <stosl>
801050b1:	eb 19                	jmp    801050cc <memset+0x72>
  } else
    stosb(dst, c, n);
801050b3:	8b 45 10             	mov    0x10(%ebp),%eax
801050b6:	89 44 24 08          	mov    %eax,0x8(%esp)
801050ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801050bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801050c1:	8b 45 08             	mov    0x8(%ebp),%eax
801050c4:	89 04 24             	mov    %eax,(%esp)
801050c7:	e8 44 ff ff ff       	call   80105010 <stosb>
  return dst;
801050cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
801050cf:	c9                   	leave  
801050d0:	c3                   	ret    

801050d1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801050d1:	55                   	push   %ebp
801050d2:	89 e5                	mov    %esp,%ebp
801050d4:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801050d7:	8b 45 08             	mov    0x8(%ebp),%eax
801050da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801050dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801050e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801050e3:	eb 30                	jmp    80105115 <memcmp+0x44>
    if(*s1 != *s2)
801050e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050e8:	0f b6 10             	movzbl (%eax),%edx
801050eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050ee:	0f b6 00             	movzbl (%eax),%eax
801050f1:	38 c2                	cmp    %al,%dl
801050f3:	74 18                	je     8010510d <memcmp+0x3c>
      return *s1 - *s2;
801050f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050f8:	0f b6 00             	movzbl (%eax),%eax
801050fb:	0f b6 d0             	movzbl %al,%edx
801050fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105101:	0f b6 00             	movzbl (%eax),%eax
80105104:	0f b6 c0             	movzbl %al,%eax
80105107:	29 c2                	sub    %eax,%edx
80105109:	89 d0                	mov    %edx,%eax
8010510b:	eb 1a                	jmp    80105127 <memcmp+0x56>
    s1++, s2++;
8010510d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105111:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105115:	8b 45 10             	mov    0x10(%ebp),%eax
80105118:	8d 50 ff             	lea    -0x1(%eax),%edx
8010511b:	89 55 10             	mov    %edx,0x10(%ebp)
8010511e:	85 c0                	test   %eax,%eax
80105120:	75 c3                	jne    801050e5 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105122:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105127:	c9                   	leave  
80105128:	c3                   	ret    

80105129 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105129:	55                   	push   %ebp
8010512a:	89 e5                	mov    %esp,%ebp
8010512c:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010512f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105132:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105135:	8b 45 08             	mov    0x8(%ebp),%eax
80105138:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010513b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010513e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105141:	73 3d                	jae    80105180 <memmove+0x57>
80105143:	8b 45 10             	mov    0x10(%ebp),%eax
80105146:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105149:	01 d0                	add    %edx,%eax
8010514b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010514e:	76 30                	jbe    80105180 <memmove+0x57>
    s += n;
80105150:	8b 45 10             	mov    0x10(%ebp),%eax
80105153:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105156:	8b 45 10             	mov    0x10(%ebp),%eax
80105159:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010515c:	eb 13                	jmp    80105171 <memmove+0x48>
      *--d = *--s;
8010515e:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105162:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105166:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105169:	0f b6 10             	movzbl (%eax),%edx
8010516c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010516f:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105171:	8b 45 10             	mov    0x10(%ebp),%eax
80105174:	8d 50 ff             	lea    -0x1(%eax),%edx
80105177:	89 55 10             	mov    %edx,0x10(%ebp)
8010517a:	85 c0                	test   %eax,%eax
8010517c:	75 e0                	jne    8010515e <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010517e:	eb 26                	jmp    801051a6 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105180:	eb 17                	jmp    80105199 <memmove+0x70>
      *d++ = *s++;
80105182:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105185:	8d 50 01             	lea    0x1(%eax),%edx
80105188:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010518b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010518e:	8d 4a 01             	lea    0x1(%edx),%ecx
80105191:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105194:	0f b6 12             	movzbl (%edx),%edx
80105197:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105199:	8b 45 10             	mov    0x10(%ebp),%eax
8010519c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010519f:	89 55 10             	mov    %edx,0x10(%ebp)
801051a2:	85 c0                	test   %eax,%eax
801051a4:	75 dc                	jne    80105182 <memmove+0x59>
      *d++ = *s++;

  return dst;
801051a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
801051a9:	c9                   	leave  
801051aa:	c3                   	ret    

801051ab <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801051ab:	55                   	push   %ebp
801051ac:	89 e5                	mov    %esp,%ebp
801051ae:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801051b1:	8b 45 10             	mov    0x10(%ebp),%eax
801051b4:	89 44 24 08          	mov    %eax,0x8(%esp)
801051b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801051bb:	89 44 24 04          	mov    %eax,0x4(%esp)
801051bf:	8b 45 08             	mov    0x8(%ebp),%eax
801051c2:	89 04 24             	mov    %eax,(%esp)
801051c5:	e8 5f ff ff ff       	call   80105129 <memmove>
}
801051ca:	c9                   	leave  
801051cb:	c3                   	ret    

801051cc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801051cc:	55                   	push   %ebp
801051cd:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801051cf:	eb 0c                	jmp    801051dd <strncmp+0x11>
    n--, p++, q++;
801051d1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801051d5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801051d9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801051dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801051e1:	74 1a                	je     801051fd <strncmp+0x31>
801051e3:	8b 45 08             	mov    0x8(%ebp),%eax
801051e6:	0f b6 00             	movzbl (%eax),%eax
801051e9:	84 c0                	test   %al,%al
801051eb:	74 10                	je     801051fd <strncmp+0x31>
801051ed:	8b 45 08             	mov    0x8(%ebp),%eax
801051f0:	0f b6 10             	movzbl (%eax),%edx
801051f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801051f6:	0f b6 00             	movzbl (%eax),%eax
801051f9:	38 c2                	cmp    %al,%dl
801051fb:	74 d4                	je     801051d1 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801051fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105201:	75 07                	jne    8010520a <strncmp+0x3e>
    return 0;
80105203:	b8 00 00 00 00       	mov    $0x0,%eax
80105208:	eb 16                	jmp    80105220 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010520a:	8b 45 08             	mov    0x8(%ebp),%eax
8010520d:	0f b6 00             	movzbl (%eax),%eax
80105210:	0f b6 d0             	movzbl %al,%edx
80105213:	8b 45 0c             	mov    0xc(%ebp),%eax
80105216:	0f b6 00             	movzbl (%eax),%eax
80105219:	0f b6 c0             	movzbl %al,%eax
8010521c:	29 c2                	sub    %eax,%edx
8010521e:	89 d0                	mov    %edx,%eax
}
80105220:	5d                   	pop    %ebp
80105221:	c3                   	ret    

80105222 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105222:	55                   	push   %ebp
80105223:	89 e5                	mov    %esp,%ebp
80105225:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105228:	8b 45 08             	mov    0x8(%ebp),%eax
8010522b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010522e:	90                   	nop
8010522f:	8b 45 10             	mov    0x10(%ebp),%eax
80105232:	8d 50 ff             	lea    -0x1(%eax),%edx
80105235:	89 55 10             	mov    %edx,0x10(%ebp)
80105238:	85 c0                	test   %eax,%eax
8010523a:	7e 1e                	jle    8010525a <strncpy+0x38>
8010523c:	8b 45 08             	mov    0x8(%ebp),%eax
8010523f:	8d 50 01             	lea    0x1(%eax),%edx
80105242:	89 55 08             	mov    %edx,0x8(%ebp)
80105245:	8b 55 0c             	mov    0xc(%ebp),%edx
80105248:	8d 4a 01             	lea    0x1(%edx),%ecx
8010524b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010524e:	0f b6 12             	movzbl (%edx),%edx
80105251:	88 10                	mov    %dl,(%eax)
80105253:	0f b6 00             	movzbl (%eax),%eax
80105256:	84 c0                	test   %al,%al
80105258:	75 d5                	jne    8010522f <strncpy+0xd>
    ;
  while(n-- > 0)
8010525a:	eb 0c                	jmp    80105268 <strncpy+0x46>
    *s++ = 0;
8010525c:	8b 45 08             	mov    0x8(%ebp),%eax
8010525f:	8d 50 01             	lea    0x1(%eax),%edx
80105262:	89 55 08             	mov    %edx,0x8(%ebp)
80105265:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105268:	8b 45 10             	mov    0x10(%ebp),%eax
8010526b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010526e:	89 55 10             	mov    %edx,0x10(%ebp)
80105271:	85 c0                	test   %eax,%eax
80105273:	7f e7                	jg     8010525c <strncpy+0x3a>
    *s++ = 0;
  return os;
80105275:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105278:	c9                   	leave  
80105279:	c3                   	ret    

8010527a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010527a:	55                   	push   %ebp
8010527b:	89 e5                	mov    %esp,%ebp
8010527d:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105280:	8b 45 08             	mov    0x8(%ebp),%eax
80105283:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105286:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010528a:	7f 05                	jg     80105291 <safestrcpy+0x17>
    return os;
8010528c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010528f:	eb 31                	jmp    801052c2 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105291:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105295:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105299:	7e 1e                	jle    801052b9 <safestrcpy+0x3f>
8010529b:	8b 45 08             	mov    0x8(%ebp),%eax
8010529e:	8d 50 01             	lea    0x1(%eax),%edx
801052a1:	89 55 08             	mov    %edx,0x8(%ebp)
801052a4:	8b 55 0c             	mov    0xc(%ebp),%edx
801052a7:	8d 4a 01             	lea    0x1(%edx),%ecx
801052aa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801052ad:	0f b6 12             	movzbl (%edx),%edx
801052b0:	88 10                	mov    %dl,(%eax)
801052b2:	0f b6 00             	movzbl (%eax),%eax
801052b5:	84 c0                	test   %al,%al
801052b7:	75 d8                	jne    80105291 <safestrcpy+0x17>
    ;
  *s = 0;
801052b9:	8b 45 08             	mov    0x8(%ebp),%eax
801052bc:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801052bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801052c2:	c9                   	leave  
801052c3:	c3                   	ret    

801052c4 <strlen>:

int
strlen(const char *s)
{
801052c4:	55                   	push   %ebp
801052c5:	89 e5                	mov    %esp,%ebp
801052c7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801052ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801052d1:	eb 04                	jmp    801052d7 <strlen+0x13>
801052d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801052d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052da:	8b 45 08             	mov    0x8(%ebp),%eax
801052dd:	01 d0                	add    %edx,%eax
801052df:	0f b6 00             	movzbl (%eax),%eax
801052e2:	84 c0                	test   %al,%al
801052e4:	75 ed                	jne    801052d3 <strlen+0xf>
    ;
  return n;
801052e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801052e9:	c9                   	leave  
801052ea:	c3                   	ret    
801052eb:	90                   	nop

801052ec <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801052ec:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801052f0:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801052f4:	55                   	push   %ebp
  pushl %ebx
801052f5:	53                   	push   %ebx
  pushl %esi
801052f6:	56                   	push   %esi
  pushl %edi
801052f7:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801052f8:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801052fa:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801052fc:	5f                   	pop    %edi
  popl %esi
801052fd:	5e                   	pop    %esi
  popl %ebx
801052fe:	5b                   	pop    %ebx
  popl %ebp
801052ff:	5d                   	pop    %ebp
  ret
80105300:	c3                   	ret    
80105301:	66 90                	xchg   %ax,%ax
80105303:	90                   	nop

80105304 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105304:	55                   	push   %ebp
80105305:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105307:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010530d:	8b 00                	mov    (%eax),%eax
8010530f:	3b 45 08             	cmp    0x8(%ebp),%eax
80105312:	76 12                	jbe    80105326 <fetchint+0x22>
80105314:	8b 45 08             	mov    0x8(%ebp),%eax
80105317:	8d 50 04             	lea    0x4(%eax),%edx
8010531a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105320:	8b 00                	mov    (%eax),%eax
80105322:	39 c2                	cmp    %eax,%edx
80105324:	76 07                	jbe    8010532d <fetchint+0x29>
    return -1;
80105326:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532b:	eb 0f                	jmp    8010533c <fetchint+0x38>
  *ip = *(int*)(addr);
8010532d:	8b 45 08             	mov    0x8(%ebp),%eax
80105330:	8b 10                	mov    (%eax),%edx
80105332:	8b 45 0c             	mov    0xc(%ebp),%eax
80105335:	89 10                	mov    %edx,(%eax)
  return 0;
80105337:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010533c:	5d                   	pop    %ebp
8010533d:	c3                   	ret    

8010533e <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010533e:	55                   	push   %ebp
8010533f:	89 e5                	mov    %esp,%ebp
80105341:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105344:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010534a:	8b 00                	mov    (%eax),%eax
8010534c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010534f:	77 07                	ja     80105358 <fetchstr+0x1a>
    return -1;
80105351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105356:	eb 46                	jmp    8010539e <fetchstr+0x60>
  *pp = (char*)addr;
80105358:	8b 55 08             	mov    0x8(%ebp),%edx
8010535b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010535e:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105360:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105366:	8b 00                	mov    (%eax),%eax
80105368:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010536b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010536e:	8b 00                	mov    (%eax),%eax
80105370:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105373:	eb 1c                	jmp    80105391 <fetchstr+0x53>
    if(*s == 0)
80105375:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105378:	0f b6 00             	movzbl (%eax),%eax
8010537b:	84 c0                	test   %al,%al
8010537d:	75 0e                	jne    8010538d <fetchstr+0x4f>
      return s - *pp;
8010537f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105382:	8b 45 0c             	mov    0xc(%ebp),%eax
80105385:	8b 00                	mov    (%eax),%eax
80105387:	29 c2                	sub    %eax,%edx
80105389:	89 d0                	mov    %edx,%eax
8010538b:	eb 11                	jmp    8010539e <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010538d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105391:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105394:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105397:	72 dc                	jb     80105375 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105399:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010539e:	c9                   	leave  
8010539f:	c3                   	ret    

801053a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801053a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053ac:	8b 40 18             	mov    0x18(%eax),%eax
801053af:	8b 50 44             	mov    0x44(%eax),%edx
801053b2:	8b 45 08             	mov    0x8(%ebp),%eax
801053b5:	c1 e0 02             	shl    $0x2,%eax
801053b8:	01 d0                	add    %edx,%eax
801053ba:	8d 50 04             	lea    0x4(%eax),%edx
801053bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801053c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801053c4:	89 14 24             	mov    %edx,(%esp)
801053c7:	e8 38 ff ff ff       	call   80105304 <fetchint>
}
801053cc:	c9                   	leave  
801053cd:	c3                   	ret    

801053ce <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801053ce:	55                   	push   %ebp
801053cf:	89 e5                	mov    %esp,%ebp
801053d1:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
801053d4:	8d 45 fc             	lea    -0x4(%ebp),%eax
801053d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801053db:	8b 45 08             	mov    0x8(%ebp),%eax
801053de:	89 04 24             	mov    %eax,(%esp)
801053e1:	e8 ba ff ff ff       	call   801053a0 <argint>
801053e6:	85 c0                	test   %eax,%eax
801053e8:	79 07                	jns    801053f1 <argptr+0x23>
    return -1;
801053ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ef:	eb 3d                	jmp    8010542e <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801053f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053f4:	89 c2                	mov    %eax,%edx
801053f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053fc:	8b 00                	mov    (%eax),%eax
801053fe:	39 c2                	cmp    %eax,%edx
80105400:	73 16                	jae    80105418 <argptr+0x4a>
80105402:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105405:	89 c2                	mov    %eax,%edx
80105407:	8b 45 10             	mov    0x10(%ebp),%eax
8010540a:	01 c2                	add    %eax,%edx
8010540c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105412:	8b 00                	mov    (%eax),%eax
80105414:	39 c2                	cmp    %eax,%edx
80105416:	76 07                	jbe    8010541f <argptr+0x51>
    return -1;
80105418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541d:	eb 0f                	jmp    8010542e <argptr+0x60>
  *pp = (char*)i;
8010541f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105422:	89 c2                	mov    %eax,%edx
80105424:	8b 45 0c             	mov    0xc(%ebp),%eax
80105427:	89 10                	mov    %edx,(%eax)
  return 0;
80105429:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010542e:	c9                   	leave  
8010542f:	c3                   	ret    

80105430 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105436:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105439:	89 44 24 04          	mov    %eax,0x4(%esp)
8010543d:	8b 45 08             	mov    0x8(%ebp),%eax
80105440:	89 04 24             	mov    %eax,(%esp)
80105443:	e8 58 ff ff ff       	call   801053a0 <argint>
80105448:	85 c0                	test   %eax,%eax
8010544a:	79 07                	jns    80105453 <argstr+0x23>
    return -1;
8010544c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105451:	eb 12                	jmp    80105465 <argstr+0x35>
  return fetchstr(addr, pp);
80105453:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105456:	8b 55 0c             	mov    0xc(%ebp),%edx
80105459:	89 54 24 04          	mov    %edx,0x4(%esp)
8010545d:	89 04 24             	mov    %eax,(%esp)
80105460:	e8 d9 fe ff ff       	call   8010533e <fetchstr>
}
80105465:	c9                   	leave  
80105466:	c3                   	ret    

80105467 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105467:	55                   	push   %ebp
80105468:	89 e5                	mov    %esp,%ebp
8010546a:	53                   	push   %ebx
8010546b:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
8010546e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105474:	8b 40 18             	mov    0x18(%eax),%eax
80105477:	8b 40 1c             	mov    0x1c(%eax),%eax
8010547a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010547d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105481:	7e 30                	jle    801054b3 <syscall+0x4c>
80105483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105486:	83 f8 15             	cmp    $0x15,%eax
80105489:	77 28                	ja     801054b3 <syscall+0x4c>
8010548b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010548e:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105495:	85 c0                	test   %eax,%eax
80105497:	74 1a                	je     801054b3 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105499:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010549f:	8b 58 18             	mov    0x18(%eax),%ebx
801054a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a5:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801054ac:	ff d0                	call   *%eax
801054ae:	89 43 1c             	mov    %eax,0x1c(%ebx)
801054b1:	eb 3d                	jmp    801054f0 <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801054b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054b9:	8d 48 6c             	lea    0x6c(%eax),%ecx
801054bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801054c2:	8b 40 10             	mov    0x10(%eax),%eax
801054c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054c8:	89 54 24 0c          	mov    %edx,0xc(%esp)
801054cc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801054d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801054d4:	c7 04 24 bf 87 10 80 	movl   $0x801087bf,(%esp)
801054db:	e8 c0 ae ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801054e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054e6:	8b 40 18             	mov    0x18(%eax),%eax
801054e9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801054f0:	83 c4 24             	add    $0x24,%esp
801054f3:	5b                   	pop    %ebx
801054f4:	5d                   	pop    %ebp
801054f5:	c3                   	ret    
801054f6:	66 90                	xchg   %ax,%ax

801054f8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801054f8:	55                   	push   %ebp
801054f9:	89 e5                	mov    %esp,%ebp
801054fb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801054fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105501:	89 44 24 04          	mov    %eax,0x4(%esp)
80105505:	8b 45 08             	mov    0x8(%ebp),%eax
80105508:	89 04 24             	mov    %eax,(%esp)
8010550b:	e8 90 fe ff ff       	call   801053a0 <argint>
80105510:	85 c0                	test   %eax,%eax
80105512:	79 07                	jns    8010551b <argfd+0x23>
    return -1;
80105514:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105519:	eb 50                	jmp    8010556b <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010551b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010551e:	85 c0                	test   %eax,%eax
80105520:	78 21                	js     80105543 <argfd+0x4b>
80105522:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105525:	83 f8 0f             	cmp    $0xf,%eax
80105528:	7f 19                	jg     80105543 <argfd+0x4b>
8010552a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105530:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105533:	83 c2 08             	add    $0x8,%edx
80105536:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010553a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010553d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105541:	75 07                	jne    8010554a <argfd+0x52>
    return -1;
80105543:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105548:	eb 21                	jmp    8010556b <argfd+0x73>
  if(pfd)
8010554a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010554e:	74 08                	je     80105558 <argfd+0x60>
    *pfd = fd;
80105550:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105553:	8b 45 0c             	mov    0xc(%ebp),%eax
80105556:	89 10                	mov    %edx,(%eax)
  if(pf)
80105558:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010555c:	74 08                	je     80105566 <argfd+0x6e>
    *pf = f;
8010555e:	8b 45 10             	mov    0x10(%ebp),%eax
80105561:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105564:	89 10                	mov    %edx,(%eax)
  return 0;
80105566:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010556b:	c9                   	leave  
8010556c:	c3                   	ret    

8010556d <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010556d:	55                   	push   %ebp
8010556e:	89 e5                	mov    %esp,%ebp
80105570:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105573:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010557a:	eb 30                	jmp    801055ac <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
8010557c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105582:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105585:	83 c2 08             	add    $0x8,%edx
80105588:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010558c:	85 c0                	test   %eax,%eax
8010558e:	75 18                	jne    801055a8 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105590:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105596:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105599:	8d 4a 08             	lea    0x8(%edx),%ecx
8010559c:	8b 55 08             	mov    0x8(%ebp),%edx
8010559f:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801055a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055a6:	eb 0f                	jmp    801055b7 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801055a8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801055ac:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801055b0:	7e ca                	jle    8010557c <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801055b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055b7:	c9                   	leave  
801055b8:	c3                   	ret    

801055b9 <sys_dup>:

int
sys_dup(void)
{
801055b9:	55                   	push   %ebp
801055ba:	89 e5                	mov    %esp,%ebp
801055bc:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801055bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055c2:	89 44 24 08          	mov    %eax,0x8(%esp)
801055c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801055cd:	00 
801055ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055d5:	e8 1e ff ff ff       	call   801054f8 <argfd>
801055da:	85 c0                	test   %eax,%eax
801055dc:	79 07                	jns    801055e5 <sys_dup+0x2c>
    return -1;
801055de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e3:	eb 29                	jmp    8010560e <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801055e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055e8:	89 04 24             	mov    %eax,(%esp)
801055eb:	e8 7d ff ff ff       	call   8010556d <fdalloc>
801055f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801055f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055f7:	79 07                	jns    80105600 <sys_dup+0x47>
    return -1;
801055f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055fe:	eb 0e                	jmp    8010560e <sys_dup+0x55>
  filedup(f);
80105600:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105603:	89 04 24             	mov    %eax,(%esp)
80105606:	e8 7d b9 ff ff       	call   80100f88 <filedup>
  return fd;
8010560b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010560e:	c9                   	leave  
8010560f:	c3                   	ret    

80105610 <sys_read>:

int
sys_read(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105616:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105619:	89 44 24 08          	mov    %eax,0x8(%esp)
8010561d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105624:	00 
80105625:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010562c:	e8 c7 fe ff ff       	call   801054f8 <argfd>
80105631:	85 c0                	test   %eax,%eax
80105633:	78 35                	js     8010566a <sys_read+0x5a>
80105635:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105638:	89 44 24 04          	mov    %eax,0x4(%esp)
8010563c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105643:	e8 58 fd ff ff       	call   801053a0 <argint>
80105648:	85 c0                	test   %eax,%eax
8010564a:	78 1e                	js     8010566a <sys_read+0x5a>
8010564c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010564f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105653:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105656:	89 44 24 04          	mov    %eax,0x4(%esp)
8010565a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105661:	e8 68 fd ff ff       	call   801053ce <argptr>
80105666:	85 c0                	test   %eax,%eax
80105668:	79 07                	jns    80105671 <sys_read+0x61>
    return -1;
8010566a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566f:	eb 19                	jmp    8010568a <sys_read+0x7a>
  return fileread(f, p, n);
80105671:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105674:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105677:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010567a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010567e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105682:	89 04 24             	mov    %eax,(%esp)
80105685:	e8 6b ba ff ff       	call   801010f5 <fileread>
}
8010568a:	c9                   	leave  
8010568b:	c3                   	ret    

8010568c <sys_write>:

int
sys_write(void)
{
8010568c:	55                   	push   %ebp
8010568d:	89 e5                	mov    %esp,%ebp
8010568f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105692:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105695:	89 44 24 08          	mov    %eax,0x8(%esp)
80105699:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801056a0:	00 
801056a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056a8:	e8 4b fe ff ff       	call   801054f8 <argfd>
801056ad:	85 c0                	test   %eax,%eax
801056af:	78 35                	js     801056e6 <sys_write+0x5a>
801056b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801056b8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801056bf:	e8 dc fc ff ff       	call   801053a0 <argint>
801056c4:	85 c0                	test   %eax,%eax
801056c6:	78 1e                	js     801056e6 <sys_write+0x5a>
801056c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056cb:	89 44 24 08          	mov    %eax,0x8(%esp)
801056cf:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801056d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801056dd:	e8 ec fc ff ff       	call   801053ce <argptr>
801056e2:	85 c0                	test   %eax,%eax
801056e4:	79 07                	jns    801056ed <sys_write+0x61>
    return -1;
801056e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056eb:	eb 19                	jmp    80105706 <sys_write+0x7a>
  return filewrite(f, p, n);
801056ed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801056f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801056f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801056fa:	89 54 24 04          	mov    %edx,0x4(%esp)
801056fe:	89 04 24             	mov    %eax,(%esp)
80105701:	e8 ab ba ff ff       	call   801011b1 <filewrite>
}
80105706:	c9                   	leave  
80105707:	c3                   	ret    

80105708 <sys_close>:

int
sys_close(void)
{
80105708:	55                   	push   %ebp
80105709:	89 e5                	mov    %esp,%ebp
8010570b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010570e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105711:	89 44 24 08          	mov    %eax,0x8(%esp)
80105715:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105718:	89 44 24 04          	mov    %eax,0x4(%esp)
8010571c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105723:	e8 d0 fd ff ff       	call   801054f8 <argfd>
80105728:	85 c0                	test   %eax,%eax
8010572a:	79 07                	jns    80105733 <sys_close+0x2b>
    return -1;
8010572c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105731:	eb 24                	jmp    80105757 <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105733:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105739:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010573c:	83 c2 08             	add    $0x8,%edx
8010573f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105746:	00 
  fileclose(f);
80105747:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010574a:	89 04 24             	mov    %eax,(%esp)
8010574d:	e8 7e b8 ff ff       	call   80100fd0 <fileclose>
  return 0;
80105752:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105757:	c9                   	leave  
80105758:	c3                   	ret    

80105759 <sys_fstat>:

int
sys_fstat(void)
{
80105759:	55                   	push   %ebp
8010575a:	89 e5                	mov    %esp,%ebp
8010575c:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010575f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105762:	89 44 24 08          	mov    %eax,0x8(%esp)
80105766:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010576d:	00 
8010576e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105775:	e8 7e fd ff ff       	call   801054f8 <argfd>
8010577a:	85 c0                	test   %eax,%eax
8010577c:	78 1f                	js     8010579d <sys_fstat+0x44>
8010577e:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105785:	00 
80105786:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105789:	89 44 24 04          	mov    %eax,0x4(%esp)
8010578d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105794:	e8 35 fc ff ff       	call   801053ce <argptr>
80105799:	85 c0                	test   %eax,%eax
8010579b:	79 07                	jns    801057a4 <sys_fstat+0x4b>
    return -1;
8010579d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a2:	eb 12                	jmp    801057b6 <sys_fstat+0x5d>
  return filestat(f, st);
801057a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057aa:	89 54 24 04          	mov    %edx,0x4(%esp)
801057ae:	89 04 24             	mov    %eax,(%esp)
801057b1:	e8 f0 b8 ff ff       	call   801010a6 <filestat>
}
801057b6:	c9                   	leave  
801057b7:	c3                   	ret    

801057b8 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801057b8:	55                   	push   %ebp
801057b9:	89 e5                	mov    %esp,%ebp
801057bb:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801057be:	8d 45 d8             	lea    -0x28(%ebp),%eax
801057c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801057c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057cc:	e8 5f fc ff ff       	call   80105430 <argstr>
801057d1:	85 c0                	test   %eax,%eax
801057d3:	78 17                	js     801057ec <sys_link+0x34>
801057d5:	8d 45 dc             	lea    -0x24(%ebp),%eax
801057d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801057dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057e3:	e8 48 fc ff ff       	call   80105430 <argstr>
801057e8:	85 c0                	test   %eax,%eax
801057ea:	79 0a                	jns    801057f6 <sys_link+0x3e>
    return -1;
801057ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f1:	e9 42 01 00 00       	jmp    80105938 <sys_link+0x180>

  begin_op();
801057f6:	e8 1f dc ff ff       	call   8010341a <begin_op>
  if((ip = namei(old)) == 0){
801057fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
801057fe:	89 04 24             	mov    %eax,(%esp)
80105801:	e8 03 cc ff ff       	call   80102409 <namei>
80105806:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105809:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010580d:	75 0f                	jne    8010581e <sys_link+0x66>
    end_op();
8010580f:	e8 8a dc ff ff       	call   8010349e <end_op>
    return -1;
80105814:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105819:	e9 1a 01 00 00       	jmp    80105938 <sys_link+0x180>
  }

  ilock(ip);
8010581e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105821:	89 04 24             	mov    %eax,(%esp)
80105824:	e8 35 c0 ff ff       	call   8010185e <ilock>
  if(ip->type == T_DIR){
80105829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010582c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105830:	66 83 f8 01          	cmp    $0x1,%ax
80105834:	75 1a                	jne    80105850 <sys_link+0x98>
    iunlockput(ip);
80105836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105839:	89 04 24             	mov    %eax,(%esp)
8010583c:	e8 a1 c2 ff ff       	call   80101ae2 <iunlockput>
    end_op();
80105841:	e8 58 dc ff ff       	call   8010349e <end_op>
    return -1;
80105846:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584b:	e9 e8 00 00 00       	jmp    80105938 <sys_link+0x180>
  }

  ip->nlink++;
80105850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105853:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105857:	8d 50 01             	lea    0x1(%eax),%edx
8010585a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585d:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105864:	89 04 24             	mov    %eax,(%esp)
80105867:	e8 36 be ff ff       	call   801016a2 <iupdate>
  iunlock(ip);
8010586c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010586f:	89 04 24             	mov    %eax,(%esp)
80105872:	e8 35 c1 ff ff       	call   801019ac <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105877:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010587a:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010587d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105881:	89 04 24             	mov    %eax,(%esp)
80105884:	e8 a2 cb ff ff       	call   8010242b <nameiparent>
80105889:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010588c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105890:	75 02                	jne    80105894 <sys_link+0xdc>
    goto bad;
80105892:	eb 68                	jmp    801058fc <sys_link+0x144>
  ilock(dp);
80105894:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105897:	89 04 24             	mov    %eax,(%esp)
8010589a:	e8 bf bf ff ff       	call   8010185e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010589f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a2:	8b 10                	mov    (%eax),%edx
801058a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058a7:	8b 00                	mov    (%eax),%eax
801058a9:	39 c2                	cmp    %eax,%edx
801058ab:	75 20                	jne    801058cd <sys_link+0x115>
801058ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058b0:	8b 40 04             	mov    0x4(%eax),%eax
801058b3:	89 44 24 08          	mov    %eax,0x8(%esp)
801058b7:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801058ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801058be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058c1:	89 04 24             	mov    %eax,(%esp)
801058c4:	e8 80 c8 ff ff       	call   80102149 <dirlink>
801058c9:	85 c0                	test   %eax,%eax
801058cb:	79 0d                	jns    801058da <sys_link+0x122>
    iunlockput(dp);
801058cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058d0:	89 04 24             	mov    %eax,(%esp)
801058d3:	e8 0a c2 ff ff       	call   80101ae2 <iunlockput>
    goto bad;
801058d8:	eb 22                	jmp    801058fc <sys_link+0x144>
  }
  iunlockput(dp);
801058da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058dd:	89 04 24             	mov    %eax,(%esp)
801058e0:	e8 fd c1 ff ff       	call   80101ae2 <iunlockput>
  iput(ip);
801058e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058e8:	89 04 24             	mov    %eax,(%esp)
801058eb:	e8 21 c1 ff ff       	call   80101a11 <iput>

  end_op();
801058f0:	e8 a9 db ff ff       	call   8010349e <end_op>

  return 0;
801058f5:	b8 00 00 00 00       	mov    $0x0,%eax
801058fa:	eb 3c                	jmp    80105938 <sys_link+0x180>

bad:
  ilock(ip);
801058fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ff:	89 04 24             	mov    %eax,(%esp)
80105902:	e8 57 bf ff ff       	call   8010185e <ilock>
  ip->nlink--;
80105907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010590a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010590e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105911:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105914:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105918:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010591b:	89 04 24             	mov    %eax,(%esp)
8010591e:	e8 7f bd ff ff       	call   801016a2 <iupdate>
  iunlockput(ip);
80105923:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105926:	89 04 24             	mov    %eax,(%esp)
80105929:	e8 b4 c1 ff ff       	call   80101ae2 <iunlockput>
  end_op();
8010592e:	e8 6b db ff ff       	call   8010349e <end_op>
  return -1;
80105933:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105938:	c9                   	leave  
80105939:	c3                   	ret    

8010593a <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010593a:	55                   	push   %ebp
8010593b:	89 e5                	mov    %esp,%ebp
8010593d:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105940:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105947:	eb 4b                	jmp    80105994 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105949:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010594c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105953:	00 
80105954:	89 44 24 08          	mov    %eax,0x8(%esp)
80105958:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010595b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010595f:	8b 45 08             	mov    0x8(%ebp),%eax
80105962:	89 04 24             	mov    %eax,(%esp)
80105965:	e8 01 c4 ff ff       	call   80101d6b <readi>
8010596a:	83 f8 10             	cmp    $0x10,%eax
8010596d:	74 0c                	je     8010597b <isdirempty+0x41>
      panic("isdirempty: readi");
8010596f:	c7 04 24 db 87 10 80 	movl   $0x801087db,(%esp)
80105976:	e8 bf ab ff ff       	call   8010053a <panic>
    if(de.inum != 0)
8010597b:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010597f:	66 85 c0             	test   %ax,%ax
80105982:	74 07                	je     8010598b <isdirempty+0x51>
      return 0;
80105984:	b8 00 00 00 00       	mov    $0x0,%eax
80105989:	eb 1b                	jmp    801059a6 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010598b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598e:	83 c0 10             	add    $0x10,%eax
80105991:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105994:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105997:	8b 45 08             	mov    0x8(%ebp),%eax
8010599a:	8b 40 18             	mov    0x18(%eax),%eax
8010599d:	39 c2                	cmp    %eax,%edx
8010599f:	72 a8                	jb     80105949 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801059a1:	b8 01 00 00 00       	mov    $0x1,%eax
}
801059a6:	c9                   	leave  
801059a7:	c3                   	ret    

801059a8 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801059a8:	55                   	push   %ebp
801059a9:	89 e5                	mov    %esp,%ebp
801059ab:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801059ae:	8d 45 cc             	lea    -0x34(%ebp),%eax
801059b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801059b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059bc:	e8 6f fa ff ff       	call   80105430 <argstr>
801059c1:	85 c0                	test   %eax,%eax
801059c3:	79 0a                	jns    801059cf <sys_unlink+0x27>
    return -1;
801059c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ca:	e9 af 01 00 00       	jmp    80105b7e <sys_unlink+0x1d6>

  begin_op();
801059cf:	e8 46 da ff ff       	call   8010341a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801059d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
801059d7:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801059da:	89 54 24 04          	mov    %edx,0x4(%esp)
801059de:	89 04 24             	mov    %eax,(%esp)
801059e1:	e8 45 ca ff ff       	call   8010242b <nameiparent>
801059e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059ed:	75 0f                	jne    801059fe <sys_unlink+0x56>
    end_op();
801059ef:	e8 aa da ff ff       	call   8010349e <end_op>
    return -1;
801059f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f9:	e9 80 01 00 00       	jmp    80105b7e <sys_unlink+0x1d6>
  }

  ilock(dp);
801059fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a01:	89 04 24             	mov    %eax,(%esp)
80105a04:	e8 55 be ff ff       	call   8010185e <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105a09:	c7 44 24 04 ed 87 10 	movl   $0x801087ed,0x4(%esp)
80105a10:	80 
80105a11:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a14:	89 04 24             	mov    %eax,(%esp)
80105a17:	e8 42 c6 ff ff       	call   8010205e <namecmp>
80105a1c:	85 c0                	test   %eax,%eax
80105a1e:	0f 84 45 01 00 00    	je     80105b69 <sys_unlink+0x1c1>
80105a24:	c7 44 24 04 ef 87 10 	movl   $0x801087ef,0x4(%esp)
80105a2b:	80 
80105a2c:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a2f:	89 04 24             	mov    %eax,(%esp)
80105a32:	e8 27 c6 ff ff       	call   8010205e <namecmp>
80105a37:	85 c0                	test   %eax,%eax
80105a39:	0f 84 2a 01 00 00    	je     80105b69 <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105a3f:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105a42:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a46:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a49:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a50:	89 04 24             	mov    %eax,(%esp)
80105a53:	e8 28 c6 ff ff       	call   80102080 <dirlookup>
80105a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a5f:	75 05                	jne    80105a66 <sys_unlink+0xbe>
    goto bad;
80105a61:	e9 03 01 00 00       	jmp    80105b69 <sys_unlink+0x1c1>
  ilock(ip);
80105a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a69:	89 04 24             	mov    %eax,(%esp)
80105a6c:	e8 ed bd ff ff       	call   8010185e <ilock>

  if(ip->nlink < 1)
80105a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a74:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a78:	66 85 c0             	test   %ax,%ax
80105a7b:	7f 0c                	jg     80105a89 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105a7d:	c7 04 24 f2 87 10 80 	movl   $0x801087f2,(%esp)
80105a84:	e8 b1 aa ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a8c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105a90:	66 83 f8 01          	cmp    $0x1,%ax
80105a94:	75 1f                	jne    80105ab5 <sys_unlink+0x10d>
80105a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a99:	89 04 24             	mov    %eax,(%esp)
80105a9c:	e8 99 fe ff ff       	call   8010593a <isdirempty>
80105aa1:	85 c0                	test   %eax,%eax
80105aa3:	75 10                	jne    80105ab5 <sys_unlink+0x10d>
    iunlockput(ip);
80105aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa8:	89 04 24             	mov    %eax,(%esp)
80105aab:	e8 32 c0 ff ff       	call   80101ae2 <iunlockput>
    goto bad;
80105ab0:	e9 b4 00 00 00       	jmp    80105b69 <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80105ab5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105abc:	00 
80105abd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105ac4:	00 
80105ac5:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ac8:	89 04 24             	mov    %eax,(%esp)
80105acb:	e8 8a f5 ff ff       	call   8010505a <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ad0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105ad3:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105ada:	00 
80105adb:	89 44 24 08          	mov    %eax,0x8(%esp)
80105adf:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae9:	89 04 24             	mov    %eax,(%esp)
80105aec:	e8 de c3 ff ff       	call   80101ecf <writei>
80105af1:	83 f8 10             	cmp    $0x10,%eax
80105af4:	74 0c                	je     80105b02 <sys_unlink+0x15a>
    panic("unlink: writei");
80105af6:	c7 04 24 04 88 10 80 	movl   $0x80108804,(%esp)
80105afd:	e8 38 aa ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80105b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b05:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105b09:	66 83 f8 01          	cmp    $0x1,%ax
80105b0d:	75 1c                	jne    80105b2b <sys_unlink+0x183>
    dp->nlink--;
80105b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b12:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b16:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b1c:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b23:	89 04 24             	mov    %eax,(%esp)
80105b26:	e8 77 bb ff ff       	call   801016a2 <iupdate>
  }
  iunlockput(dp);
80105b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2e:	89 04 24             	mov    %eax,(%esp)
80105b31:	e8 ac bf ff ff       	call   80101ae2 <iunlockput>

  ip->nlink--;
80105b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b39:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b3d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b43:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b4a:	89 04 24             	mov    %eax,(%esp)
80105b4d:	e8 50 bb ff ff       	call   801016a2 <iupdate>
  iunlockput(ip);
80105b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b55:	89 04 24             	mov    %eax,(%esp)
80105b58:	e8 85 bf ff ff       	call   80101ae2 <iunlockput>

  end_op();
80105b5d:	e8 3c d9 ff ff       	call   8010349e <end_op>

  return 0;
80105b62:	b8 00 00 00 00       	mov    $0x0,%eax
80105b67:	eb 15                	jmp    80105b7e <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
80105b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6c:	89 04 24             	mov    %eax,(%esp)
80105b6f:	e8 6e bf ff ff       	call   80101ae2 <iunlockput>
  end_op();
80105b74:	e8 25 d9 ff ff       	call   8010349e <end_op>
  return -1;
80105b79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b7e:	c9                   	leave  
80105b7f:	c3                   	ret    

80105b80 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	83 ec 48             	sub    $0x48,%esp
80105b86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105b89:	8b 55 10             	mov    0x10(%ebp),%edx
80105b8c:	8b 45 14             	mov    0x14(%ebp),%eax
80105b8f:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105b93:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105b97:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105b9b:	8d 45 de             	lea    -0x22(%ebp),%eax
80105b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ba2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ba5:	89 04 24             	mov    %eax,(%esp)
80105ba8:	e8 7e c8 ff ff       	call   8010242b <nameiparent>
80105bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bb4:	75 0a                	jne    80105bc0 <create+0x40>
    return 0;
80105bb6:	b8 00 00 00 00       	mov    $0x0,%eax
80105bbb:	e9 7e 01 00 00       	jmp    80105d3e <create+0x1be>
  ilock(dp);
80105bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc3:	89 04 24             	mov    %eax,(%esp)
80105bc6:	e8 93 bc ff ff       	call   8010185e <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105bcb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bce:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bd2:	8d 45 de             	lea    -0x22(%ebp),%eax
80105bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bdc:	89 04 24             	mov    %eax,(%esp)
80105bdf:	e8 9c c4 ff ff       	call   80102080 <dirlookup>
80105be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105be7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105beb:	74 47                	je     80105c34 <create+0xb4>
    iunlockput(dp);
80105bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf0:	89 04 24             	mov    %eax,(%esp)
80105bf3:	e8 ea be ff ff       	call   80101ae2 <iunlockput>
    ilock(ip);
80105bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bfb:	89 04 24             	mov    %eax,(%esp)
80105bfe:	e8 5b bc ff ff       	call   8010185e <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105c03:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105c08:	75 15                	jne    80105c1f <create+0x9f>
80105c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c0d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c11:	66 83 f8 02          	cmp    $0x2,%ax
80105c15:	75 08                	jne    80105c1f <create+0x9f>
      return ip;
80105c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1a:	e9 1f 01 00 00       	jmp    80105d3e <create+0x1be>
    iunlockput(ip);
80105c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c22:	89 04 24             	mov    %eax,(%esp)
80105c25:	e8 b8 be ff ff       	call   80101ae2 <iunlockput>
    return 0;
80105c2a:	b8 00 00 00 00       	mov    $0x0,%eax
80105c2f:	e9 0a 01 00 00       	jmp    80105d3e <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105c34:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3b:	8b 00                	mov    (%eax),%eax
80105c3d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c41:	89 04 24             	mov    %eax,(%esp)
80105c44:	e8 7a b9 ff ff       	call   801015c3 <ialloc>
80105c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c50:	75 0c                	jne    80105c5e <create+0xde>
    panic("create: ialloc");
80105c52:	c7 04 24 13 88 10 80 	movl   $0x80108813,(%esp)
80105c59:	e8 dc a8 ff ff       	call   8010053a <panic>

  ilock(ip);
80105c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c61:	89 04 24             	mov    %eax,(%esp)
80105c64:	e8 f5 bb ff ff       	call   8010185e <ilock>
  ip->major = major;
80105c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c6c:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105c70:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c77:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105c7b:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c82:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c8b:	89 04 24             	mov    %eax,(%esp)
80105c8e:	e8 0f ba ff ff       	call   801016a2 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105c93:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105c98:	75 6a                	jne    80105d04 <create+0x184>
    dp->nlink++;  // for ".."
80105c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ca1:	8d 50 01             	lea    0x1(%eax),%edx
80105ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca7:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cae:	89 04 24             	mov    %eax,(%esp)
80105cb1:	e8 ec b9 ff ff       	call   801016a2 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cb9:	8b 40 04             	mov    0x4(%eax),%eax
80105cbc:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cc0:	c7 44 24 04 ed 87 10 	movl   $0x801087ed,0x4(%esp)
80105cc7:	80 
80105cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ccb:	89 04 24             	mov    %eax,(%esp)
80105cce:	e8 76 c4 ff ff       	call   80102149 <dirlink>
80105cd3:	85 c0                	test   %eax,%eax
80105cd5:	78 21                	js     80105cf8 <create+0x178>
80105cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cda:	8b 40 04             	mov    0x4(%eax),%eax
80105cdd:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ce1:	c7 44 24 04 ef 87 10 	movl   $0x801087ef,0x4(%esp)
80105ce8:	80 
80105ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cec:	89 04 24             	mov    %eax,(%esp)
80105cef:	e8 55 c4 ff ff       	call   80102149 <dirlink>
80105cf4:	85 c0                	test   %eax,%eax
80105cf6:	79 0c                	jns    80105d04 <create+0x184>
      panic("create dots");
80105cf8:	c7 04 24 22 88 10 80 	movl   $0x80108822,(%esp)
80105cff:	e8 36 a8 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d07:	8b 40 04             	mov    0x4(%eax),%eax
80105d0a:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d0e:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d11:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d18:	89 04 24             	mov    %eax,(%esp)
80105d1b:	e8 29 c4 ff ff       	call   80102149 <dirlink>
80105d20:	85 c0                	test   %eax,%eax
80105d22:	79 0c                	jns    80105d30 <create+0x1b0>
    panic("create: dirlink");
80105d24:	c7 04 24 2e 88 10 80 	movl   $0x8010882e,(%esp)
80105d2b:	e8 0a a8 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80105d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d33:	89 04 24             	mov    %eax,(%esp)
80105d36:	e8 a7 bd ff ff       	call   80101ae2 <iunlockput>

  return ip;
80105d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105d3e:	c9                   	leave  
80105d3f:	c3                   	ret    

80105d40 <sys_open>:

int
sys_open(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d46:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d49:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d4d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d54:	e8 d7 f6 ff ff       	call   80105430 <argstr>
80105d59:	85 c0                	test   %eax,%eax
80105d5b:	78 17                	js     80105d74 <sys_open+0x34>
80105d5d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d60:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d6b:	e8 30 f6 ff ff       	call   801053a0 <argint>
80105d70:	85 c0                	test   %eax,%eax
80105d72:	79 0a                	jns    80105d7e <sys_open+0x3e>
    return -1;
80105d74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d79:	e9 5c 01 00 00       	jmp    80105eda <sys_open+0x19a>

  begin_op();
80105d7e:	e8 97 d6 ff ff       	call   8010341a <begin_op>

  if(omode & O_CREATE){
80105d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d86:	25 00 02 00 00       	and    $0x200,%eax
80105d8b:	85 c0                	test   %eax,%eax
80105d8d:	74 3b                	je     80105dca <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105d8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d92:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105d99:	00 
80105d9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105da1:	00 
80105da2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105da9:	00 
80105daa:	89 04 24             	mov    %eax,(%esp)
80105dad:	e8 ce fd ff ff       	call   80105b80 <create>
80105db2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105db5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105db9:	75 6b                	jne    80105e26 <sys_open+0xe6>
      end_op();
80105dbb:	e8 de d6 ff ff       	call   8010349e <end_op>
      return -1;
80105dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dc5:	e9 10 01 00 00       	jmp    80105eda <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
80105dca:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105dcd:	89 04 24             	mov    %eax,(%esp)
80105dd0:	e8 34 c6 ff ff       	call   80102409 <namei>
80105dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105dd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ddc:	75 0f                	jne    80105ded <sys_open+0xad>
      end_op();
80105dde:	e8 bb d6 ff ff       	call   8010349e <end_op>
      return -1;
80105de3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de8:	e9 ed 00 00 00       	jmp    80105eda <sys_open+0x19a>
    }
    ilock(ip);
80105ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df0:	89 04 24             	mov    %eax,(%esp)
80105df3:	e8 66 ba ff ff       	call   8010185e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dfb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105dff:	66 83 f8 01          	cmp    $0x1,%ax
80105e03:	75 21                	jne    80105e26 <sys_open+0xe6>
80105e05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e08:	85 c0                	test   %eax,%eax
80105e0a:	74 1a                	je     80105e26 <sys_open+0xe6>
      iunlockput(ip);
80105e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e0f:	89 04 24             	mov    %eax,(%esp)
80105e12:	e8 cb bc ff ff       	call   80101ae2 <iunlockput>
      end_op();
80105e17:	e8 82 d6 ff ff       	call   8010349e <end_op>
      return -1;
80105e1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e21:	e9 b4 00 00 00       	jmp    80105eda <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105e26:	e8 fd b0 ff ff       	call   80100f28 <filealloc>
80105e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e32:	74 14                	je     80105e48 <sys_open+0x108>
80105e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e37:	89 04 24             	mov    %eax,(%esp)
80105e3a:	e8 2e f7 ff ff       	call   8010556d <fdalloc>
80105e3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105e42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105e46:	79 28                	jns    80105e70 <sys_open+0x130>
    if(f)
80105e48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e4c:	74 0b                	je     80105e59 <sys_open+0x119>
      fileclose(f);
80105e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e51:	89 04 24             	mov    %eax,(%esp)
80105e54:	e8 77 b1 ff ff       	call   80100fd0 <fileclose>
    iunlockput(ip);
80105e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e5c:	89 04 24             	mov    %eax,(%esp)
80105e5f:	e8 7e bc ff ff       	call   80101ae2 <iunlockput>
    end_op();
80105e64:	e8 35 d6 ff ff       	call   8010349e <end_op>
    return -1;
80105e69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e6e:	eb 6a                	jmp    80105eda <sys_open+0x19a>
  }
  iunlock(ip);
80105e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e73:	89 04 24             	mov    %eax,(%esp)
80105e76:	e8 31 bb ff ff       	call   801019ac <iunlock>
  end_op();
80105e7b:	e8 1e d6 ff ff       	call   8010349e <end_op>

  f->type = FD_INODE;
80105e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e83:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e8f:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e95:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105e9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e9f:	83 e0 01             	and    $0x1,%eax
80105ea2:	85 c0                	test   %eax,%eax
80105ea4:	0f 94 c0             	sete   %al
80105ea7:	89 c2                	mov    %eax,%edx
80105ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eac:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105eb2:	83 e0 01             	and    $0x1,%eax
80105eb5:	85 c0                	test   %eax,%eax
80105eb7:	75 0a                	jne    80105ec3 <sys_open+0x183>
80105eb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ebc:	83 e0 02             	and    $0x2,%eax
80105ebf:	85 c0                	test   %eax,%eax
80105ec1:	74 07                	je     80105eca <sys_open+0x18a>
80105ec3:	b8 01 00 00 00       	mov    $0x1,%eax
80105ec8:	eb 05                	jmp    80105ecf <sys_open+0x18f>
80105eca:	b8 00 00 00 00       	mov    $0x0,%eax
80105ecf:	89 c2                	mov    %eax,%edx
80105ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed4:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105eda:	c9                   	leave  
80105edb:	c3                   	ret    

80105edc <sys_mkdir>:

int
sys_mkdir(void)
{
80105edc:	55                   	push   %ebp
80105edd:	89 e5                	mov    %esp,%ebp
80105edf:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ee2:	e8 33 d5 ff ff       	call   8010341a <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105ee7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105eea:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ef5:	e8 36 f5 ff ff       	call   80105430 <argstr>
80105efa:	85 c0                	test   %eax,%eax
80105efc:	78 2c                	js     80105f2a <sys_mkdir+0x4e>
80105efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f01:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105f08:	00 
80105f09:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105f10:	00 
80105f11:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105f18:	00 
80105f19:	89 04 24             	mov    %eax,(%esp)
80105f1c:	e8 5f fc ff ff       	call   80105b80 <create>
80105f21:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f28:	75 0c                	jne    80105f36 <sys_mkdir+0x5a>
    end_op();
80105f2a:	e8 6f d5 ff ff       	call   8010349e <end_op>
    return -1;
80105f2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f34:	eb 15                	jmp    80105f4b <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f39:	89 04 24             	mov    %eax,(%esp)
80105f3c:	e8 a1 bb ff ff       	call   80101ae2 <iunlockput>
  end_op();
80105f41:	e8 58 d5 ff ff       	call   8010349e <end_op>
  return 0;
80105f46:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f4b:	c9                   	leave  
80105f4c:	c3                   	ret    

80105f4d <sys_mknod>:

int
sys_mknod(void)
{
80105f4d:	55                   	push   %ebp
80105f4e:	89 e5                	mov    %esp,%ebp
80105f50:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80105f53:	e8 c2 d4 ff ff       	call   8010341a <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80105f58:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f5f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f66:	e8 c5 f4 ff ff       	call   80105430 <argstr>
80105f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f72:	78 5e                	js     80105fd2 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80105f74:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105f77:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f82:	e8 19 f4 ff ff       	call   801053a0 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80105f87:	85 c0                	test   %eax,%eax
80105f89:	78 47                	js     80105fd2 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105f8b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f92:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105f99:	e8 02 f4 ff ff       	call   801053a0 <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105f9e:	85 c0                	test   %eax,%eax
80105fa0:	78 30                	js     80105fd2 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105fa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fa5:	0f bf c8             	movswl %ax,%ecx
80105fa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105fab:	0f bf d0             	movswl %ax,%edx
80105fae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105fb1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105fb5:	89 54 24 08          	mov    %edx,0x8(%esp)
80105fb9:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105fc0:	00 
80105fc1:	89 04 24             	mov    %eax,(%esp)
80105fc4:	e8 b7 fb ff ff       	call   80105b80 <create>
80105fc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fd0:	75 0c                	jne    80105fde <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105fd2:	e8 c7 d4 ff ff       	call   8010349e <end_op>
    return -1;
80105fd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fdc:	eb 15                	jmp    80105ff3 <sys_mknod+0xa6>
  }
  iunlockput(ip);
80105fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe1:	89 04 24             	mov    %eax,(%esp)
80105fe4:	e8 f9 ba ff ff       	call   80101ae2 <iunlockput>
  end_op();
80105fe9:	e8 b0 d4 ff ff       	call   8010349e <end_op>
  return 0;
80105fee:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ff3:	c9                   	leave  
80105ff4:	c3                   	ret    

80105ff5 <sys_chdir>:

int
sys_chdir(void)
{
80105ff5:	55                   	push   %ebp
80105ff6:	89 e5                	mov    %esp,%ebp
80105ff8:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ffb:	e8 1a d4 ff ff       	call   8010341a <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106000:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106003:	89 44 24 04          	mov    %eax,0x4(%esp)
80106007:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010600e:	e8 1d f4 ff ff       	call   80105430 <argstr>
80106013:	85 c0                	test   %eax,%eax
80106015:	78 14                	js     8010602b <sys_chdir+0x36>
80106017:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010601a:	89 04 24             	mov    %eax,(%esp)
8010601d:	e8 e7 c3 ff ff       	call   80102409 <namei>
80106022:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106025:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106029:	75 0c                	jne    80106037 <sys_chdir+0x42>
    end_op();
8010602b:	e8 6e d4 ff ff       	call   8010349e <end_op>
    return -1;
80106030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106035:	eb 61                	jmp    80106098 <sys_chdir+0xa3>
  }
  ilock(ip);
80106037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010603a:	89 04 24             	mov    %eax,(%esp)
8010603d:	e8 1c b8 ff ff       	call   8010185e <ilock>
  if(ip->type != T_DIR){
80106042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106045:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106049:	66 83 f8 01          	cmp    $0x1,%ax
8010604d:	74 17                	je     80106066 <sys_chdir+0x71>
    iunlockput(ip);
8010604f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106052:	89 04 24             	mov    %eax,(%esp)
80106055:	e8 88 ba ff ff       	call   80101ae2 <iunlockput>
    end_op();
8010605a:	e8 3f d4 ff ff       	call   8010349e <end_op>
    return -1;
8010605f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106064:	eb 32                	jmp    80106098 <sys_chdir+0xa3>
  }
  iunlock(ip);
80106066:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106069:	89 04 24             	mov    %eax,(%esp)
8010606c:	e8 3b b9 ff ff       	call   801019ac <iunlock>
  iput(proc->cwd);
80106071:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106077:	8b 40 68             	mov    0x68(%eax),%eax
8010607a:	89 04 24             	mov    %eax,(%esp)
8010607d:	e8 8f b9 ff ff       	call   80101a11 <iput>
  end_op();
80106082:	e8 17 d4 ff ff       	call   8010349e <end_op>
  proc->cwd = ip;
80106087:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010608d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106090:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106093:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106098:	c9                   	leave  
80106099:	c3                   	ret    

8010609a <sys_exec>:

int
sys_exec(void)
{
8010609a:	55                   	push   %ebp
8010609b:	89 e5                	mov    %esp,%ebp
8010609d:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801060aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060b1:	e8 7a f3 ff ff       	call   80105430 <argstr>
801060b6:	85 c0                	test   %eax,%eax
801060b8:	78 1a                	js     801060d4 <sys_exec+0x3a>
801060ba:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801060c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801060c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060cb:	e8 d0 f2 ff ff       	call   801053a0 <argint>
801060d0:	85 c0                	test   %eax,%eax
801060d2:	79 0a                	jns    801060de <sys_exec+0x44>
    return -1;
801060d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060d9:	e9 c8 00 00 00       	jmp    801061a6 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
801060de:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801060e5:	00 
801060e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801060ed:	00 
801060ee:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801060f4:	89 04 24             	mov    %eax,(%esp)
801060f7:	e8 5e ef ff ff       	call   8010505a <memset>
  for(i=0;; i++){
801060fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106103:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106106:	83 f8 1f             	cmp    $0x1f,%eax
80106109:	76 0a                	jbe    80106115 <sys_exec+0x7b>
      return -1;
8010610b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106110:	e9 91 00 00 00       	jmp    801061a6 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106118:	c1 e0 02             	shl    $0x2,%eax
8010611b:	89 c2                	mov    %eax,%edx
8010611d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106123:	01 c2                	add    %eax,%edx
80106125:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010612b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010612f:	89 14 24             	mov    %edx,(%esp)
80106132:	e8 cd f1 ff ff       	call   80105304 <fetchint>
80106137:	85 c0                	test   %eax,%eax
80106139:	79 07                	jns    80106142 <sys_exec+0xa8>
      return -1;
8010613b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106140:	eb 64                	jmp    801061a6 <sys_exec+0x10c>
    if(uarg == 0){
80106142:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106148:	85 c0                	test   %eax,%eax
8010614a:	75 26                	jne    80106172 <sys_exec+0xd8>
      argv[i] = 0;
8010614c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010614f:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106156:	00 00 00 00 
      break;
8010615a:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010615b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010615e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106164:	89 54 24 04          	mov    %edx,0x4(%esp)
80106168:	89 04 24             	mov    %eax,(%esp)
8010616b:	e8 80 a9 ff ff       	call   80100af0 <exec>
80106170:	eb 34                	jmp    801061a6 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106172:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106178:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010617b:	c1 e2 02             	shl    $0x2,%edx
8010617e:	01 c2                	add    %eax,%edx
80106180:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106186:	89 54 24 04          	mov    %edx,0x4(%esp)
8010618a:	89 04 24             	mov    %eax,(%esp)
8010618d:	e8 ac f1 ff ff       	call   8010533e <fetchstr>
80106192:	85 c0                	test   %eax,%eax
80106194:	79 07                	jns    8010619d <sys_exec+0x103>
      return -1;
80106196:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010619b:	eb 09                	jmp    801061a6 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
8010619d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801061a1:	e9 5d ff ff ff       	jmp    80106103 <sys_exec+0x69>
  return exec(path, argv);
}
801061a6:	c9                   	leave  
801061a7:	c3                   	ret    

801061a8 <sys_pipe>:

int
sys_pipe(void)
{
801061a8:	55                   	push   %ebp
801061a9:	89 e5                	mov    %esp,%ebp
801061ab:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801061ae:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801061b5:	00 
801061b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801061bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061c4:	e8 05 f2 ff ff       	call   801053ce <argptr>
801061c9:	85 c0                	test   %eax,%eax
801061cb:	79 0a                	jns    801061d7 <sys_pipe+0x2f>
    return -1;
801061cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061d2:	e9 9b 00 00 00       	jmp    80106272 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
801061d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061da:	89 44 24 04          	mov    %eax,0x4(%esp)
801061de:	8d 45 e8             	lea    -0x18(%ebp),%eax
801061e1:	89 04 24             	mov    %eax,(%esp)
801061e4:	e8 4b dd ff ff       	call   80103f34 <pipealloc>
801061e9:	85 c0                	test   %eax,%eax
801061eb:	79 07                	jns    801061f4 <sys_pipe+0x4c>
    return -1;
801061ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061f2:	eb 7e                	jmp    80106272 <sys_pipe+0xca>
  fd0 = -1;
801061f4:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801061fe:	89 04 24             	mov    %eax,(%esp)
80106201:	e8 67 f3 ff ff       	call   8010556d <fdalloc>
80106206:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010620d:	78 14                	js     80106223 <sys_pipe+0x7b>
8010620f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106212:	89 04 24             	mov    %eax,(%esp)
80106215:	e8 53 f3 ff ff       	call   8010556d <fdalloc>
8010621a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010621d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106221:	79 37                	jns    8010625a <sys_pipe+0xb2>
    if(fd0 >= 0)
80106223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106227:	78 14                	js     8010623d <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106229:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010622f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106232:	83 c2 08             	add    $0x8,%edx
80106235:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010623c:	00 
    fileclose(rf);
8010623d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106240:	89 04 24             	mov    %eax,(%esp)
80106243:	e8 88 ad ff ff       	call   80100fd0 <fileclose>
    fileclose(wf);
80106248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010624b:	89 04 24             	mov    %eax,(%esp)
8010624e:	e8 7d ad ff ff       	call   80100fd0 <fileclose>
    return -1;
80106253:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106258:	eb 18                	jmp    80106272 <sys_pipe+0xca>
  }
  fd[0] = fd0;
8010625a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010625d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106260:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106262:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106265:	8d 50 04             	lea    0x4(%eax),%edx
80106268:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010626b:	89 02                	mov    %eax,(%edx)
  return 0;
8010626d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106272:	c9                   	leave  
80106273:	c3                   	ret    

80106274 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106274:	55                   	push   %ebp
80106275:	89 e5                	mov    %esp,%ebp
80106277:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010627a:	e8 63 e3 ff ff       	call   801045e2 <fork>
}
8010627f:	c9                   	leave  
80106280:	c3                   	ret    

80106281 <sys_exit>:

int
sys_exit(void)
{
80106281:	55                   	push   %ebp
80106282:	89 e5                	mov    %esp,%ebp
80106284:	83 ec 08             	sub    $0x8,%esp
  exit();
80106287:	e8 d1 e4 ff ff       	call   8010475d <exit>
  return 0;  // not reached
8010628c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106291:	c9                   	leave  
80106292:	c3                   	ret    

80106293 <sys_wait>:

int
sys_wait(void)
{
80106293:	55                   	push   %ebp
80106294:	89 e5                	mov    %esp,%ebp
80106296:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106299:	e8 e1 e5 ff ff       	call   8010487f <wait>
}
8010629e:	c9                   	leave  
8010629f:	c3                   	ret    

801062a0 <sys_kill>:

int
sys_kill(void)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
801062a3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801062a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801062ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062b4:	e8 e7 f0 ff ff       	call   801053a0 <argint>
801062b9:	85 c0                	test   %eax,%eax
801062bb:	79 07                	jns    801062c4 <sys_kill+0x24>
    return -1;
801062bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062c2:	eb 0b                	jmp    801062cf <sys_kill+0x2f>
  return kill(pid);
801062c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c7:	89 04 24             	mov    %eax,(%esp)
801062ca:	e8 6b e9 ff ff       	call   80104c3a <kill>
}
801062cf:	c9                   	leave  
801062d0:	c3                   	ret    

801062d1 <sys_getpid>:

int
sys_getpid(void)
{
801062d1:	55                   	push   %ebp
801062d2:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801062d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062da:	8b 40 10             	mov    0x10(%eax),%eax
}
801062dd:	5d                   	pop    %ebp
801062de:	c3                   	ret    

801062df <sys_sbrk>:

int
sys_sbrk(void)
{
801062df:	55                   	push   %ebp
801062e0:	89 e5                	mov    %esp,%ebp
801062e2:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801062e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801062ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062f3:	e8 a8 f0 ff ff       	call   801053a0 <argint>
801062f8:	85 c0                	test   %eax,%eax
801062fa:	79 07                	jns    80106303 <sys_sbrk+0x24>
    return -1;
801062fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106301:	eb 24                	jmp    80106327 <sys_sbrk+0x48>
  addr = proc->sz;
80106303:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106309:	8b 00                	mov    (%eax),%eax
8010630b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010630e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106311:	89 04 24             	mov    %eax,(%esp)
80106314:	e8 24 e2 ff ff       	call   8010453d <growproc>
80106319:	85 c0                	test   %eax,%eax
8010631b:	79 07                	jns    80106324 <sys_sbrk+0x45>
    return -1;
8010631d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106322:	eb 03                	jmp    80106327 <sys_sbrk+0x48>
  return addr;
80106324:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106327:	c9                   	leave  
80106328:	c3                   	ret    

80106329 <sys_sleep>:

int
sys_sleep(void)
{
80106329:	55                   	push   %ebp
8010632a:	89 e5                	mov    %esp,%ebp
8010632c:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010632f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106332:	89 44 24 04          	mov    %eax,0x4(%esp)
80106336:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010633d:	e8 5e f0 ff ff       	call   801053a0 <argint>
80106342:	85 c0                	test   %eax,%eax
80106344:	79 07                	jns    8010634d <sys_sleep+0x24>
    return -1;
80106346:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010634b:	eb 6c                	jmp    801063b9 <sys_sleep+0x90>
  acquire(&tickslock);
8010634d:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80106354:	e8 aa ea ff ff       	call   80104e03 <acquire>
  ticks0 = ticks;
80106359:	a1 e0 50 11 80       	mov    0x801150e0,%eax
8010635e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106361:	eb 34                	jmp    80106397 <sys_sleep+0x6e>
    if(proc->killed){
80106363:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106369:	8b 40 24             	mov    0x24(%eax),%eax
8010636c:	85 c0                	test   %eax,%eax
8010636e:	74 13                	je     80106383 <sys_sleep+0x5a>
      release(&tickslock);
80106370:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80106377:	e8 e9 ea ff ff       	call   80104e65 <release>
      return -1;
8010637c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106381:	eb 36                	jmp    801063b9 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106383:	c7 44 24 04 a0 48 11 	movl   $0x801148a0,0x4(%esp)
8010638a:	80 
8010638b:	c7 04 24 e0 50 11 80 	movl   $0x801150e0,(%esp)
80106392:	e8 9f e7 ff ff       	call   80104b36 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106397:	a1 e0 50 11 80       	mov    0x801150e0,%eax
8010639c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010639f:	89 c2                	mov    %eax,%edx
801063a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a4:	39 c2                	cmp    %eax,%edx
801063a6:	72 bb                	jb     80106363 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801063a8:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
801063af:	e8 b1 ea ff ff       	call   80104e65 <release>
  return 0;
801063b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063b9:	c9                   	leave  
801063ba:	c3                   	ret    

801063bb <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801063bb:	55                   	push   %ebp
801063bc:	89 e5                	mov    %esp,%ebp
801063be:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
801063c1:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
801063c8:	e8 36 ea ff ff       	call   80104e03 <acquire>
  xticks = ticks;
801063cd:	a1 e0 50 11 80       	mov    0x801150e0,%eax
801063d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801063d5:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
801063dc:	e8 84 ea ff ff       	call   80104e65 <release>
  return xticks;
801063e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801063e4:	c9                   	leave  
801063e5:	c3                   	ret    
801063e6:	66 90                	xchg   %ax,%ax

801063e8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801063e8:	55                   	push   %ebp
801063e9:	89 e5                	mov    %esp,%ebp
801063eb:	83 ec 08             	sub    $0x8,%esp
801063ee:	8b 55 08             	mov    0x8(%ebp),%edx
801063f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801063f4:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801063f8:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063fb:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801063ff:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106403:	ee                   	out    %al,(%dx)
}
80106404:	c9                   	leave  
80106405:	c3                   	ret    

80106406 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106406:	55                   	push   %ebp
80106407:	89 e5                	mov    %esp,%ebp
80106409:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
8010640c:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106413:	00 
80106414:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
8010641b:	e8 c8 ff ff ff       	call   801063e8 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106420:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106427:	00 
80106428:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010642f:	e8 b4 ff ff ff       	call   801063e8 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106434:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
8010643b:	00 
8010643c:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106443:	e8 a0 ff ff ff       	call   801063e8 <outb>
  picenable(IRQ_TIMER);
80106448:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010644f:	e8 71 d9 ff ff       	call   80103dc5 <picenable>
}
80106454:	c9                   	leave  
80106455:	c3                   	ret    
80106456:	66 90                	xchg   %ax,%ax

80106458 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106458:	1e                   	push   %ds
  pushl %es
80106459:	06                   	push   %es
  pushl %fs
8010645a:	0f a0                	push   %fs
  pushl %gs
8010645c:	0f a8                	push   %gs
  pushal
8010645e:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
8010645f:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106463:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106465:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106467:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010646b:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
8010646d:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
8010646f:	54                   	push   %esp
  call trap
80106470:	e8 d9 01 00 00       	call   8010664e <trap>
  addl $4, %esp
80106475:	83 c4 04             	add    $0x4,%esp

80106478 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106478:	61                   	popa   
  popl %gs
80106479:	0f a9                	pop    %gs
  popl %fs
8010647b:	0f a1                	pop    %fs
  popl %es
8010647d:	07                   	pop    %es
  popl %ds
8010647e:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010647f:	83 c4 08             	add    $0x8,%esp
  iret
80106482:	cf                   	iret   
80106483:	90                   	nop

80106484 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106484:	55                   	push   %ebp
80106485:	89 e5                	mov    %esp,%ebp
80106487:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010648a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010648d:	83 e8 01             	sub    $0x1,%eax
80106490:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106494:	8b 45 08             	mov    0x8(%ebp),%eax
80106497:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010649b:	8b 45 08             	mov    0x8(%ebp),%eax
8010649e:	c1 e8 10             	shr    $0x10,%eax
801064a1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801064a5:	8d 45 fa             	lea    -0x6(%ebp),%eax
801064a8:	0f 01 18             	lidtl  (%eax)
}
801064ab:	c9                   	leave  
801064ac:	c3                   	ret    

801064ad <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801064ad:	55                   	push   %ebp
801064ae:	89 e5                	mov    %esp,%ebp
801064b0:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801064b3:	0f 20 d0             	mov    %cr2,%eax
801064b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801064b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801064bc:	c9                   	leave  
801064bd:	c3                   	ret    

801064be <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801064be:	55                   	push   %ebp
801064bf:	89 e5                	mov    %esp,%ebp
801064c1:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801064c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801064cb:	e9 c3 00 00 00       	jmp    80106593 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801064d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d3:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
801064da:	89 c2                	mov    %eax,%edx
801064dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064df:	66 89 14 c5 e0 48 11 	mov    %dx,-0x7feeb720(,%eax,8)
801064e6:	80 
801064e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064ea:	66 c7 04 c5 e2 48 11 	movw   $0x8,-0x7feeb71e(,%eax,8)
801064f1:	80 08 00 
801064f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064f7:	0f b6 14 c5 e4 48 11 	movzbl -0x7feeb71c(,%eax,8),%edx
801064fe:	80 
801064ff:	83 e2 e0             	and    $0xffffffe0,%edx
80106502:	88 14 c5 e4 48 11 80 	mov    %dl,-0x7feeb71c(,%eax,8)
80106509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010650c:	0f b6 14 c5 e4 48 11 	movzbl -0x7feeb71c(,%eax,8),%edx
80106513:	80 
80106514:	83 e2 1f             	and    $0x1f,%edx
80106517:	88 14 c5 e4 48 11 80 	mov    %dl,-0x7feeb71c(,%eax,8)
8010651e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106521:	0f b6 14 c5 e5 48 11 	movzbl -0x7feeb71b(,%eax,8),%edx
80106528:	80 
80106529:	83 e2 f0             	and    $0xfffffff0,%edx
8010652c:	83 ca 0e             	or     $0xe,%edx
8010652f:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
80106536:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106539:	0f b6 14 c5 e5 48 11 	movzbl -0x7feeb71b(,%eax,8),%edx
80106540:	80 
80106541:	83 e2 ef             	and    $0xffffffef,%edx
80106544:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
8010654b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010654e:	0f b6 14 c5 e5 48 11 	movzbl -0x7feeb71b(,%eax,8),%edx
80106555:	80 
80106556:	83 e2 9f             	and    $0xffffff9f,%edx
80106559:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
80106560:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106563:	0f b6 14 c5 e5 48 11 	movzbl -0x7feeb71b(,%eax,8),%edx
8010656a:	80 
8010656b:	83 ca 80             	or     $0xffffff80,%edx
8010656e:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
80106575:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106578:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
8010657f:	c1 e8 10             	shr    $0x10,%eax
80106582:	89 c2                	mov    %eax,%edx
80106584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106587:	66 89 14 c5 e6 48 11 	mov    %dx,-0x7feeb71a(,%eax,8)
8010658e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010658f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106593:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010659a:	0f 8e 30 ff ff ff    	jle    801064d0 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065a0:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801065a5:	66 a3 e0 4a 11 80    	mov    %ax,0x80114ae0
801065ab:	66 c7 05 e2 4a 11 80 	movw   $0x8,0x80114ae2
801065b2:	08 00 
801065b4:	0f b6 05 e4 4a 11 80 	movzbl 0x80114ae4,%eax
801065bb:	83 e0 e0             	and    $0xffffffe0,%eax
801065be:	a2 e4 4a 11 80       	mov    %al,0x80114ae4
801065c3:	0f b6 05 e4 4a 11 80 	movzbl 0x80114ae4,%eax
801065ca:	83 e0 1f             	and    $0x1f,%eax
801065cd:	a2 e4 4a 11 80       	mov    %al,0x80114ae4
801065d2:	0f b6 05 e5 4a 11 80 	movzbl 0x80114ae5,%eax
801065d9:	83 c8 0f             	or     $0xf,%eax
801065dc:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
801065e1:	0f b6 05 e5 4a 11 80 	movzbl 0x80114ae5,%eax
801065e8:	83 e0 ef             	and    $0xffffffef,%eax
801065eb:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
801065f0:	0f b6 05 e5 4a 11 80 	movzbl 0x80114ae5,%eax
801065f7:	83 c8 60             	or     $0x60,%eax
801065fa:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
801065ff:	0f b6 05 e5 4a 11 80 	movzbl 0x80114ae5,%eax
80106606:	83 c8 80             	or     $0xffffff80,%eax
80106609:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
8010660e:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106613:	c1 e8 10             	shr    $0x10,%eax
80106616:	66 a3 e6 4a 11 80    	mov    %ax,0x80114ae6
  
  initlock(&tickslock, "time");
8010661c:	c7 44 24 04 40 88 10 	movl   $0x80108840,0x4(%esp)
80106623:	80 
80106624:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
8010662b:	e8 b2 e7 ff ff       	call   80104de2 <initlock>
}
80106630:	c9                   	leave  
80106631:	c3                   	ret    

80106632 <idtinit>:

void
idtinit(void)
{
80106632:	55                   	push   %ebp
80106633:	89 e5                	mov    %esp,%ebp
80106635:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106638:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
8010663f:	00 
80106640:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
80106647:	e8 38 fe ff ff       	call   80106484 <lidt>
}
8010664c:	c9                   	leave  
8010664d:	c3                   	ret    

8010664e <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010664e:	55                   	push   %ebp
8010664f:	89 e5                	mov    %esp,%ebp
80106651:	57                   	push   %edi
80106652:	56                   	push   %esi
80106653:	53                   	push   %ebx
80106654:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106657:	8b 45 08             	mov    0x8(%ebp),%eax
8010665a:	8b 40 30             	mov    0x30(%eax),%eax
8010665d:	83 f8 40             	cmp    $0x40,%eax
80106660:	75 3f                	jne    801066a1 <trap+0x53>
    if(proc->killed)
80106662:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106668:	8b 40 24             	mov    0x24(%eax),%eax
8010666b:	85 c0                	test   %eax,%eax
8010666d:	74 05                	je     80106674 <trap+0x26>
      exit();
8010666f:	e8 e9 e0 ff ff       	call   8010475d <exit>
    proc->tf = tf;
80106674:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010667a:	8b 55 08             	mov    0x8(%ebp),%edx
8010667d:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106680:	e8 e2 ed ff ff       	call   80105467 <syscall>
    if(proc->killed)
80106685:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010668b:	8b 40 24             	mov    0x24(%eax),%eax
8010668e:	85 c0                	test   %eax,%eax
80106690:	74 0a                	je     8010669c <trap+0x4e>
      exit();
80106692:	e8 c6 e0 ff ff       	call   8010475d <exit>
    return;
80106697:	e9 2d 02 00 00       	jmp    801068c9 <trap+0x27b>
8010669c:	e9 28 02 00 00       	jmp    801068c9 <trap+0x27b>
  }

  switch(tf->trapno){
801066a1:	8b 45 08             	mov    0x8(%ebp),%eax
801066a4:	8b 40 30             	mov    0x30(%eax),%eax
801066a7:	83 e8 20             	sub    $0x20,%eax
801066aa:	83 f8 1f             	cmp    $0x1f,%eax
801066ad:	0f 87 bc 00 00 00    	ja     8010676f <trap+0x121>
801066b3:	8b 04 85 e8 88 10 80 	mov    -0x7fef7718(,%eax,4),%eax
801066ba:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801066bc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801066c2:	0f b6 00             	movzbl (%eax),%eax
801066c5:	84 c0                	test   %al,%al
801066c7:	75 31                	jne    801066fa <trap+0xac>
      acquire(&tickslock);
801066c9:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
801066d0:	e8 2e e7 ff ff       	call   80104e03 <acquire>
      ticks++;
801066d5:	a1 e0 50 11 80       	mov    0x801150e0,%eax
801066da:	83 c0 01             	add    $0x1,%eax
801066dd:	a3 e0 50 11 80       	mov    %eax,0x801150e0
      wakeup(&ticks);
801066e2:	c7 04 24 e0 50 11 80 	movl   $0x801150e0,(%esp)
801066e9:	e8 21 e5 ff ff       	call   80104c0f <wakeup>
      release(&tickslock);
801066ee:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
801066f5:	e8 6b e7 ff ff       	call   80104e65 <release>
    }
    lapiceoi();
801066fa:	e8 da c7 ff ff       	call   80102ed9 <lapiceoi>
    break;
801066ff:	e9 41 01 00 00       	jmp    80106845 <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106704:	e8 db bf ff ff       	call   801026e4 <ideintr>
    lapiceoi();
80106709:	e8 cb c7 ff ff       	call   80102ed9 <lapiceoi>
    break;
8010670e:	e9 32 01 00 00       	jmp    80106845 <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106713:	e8 90 c5 ff ff       	call   80102ca8 <kbdintr>
    lapiceoi();
80106718:	e8 bc c7 ff ff       	call   80102ed9 <lapiceoi>
    break;
8010671d:	e9 23 01 00 00       	jmp    80106845 <trap+0x1f7>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106722:	e8 9a 03 00 00       	call   80106ac1 <uartintr>
    lapiceoi();
80106727:	e8 ad c7 ff ff       	call   80102ed9 <lapiceoi>
    break;
8010672c:	e9 14 01 00 00       	jmp    80106845 <trap+0x1f7>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106731:	8b 45 08             	mov    0x8(%ebp),%eax
80106734:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106737:	8b 45 08             	mov    0x8(%ebp),%eax
8010673a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010673e:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106741:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106747:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010674a:	0f b6 c0             	movzbl %al,%eax
8010674d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106751:	89 54 24 08          	mov    %edx,0x8(%esp)
80106755:	89 44 24 04          	mov    %eax,0x4(%esp)
80106759:	c7 04 24 48 88 10 80 	movl   $0x80108848,(%esp)
80106760:	e8 3b 9c ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106765:	e8 6f c7 ff ff       	call   80102ed9 <lapiceoi>
    break;
8010676a:	e9 d6 00 00 00       	jmp    80106845 <trap+0x1f7>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010676f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106775:	85 c0                	test   %eax,%eax
80106777:	74 11                	je     8010678a <trap+0x13c>
80106779:	8b 45 08             	mov    0x8(%ebp),%eax
8010677c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106780:	0f b7 c0             	movzwl %ax,%eax
80106783:	83 e0 03             	and    $0x3,%eax
80106786:	85 c0                	test   %eax,%eax
80106788:	75 46                	jne    801067d0 <trap+0x182>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010678a:	e8 1e fd ff ff       	call   801064ad <rcr2>
8010678f:	8b 55 08             	mov    0x8(%ebp),%edx
80106792:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106795:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010679c:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010679f:	0f b6 ca             	movzbl %dl,%ecx
801067a2:	8b 55 08             	mov    0x8(%ebp),%edx
801067a5:	8b 52 30             	mov    0x30(%edx),%edx
801067a8:	89 44 24 10          	mov    %eax,0x10(%esp)
801067ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801067b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801067b4:	89 54 24 04          	mov    %edx,0x4(%esp)
801067b8:	c7 04 24 6c 88 10 80 	movl   $0x8010886c,(%esp)
801067bf:	e8 dc 9b ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801067c4:	c7 04 24 9e 88 10 80 	movl   $0x8010889e,(%esp)
801067cb:	e8 6a 9d ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801067d0:	e8 d8 fc ff ff       	call   801064ad <rcr2>
801067d5:	89 c2                	mov    %eax,%edx
801067d7:	8b 45 08             	mov    0x8(%ebp),%eax
801067da:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801067dd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801067e3:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801067e6:	0f b6 f0             	movzbl %al,%esi
801067e9:	8b 45 08             	mov    0x8(%ebp),%eax
801067ec:	8b 58 34             	mov    0x34(%eax),%ebx
801067ef:	8b 45 08             	mov    0x8(%ebp),%eax
801067f2:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801067f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067fb:	83 c0 6c             	add    $0x6c,%eax
801067fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106801:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106807:	8b 40 10             	mov    0x10(%eax),%eax
8010680a:	89 54 24 1c          	mov    %edx,0x1c(%esp)
8010680e:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106812:	89 74 24 14          	mov    %esi,0x14(%esp)
80106816:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010681a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010681e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80106821:	89 74 24 08          	mov    %esi,0x8(%esp)
80106825:	89 44 24 04          	mov    %eax,0x4(%esp)
80106829:	c7 04 24 a4 88 10 80 	movl   $0x801088a4,(%esp)
80106830:	e8 6b 9b ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106835:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010683b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106842:	eb 01                	jmp    80106845 <trap+0x1f7>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106844:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106845:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010684b:	85 c0                	test   %eax,%eax
8010684d:	74 24                	je     80106873 <trap+0x225>
8010684f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106855:	8b 40 24             	mov    0x24(%eax),%eax
80106858:	85 c0                	test   %eax,%eax
8010685a:	74 17                	je     80106873 <trap+0x225>
8010685c:	8b 45 08             	mov    0x8(%ebp),%eax
8010685f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106863:	0f b7 c0             	movzwl %ax,%eax
80106866:	83 e0 03             	and    $0x3,%eax
80106869:	83 f8 03             	cmp    $0x3,%eax
8010686c:	75 05                	jne    80106873 <trap+0x225>
    exit();
8010686e:	e8 ea de ff ff       	call   8010475d <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106873:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106879:	85 c0                	test   %eax,%eax
8010687b:	74 1e                	je     8010689b <trap+0x24d>
8010687d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106883:	8b 40 0c             	mov    0xc(%eax),%eax
80106886:	83 f8 04             	cmp    $0x4,%eax
80106889:	75 10                	jne    8010689b <trap+0x24d>
8010688b:	8b 45 08             	mov    0x8(%ebp),%eax
8010688e:	8b 40 30             	mov    0x30(%eax),%eax
80106891:	83 f8 20             	cmp    $0x20,%eax
80106894:	75 05                	jne    8010689b <trap+0x24d>
    yield();
80106896:	e8 3d e2 ff ff       	call   80104ad8 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010689b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068a1:	85 c0                	test   %eax,%eax
801068a3:	74 24                	je     801068c9 <trap+0x27b>
801068a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068ab:	8b 40 24             	mov    0x24(%eax),%eax
801068ae:	85 c0                	test   %eax,%eax
801068b0:	74 17                	je     801068c9 <trap+0x27b>
801068b2:	8b 45 08             	mov    0x8(%ebp),%eax
801068b5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801068b9:	0f b7 c0             	movzwl %ax,%eax
801068bc:	83 e0 03             	and    $0x3,%eax
801068bf:	83 f8 03             	cmp    $0x3,%eax
801068c2:	75 05                	jne    801068c9 <trap+0x27b>
    exit();
801068c4:	e8 94 de ff ff       	call   8010475d <exit>
}
801068c9:	83 c4 3c             	add    $0x3c,%esp
801068cc:	5b                   	pop    %ebx
801068cd:	5e                   	pop    %esi
801068ce:	5f                   	pop    %edi
801068cf:	5d                   	pop    %ebp
801068d0:	c3                   	ret    
801068d1:	66 90                	xchg   %ax,%ax
801068d3:	90                   	nop

801068d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801068d4:	55                   	push   %ebp
801068d5:	89 e5                	mov    %esp,%ebp
801068d7:	83 ec 14             	sub    $0x14,%esp
801068da:	8b 45 08             	mov    0x8(%ebp),%eax
801068dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801068e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801068e5:	89 c2                	mov    %eax,%edx
801068e7:	ec                   	in     (%dx),%al
801068e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801068eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801068ef:	c9                   	leave  
801068f0:	c3                   	ret    

801068f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801068f1:	55                   	push   %ebp
801068f2:	89 e5                	mov    %esp,%ebp
801068f4:	83 ec 08             	sub    $0x8,%esp
801068f7:	8b 55 08             	mov    0x8(%ebp),%edx
801068fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801068fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106901:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106904:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106908:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010690c:	ee                   	out    %al,(%dx)
}
8010690d:	c9                   	leave  
8010690e:	c3                   	ret    

8010690f <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
8010690f:	55                   	push   %ebp
80106910:	89 e5                	mov    %esp,%ebp
80106912:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106915:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010691c:	00 
8010691d:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106924:	e8 c8 ff ff ff       	call   801068f1 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106929:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106930:	00 
80106931:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106938:	e8 b4 ff ff ff       	call   801068f1 <outb>
  outb(COM1+0, 115200/9600);
8010693d:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106944:	00 
80106945:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010694c:	e8 a0 ff ff ff       	call   801068f1 <outb>
  outb(COM1+1, 0);
80106951:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106958:	00 
80106959:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106960:	e8 8c ff ff ff       	call   801068f1 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106965:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010696c:	00 
8010696d:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106974:	e8 78 ff ff ff       	call   801068f1 <outb>
  outb(COM1+4, 0);
80106979:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106980:	00 
80106981:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106988:	e8 64 ff ff ff       	call   801068f1 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010698d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106994:	00 
80106995:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010699c:	e8 50 ff ff ff       	call   801068f1 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801069a1:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801069a8:	e8 27 ff ff ff       	call   801068d4 <inb>
801069ad:	3c ff                	cmp    $0xff,%al
801069af:	75 02                	jne    801069b3 <uartinit+0xa4>
    return;
801069b1:	eb 6a                	jmp    80106a1d <uartinit+0x10e>
  uart = 1;
801069b3:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
801069ba:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801069bd:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801069c4:	e8 0b ff ff ff       	call   801068d4 <inb>
  inb(COM1+0);
801069c9:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801069d0:	e8 ff fe ff ff       	call   801068d4 <inb>
  picenable(IRQ_COM1);
801069d5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801069dc:	e8 e4 d3 ff ff       	call   80103dc5 <picenable>
  ioapicenable(IRQ_COM1, 0);
801069e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069e8:	00 
801069e9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801069f0:	e8 6f bf ff ff       	call   80102964 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801069f5:	c7 45 f4 68 89 10 80 	movl   $0x80108968,-0xc(%ebp)
801069fc:	eb 15                	jmp    80106a13 <uartinit+0x104>
    uartputc(*p);
801069fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a01:	0f b6 00             	movzbl (%eax),%eax
80106a04:	0f be c0             	movsbl %al,%eax
80106a07:	89 04 24             	mov    %eax,(%esp)
80106a0a:	e8 10 00 00 00       	call   80106a1f <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106a0f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a16:	0f b6 00             	movzbl (%eax),%eax
80106a19:	84 c0                	test   %al,%al
80106a1b:	75 e1                	jne    801069fe <uartinit+0xef>
    uartputc(*p);
}
80106a1d:	c9                   	leave  
80106a1e:	c3                   	ret    

80106a1f <uartputc>:

void
uartputc(int c)
{
80106a1f:	55                   	push   %ebp
80106a20:	89 e5                	mov    %esp,%ebp
80106a22:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106a25:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106a2a:	85 c0                	test   %eax,%eax
80106a2c:	75 02                	jne    80106a30 <uartputc+0x11>
    return;
80106a2e:	eb 4b                	jmp    80106a7b <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106a30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106a37:	eb 10                	jmp    80106a49 <uartputc+0x2a>
    microdelay(10);
80106a39:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106a40:	e8 b9 c4 ff ff       	call   80102efe <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106a45:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106a49:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106a4d:	7f 16                	jg     80106a65 <uartputc+0x46>
80106a4f:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106a56:	e8 79 fe ff ff       	call   801068d4 <inb>
80106a5b:	0f b6 c0             	movzbl %al,%eax
80106a5e:	83 e0 20             	and    $0x20,%eax
80106a61:	85 c0                	test   %eax,%eax
80106a63:	74 d4                	je     80106a39 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106a65:	8b 45 08             	mov    0x8(%ebp),%eax
80106a68:	0f b6 c0             	movzbl %al,%eax
80106a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a6f:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106a76:	e8 76 fe ff ff       	call   801068f1 <outb>
}
80106a7b:	c9                   	leave  
80106a7c:	c3                   	ret    

80106a7d <uartgetc>:

static int
uartgetc(void)
{
80106a7d:	55                   	push   %ebp
80106a7e:	89 e5                	mov    %esp,%ebp
80106a80:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106a83:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106a88:	85 c0                	test   %eax,%eax
80106a8a:	75 07                	jne    80106a93 <uartgetc+0x16>
    return -1;
80106a8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a91:	eb 2c                	jmp    80106abf <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106a93:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106a9a:	e8 35 fe ff ff       	call   801068d4 <inb>
80106a9f:	0f b6 c0             	movzbl %al,%eax
80106aa2:	83 e0 01             	and    $0x1,%eax
80106aa5:	85 c0                	test   %eax,%eax
80106aa7:	75 07                	jne    80106ab0 <uartgetc+0x33>
    return -1;
80106aa9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aae:	eb 0f                	jmp    80106abf <uartgetc+0x42>
  return inb(COM1+0);
80106ab0:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106ab7:	e8 18 fe ff ff       	call   801068d4 <inb>
80106abc:	0f b6 c0             	movzbl %al,%eax
}
80106abf:	c9                   	leave  
80106ac0:	c3                   	ret    

80106ac1 <uartintr>:

void
uartintr(void)
{
80106ac1:	55                   	push   %ebp
80106ac2:	89 e5                	mov    %esp,%ebp
80106ac4:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106ac7:	c7 04 24 7d 6a 10 80 	movl   $0x80106a7d,(%esp)
80106ace:	e8 da 9c ff ff       	call   801007ad <consoleintr>
}
80106ad3:	c9                   	leave  
80106ad4:	c3                   	ret    
80106ad5:	66 90                	xchg   %ax,%ax
80106ad7:	90                   	nop

80106ad8 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106ad8:	6a 00                	push   $0x0
  pushl $0
80106ada:	6a 00                	push   $0x0
  jmp alltraps
80106adc:	e9 77 f9 ff ff       	jmp    80106458 <alltraps>

80106ae1 <vector1>:
.globl vector1
vector1:
  pushl $0
80106ae1:	6a 00                	push   $0x0
  pushl $1
80106ae3:	6a 01                	push   $0x1
  jmp alltraps
80106ae5:	e9 6e f9 ff ff       	jmp    80106458 <alltraps>

80106aea <vector2>:
.globl vector2
vector2:
  pushl $0
80106aea:	6a 00                	push   $0x0
  pushl $2
80106aec:	6a 02                	push   $0x2
  jmp alltraps
80106aee:	e9 65 f9 ff ff       	jmp    80106458 <alltraps>

80106af3 <vector3>:
.globl vector3
vector3:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $3
80106af5:	6a 03                	push   $0x3
  jmp alltraps
80106af7:	e9 5c f9 ff ff       	jmp    80106458 <alltraps>

80106afc <vector4>:
.globl vector4
vector4:
  pushl $0
80106afc:	6a 00                	push   $0x0
  pushl $4
80106afe:	6a 04                	push   $0x4
  jmp alltraps
80106b00:	e9 53 f9 ff ff       	jmp    80106458 <alltraps>

80106b05 <vector5>:
.globl vector5
vector5:
  pushl $0
80106b05:	6a 00                	push   $0x0
  pushl $5
80106b07:	6a 05                	push   $0x5
  jmp alltraps
80106b09:	e9 4a f9 ff ff       	jmp    80106458 <alltraps>

80106b0e <vector6>:
.globl vector6
vector6:
  pushl $0
80106b0e:	6a 00                	push   $0x0
  pushl $6
80106b10:	6a 06                	push   $0x6
  jmp alltraps
80106b12:	e9 41 f9 ff ff       	jmp    80106458 <alltraps>

80106b17 <vector7>:
.globl vector7
vector7:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $7
80106b19:	6a 07                	push   $0x7
  jmp alltraps
80106b1b:	e9 38 f9 ff ff       	jmp    80106458 <alltraps>

80106b20 <vector8>:
.globl vector8
vector8:
  pushl $8
80106b20:	6a 08                	push   $0x8
  jmp alltraps
80106b22:	e9 31 f9 ff ff       	jmp    80106458 <alltraps>

80106b27 <vector9>:
.globl vector9
vector9:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $9
80106b29:	6a 09                	push   $0x9
  jmp alltraps
80106b2b:	e9 28 f9 ff ff       	jmp    80106458 <alltraps>

80106b30 <vector10>:
.globl vector10
vector10:
  pushl $10
80106b30:	6a 0a                	push   $0xa
  jmp alltraps
80106b32:	e9 21 f9 ff ff       	jmp    80106458 <alltraps>

80106b37 <vector11>:
.globl vector11
vector11:
  pushl $11
80106b37:	6a 0b                	push   $0xb
  jmp alltraps
80106b39:	e9 1a f9 ff ff       	jmp    80106458 <alltraps>

80106b3e <vector12>:
.globl vector12
vector12:
  pushl $12
80106b3e:	6a 0c                	push   $0xc
  jmp alltraps
80106b40:	e9 13 f9 ff ff       	jmp    80106458 <alltraps>

80106b45 <vector13>:
.globl vector13
vector13:
  pushl $13
80106b45:	6a 0d                	push   $0xd
  jmp alltraps
80106b47:	e9 0c f9 ff ff       	jmp    80106458 <alltraps>

80106b4c <vector14>:
.globl vector14
vector14:
  pushl $14
80106b4c:	6a 0e                	push   $0xe
  jmp alltraps
80106b4e:	e9 05 f9 ff ff       	jmp    80106458 <alltraps>

80106b53 <vector15>:
.globl vector15
vector15:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $15
80106b55:	6a 0f                	push   $0xf
  jmp alltraps
80106b57:	e9 fc f8 ff ff       	jmp    80106458 <alltraps>

80106b5c <vector16>:
.globl vector16
vector16:
  pushl $0
80106b5c:	6a 00                	push   $0x0
  pushl $16
80106b5e:	6a 10                	push   $0x10
  jmp alltraps
80106b60:	e9 f3 f8 ff ff       	jmp    80106458 <alltraps>

80106b65 <vector17>:
.globl vector17
vector17:
  pushl $17
80106b65:	6a 11                	push   $0x11
  jmp alltraps
80106b67:	e9 ec f8 ff ff       	jmp    80106458 <alltraps>

80106b6c <vector18>:
.globl vector18
vector18:
  pushl $0
80106b6c:	6a 00                	push   $0x0
  pushl $18
80106b6e:	6a 12                	push   $0x12
  jmp alltraps
80106b70:	e9 e3 f8 ff ff       	jmp    80106458 <alltraps>

80106b75 <vector19>:
.globl vector19
vector19:
  pushl $0
80106b75:	6a 00                	push   $0x0
  pushl $19
80106b77:	6a 13                	push   $0x13
  jmp alltraps
80106b79:	e9 da f8 ff ff       	jmp    80106458 <alltraps>

80106b7e <vector20>:
.globl vector20
vector20:
  pushl $0
80106b7e:	6a 00                	push   $0x0
  pushl $20
80106b80:	6a 14                	push   $0x14
  jmp alltraps
80106b82:	e9 d1 f8 ff ff       	jmp    80106458 <alltraps>

80106b87 <vector21>:
.globl vector21
vector21:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $21
80106b89:	6a 15                	push   $0x15
  jmp alltraps
80106b8b:	e9 c8 f8 ff ff       	jmp    80106458 <alltraps>

80106b90 <vector22>:
.globl vector22
vector22:
  pushl $0
80106b90:	6a 00                	push   $0x0
  pushl $22
80106b92:	6a 16                	push   $0x16
  jmp alltraps
80106b94:	e9 bf f8 ff ff       	jmp    80106458 <alltraps>

80106b99 <vector23>:
.globl vector23
vector23:
  pushl $0
80106b99:	6a 00                	push   $0x0
  pushl $23
80106b9b:	6a 17                	push   $0x17
  jmp alltraps
80106b9d:	e9 b6 f8 ff ff       	jmp    80106458 <alltraps>

80106ba2 <vector24>:
.globl vector24
vector24:
  pushl $0
80106ba2:	6a 00                	push   $0x0
  pushl $24
80106ba4:	6a 18                	push   $0x18
  jmp alltraps
80106ba6:	e9 ad f8 ff ff       	jmp    80106458 <alltraps>

80106bab <vector25>:
.globl vector25
vector25:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $25
80106bad:	6a 19                	push   $0x19
  jmp alltraps
80106baf:	e9 a4 f8 ff ff       	jmp    80106458 <alltraps>

80106bb4 <vector26>:
.globl vector26
vector26:
  pushl $0
80106bb4:	6a 00                	push   $0x0
  pushl $26
80106bb6:	6a 1a                	push   $0x1a
  jmp alltraps
80106bb8:	e9 9b f8 ff ff       	jmp    80106458 <alltraps>

80106bbd <vector27>:
.globl vector27
vector27:
  pushl $0
80106bbd:	6a 00                	push   $0x0
  pushl $27
80106bbf:	6a 1b                	push   $0x1b
  jmp alltraps
80106bc1:	e9 92 f8 ff ff       	jmp    80106458 <alltraps>

80106bc6 <vector28>:
.globl vector28
vector28:
  pushl $0
80106bc6:	6a 00                	push   $0x0
  pushl $28
80106bc8:	6a 1c                	push   $0x1c
  jmp alltraps
80106bca:	e9 89 f8 ff ff       	jmp    80106458 <alltraps>

80106bcf <vector29>:
.globl vector29
vector29:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $29
80106bd1:	6a 1d                	push   $0x1d
  jmp alltraps
80106bd3:	e9 80 f8 ff ff       	jmp    80106458 <alltraps>

80106bd8 <vector30>:
.globl vector30
vector30:
  pushl $0
80106bd8:	6a 00                	push   $0x0
  pushl $30
80106bda:	6a 1e                	push   $0x1e
  jmp alltraps
80106bdc:	e9 77 f8 ff ff       	jmp    80106458 <alltraps>

80106be1 <vector31>:
.globl vector31
vector31:
  pushl $0
80106be1:	6a 00                	push   $0x0
  pushl $31
80106be3:	6a 1f                	push   $0x1f
  jmp alltraps
80106be5:	e9 6e f8 ff ff       	jmp    80106458 <alltraps>

80106bea <vector32>:
.globl vector32
vector32:
  pushl $0
80106bea:	6a 00                	push   $0x0
  pushl $32
80106bec:	6a 20                	push   $0x20
  jmp alltraps
80106bee:	e9 65 f8 ff ff       	jmp    80106458 <alltraps>

80106bf3 <vector33>:
.globl vector33
vector33:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $33
80106bf5:	6a 21                	push   $0x21
  jmp alltraps
80106bf7:	e9 5c f8 ff ff       	jmp    80106458 <alltraps>

80106bfc <vector34>:
.globl vector34
vector34:
  pushl $0
80106bfc:	6a 00                	push   $0x0
  pushl $34
80106bfe:	6a 22                	push   $0x22
  jmp alltraps
80106c00:	e9 53 f8 ff ff       	jmp    80106458 <alltraps>

80106c05 <vector35>:
.globl vector35
vector35:
  pushl $0
80106c05:	6a 00                	push   $0x0
  pushl $35
80106c07:	6a 23                	push   $0x23
  jmp alltraps
80106c09:	e9 4a f8 ff ff       	jmp    80106458 <alltraps>

80106c0e <vector36>:
.globl vector36
vector36:
  pushl $0
80106c0e:	6a 00                	push   $0x0
  pushl $36
80106c10:	6a 24                	push   $0x24
  jmp alltraps
80106c12:	e9 41 f8 ff ff       	jmp    80106458 <alltraps>

80106c17 <vector37>:
.globl vector37
vector37:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $37
80106c19:	6a 25                	push   $0x25
  jmp alltraps
80106c1b:	e9 38 f8 ff ff       	jmp    80106458 <alltraps>

80106c20 <vector38>:
.globl vector38
vector38:
  pushl $0
80106c20:	6a 00                	push   $0x0
  pushl $38
80106c22:	6a 26                	push   $0x26
  jmp alltraps
80106c24:	e9 2f f8 ff ff       	jmp    80106458 <alltraps>

80106c29 <vector39>:
.globl vector39
vector39:
  pushl $0
80106c29:	6a 00                	push   $0x0
  pushl $39
80106c2b:	6a 27                	push   $0x27
  jmp alltraps
80106c2d:	e9 26 f8 ff ff       	jmp    80106458 <alltraps>

80106c32 <vector40>:
.globl vector40
vector40:
  pushl $0
80106c32:	6a 00                	push   $0x0
  pushl $40
80106c34:	6a 28                	push   $0x28
  jmp alltraps
80106c36:	e9 1d f8 ff ff       	jmp    80106458 <alltraps>

80106c3b <vector41>:
.globl vector41
vector41:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $41
80106c3d:	6a 29                	push   $0x29
  jmp alltraps
80106c3f:	e9 14 f8 ff ff       	jmp    80106458 <alltraps>

80106c44 <vector42>:
.globl vector42
vector42:
  pushl $0
80106c44:	6a 00                	push   $0x0
  pushl $42
80106c46:	6a 2a                	push   $0x2a
  jmp alltraps
80106c48:	e9 0b f8 ff ff       	jmp    80106458 <alltraps>

80106c4d <vector43>:
.globl vector43
vector43:
  pushl $0
80106c4d:	6a 00                	push   $0x0
  pushl $43
80106c4f:	6a 2b                	push   $0x2b
  jmp alltraps
80106c51:	e9 02 f8 ff ff       	jmp    80106458 <alltraps>

80106c56 <vector44>:
.globl vector44
vector44:
  pushl $0
80106c56:	6a 00                	push   $0x0
  pushl $44
80106c58:	6a 2c                	push   $0x2c
  jmp alltraps
80106c5a:	e9 f9 f7 ff ff       	jmp    80106458 <alltraps>

80106c5f <vector45>:
.globl vector45
vector45:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $45
80106c61:	6a 2d                	push   $0x2d
  jmp alltraps
80106c63:	e9 f0 f7 ff ff       	jmp    80106458 <alltraps>

80106c68 <vector46>:
.globl vector46
vector46:
  pushl $0
80106c68:	6a 00                	push   $0x0
  pushl $46
80106c6a:	6a 2e                	push   $0x2e
  jmp alltraps
80106c6c:	e9 e7 f7 ff ff       	jmp    80106458 <alltraps>

80106c71 <vector47>:
.globl vector47
vector47:
  pushl $0
80106c71:	6a 00                	push   $0x0
  pushl $47
80106c73:	6a 2f                	push   $0x2f
  jmp alltraps
80106c75:	e9 de f7 ff ff       	jmp    80106458 <alltraps>

80106c7a <vector48>:
.globl vector48
vector48:
  pushl $0
80106c7a:	6a 00                	push   $0x0
  pushl $48
80106c7c:	6a 30                	push   $0x30
  jmp alltraps
80106c7e:	e9 d5 f7 ff ff       	jmp    80106458 <alltraps>

80106c83 <vector49>:
.globl vector49
vector49:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $49
80106c85:	6a 31                	push   $0x31
  jmp alltraps
80106c87:	e9 cc f7 ff ff       	jmp    80106458 <alltraps>

80106c8c <vector50>:
.globl vector50
vector50:
  pushl $0
80106c8c:	6a 00                	push   $0x0
  pushl $50
80106c8e:	6a 32                	push   $0x32
  jmp alltraps
80106c90:	e9 c3 f7 ff ff       	jmp    80106458 <alltraps>

80106c95 <vector51>:
.globl vector51
vector51:
  pushl $0
80106c95:	6a 00                	push   $0x0
  pushl $51
80106c97:	6a 33                	push   $0x33
  jmp alltraps
80106c99:	e9 ba f7 ff ff       	jmp    80106458 <alltraps>

80106c9e <vector52>:
.globl vector52
vector52:
  pushl $0
80106c9e:	6a 00                	push   $0x0
  pushl $52
80106ca0:	6a 34                	push   $0x34
  jmp alltraps
80106ca2:	e9 b1 f7 ff ff       	jmp    80106458 <alltraps>

80106ca7 <vector53>:
.globl vector53
vector53:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $53
80106ca9:	6a 35                	push   $0x35
  jmp alltraps
80106cab:	e9 a8 f7 ff ff       	jmp    80106458 <alltraps>

80106cb0 <vector54>:
.globl vector54
vector54:
  pushl $0
80106cb0:	6a 00                	push   $0x0
  pushl $54
80106cb2:	6a 36                	push   $0x36
  jmp alltraps
80106cb4:	e9 9f f7 ff ff       	jmp    80106458 <alltraps>

80106cb9 <vector55>:
.globl vector55
vector55:
  pushl $0
80106cb9:	6a 00                	push   $0x0
  pushl $55
80106cbb:	6a 37                	push   $0x37
  jmp alltraps
80106cbd:	e9 96 f7 ff ff       	jmp    80106458 <alltraps>

80106cc2 <vector56>:
.globl vector56
vector56:
  pushl $0
80106cc2:	6a 00                	push   $0x0
  pushl $56
80106cc4:	6a 38                	push   $0x38
  jmp alltraps
80106cc6:	e9 8d f7 ff ff       	jmp    80106458 <alltraps>

80106ccb <vector57>:
.globl vector57
vector57:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $57
80106ccd:	6a 39                	push   $0x39
  jmp alltraps
80106ccf:	e9 84 f7 ff ff       	jmp    80106458 <alltraps>

80106cd4 <vector58>:
.globl vector58
vector58:
  pushl $0
80106cd4:	6a 00                	push   $0x0
  pushl $58
80106cd6:	6a 3a                	push   $0x3a
  jmp alltraps
80106cd8:	e9 7b f7 ff ff       	jmp    80106458 <alltraps>

80106cdd <vector59>:
.globl vector59
vector59:
  pushl $0
80106cdd:	6a 00                	push   $0x0
  pushl $59
80106cdf:	6a 3b                	push   $0x3b
  jmp alltraps
80106ce1:	e9 72 f7 ff ff       	jmp    80106458 <alltraps>

80106ce6 <vector60>:
.globl vector60
vector60:
  pushl $0
80106ce6:	6a 00                	push   $0x0
  pushl $60
80106ce8:	6a 3c                	push   $0x3c
  jmp alltraps
80106cea:	e9 69 f7 ff ff       	jmp    80106458 <alltraps>

80106cef <vector61>:
.globl vector61
vector61:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $61
80106cf1:	6a 3d                	push   $0x3d
  jmp alltraps
80106cf3:	e9 60 f7 ff ff       	jmp    80106458 <alltraps>

80106cf8 <vector62>:
.globl vector62
vector62:
  pushl $0
80106cf8:	6a 00                	push   $0x0
  pushl $62
80106cfa:	6a 3e                	push   $0x3e
  jmp alltraps
80106cfc:	e9 57 f7 ff ff       	jmp    80106458 <alltraps>

80106d01 <vector63>:
.globl vector63
vector63:
  pushl $0
80106d01:	6a 00                	push   $0x0
  pushl $63
80106d03:	6a 3f                	push   $0x3f
  jmp alltraps
80106d05:	e9 4e f7 ff ff       	jmp    80106458 <alltraps>

80106d0a <vector64>:
.globl vector64
vector64:
  pushl $0
80106d0a:	6a 00                	push   $0x0
  pushl $64
80106d0c:	6a 40                	push   $0x40
  jmp alltraps
80106d0e:	e9 45 f7 ff ff       	jmp    80106458 <alltraps>

80106d13 <vector65>:
.globl vector65
vector65:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $65
80106d15:	6a 41                	push   $0x41
  jmp alltraps
80106d17:	e9 3c f7 ff ff       	jmp    80106458 <alltraps>

80106d1c <vector66>:
.globl vector66
vector66:
  pushl $0
80106d1c:	6a 00                	push   $0x0
  pushl $66
80106d1e:	6a 42                	push   $0x42
  jmp alltraps
80106d20:	e9 33 f7 ff ff       	jmp    80106458 <alltraps>

80106d25 <vector67>:
.globl vector67
vector67:
  pushl $0
80106d25:	6a 00                	push   $0x0
  pushl $67
80106d27:	6a 43                	push   $0x43
  jmp alltraps
80106d29:	e9 2a f7 ff ff       	jmp    80106458 <alltraps>

80106d2e <vector68>:
.globl vector68
vector68:
  pushl $0
80106d2e:	6a 00                	push   $0x0
  pushl $68
80106d30:	6a 44                	push   $0x44
  jmp alltraps
80106d32:	e9 21 f7 ff ff       	jmp    80106458 <alltraps>

80106d37 <vector69>:
.globl vector69
vector69:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $69
80106d39:	6a 45                	push   $0x45
  jmp alltraps
80106d3b:	e9 18 f7 ff ff       	jmp    80106458 <alltraps>

80106d40 <vector70>:
.globl vector70
vector70:
  pushl $0
80106d40:	6a 00                	push   $0x0
  pushl $70
80106d42:	6a 46                	push   $0x46
  jmp alltraps
80106d44:	e9 0f f7 ff ff       	jmp    80106458 <alltraps>

80106d49 <vector71>:
.globl vector71
vector71:
  pushl $0
80106d49:	6a 00                	push   $0x0
  pushl $71
80106d4b:	6a 47                	push   $0x47
  jmp alltraps
80106d4d:	e9 06 f7 ff ff       	jmp    80106458 <alltraps>

80106d52 <vector72>:
.globl vector72
vector72:
  pushl $0
80106d52:	6a 00                	push   $0x0
  pushl $72
80106d54:	6a 48                	push   $0x48
  jmp alltraps
80106d56:	e9 fd f6 ff ff       	jmp    80106458 <alltraps>

80106d5b <vector73>:
.globl vector73
vector73:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $73
80106d5d:	6a 49                	push   $0x49
  jmp alltraps
80106d5f:	e9 f4 f6 ff ff       	jmp    80106458 <alltraps>

80106d64 <vector74>:
.globl vector74
vector74:
  pushl $0
80106d64:	6a 00                	push   $0x0
  pushl $74
80106d66:	6a 4a                	push   $0x4a
  jmp alltraps
80106d68:	e9 eb f6 ff ff       	jmp    80106458 <alltraps>

80106d6d <vector75>:
.globl vector75
vector75:
  pushl $0
80106d6d:	6a 00                	push   $0x0
  pushl $75
80106d6f:	6a 4b                	push   $0x4b
  jmp alltraps
80106d71:	e9 e2 f6 ff ff       	jmp    80106458 <alltraps>

80106d76 <vector76>:
.globl vector76
vector76:
  pushl $0
80106d76:	6a 00                	push   $0x0
  pushl $76
80106d78:	6a 4c                	push   $0x4c
  jmp alltraps
80106d7a:	e9 d9 f6 ff ff       	jmp    80106458 <alltraps>

80106d7f <vector77>:
.globl vector77
vector77:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $77
80106d81:	6a 4d                	push   $0x4d
  jmp alltraps
80106d83:	e9 d0 f6 ff ff       	jmp    80106458 <alltraps>

80106d88 <vector78>:
.globl vector78
vector78:
  pushl $0
80106d88:	6a 00                	push   $0x0
  pushl $78
80106d8a:	6a 4e                	push   $0x4e
  jmp alltraps
80106d8c:	e9 c7 f6 ff ff       	jmp    80106458 <alltraps>

80106d91 <vector79>:
.globl vector79
vector79:
  pushl $0
80106d91:	6a 00                	push   $0x0
  pushl $79
80106d93:	6a 4f                	push   $0x4f
  jmp alltraps
80106d95:	e9 be f6 ff ff       	jmp    80106458 <alltraps>

80106d9a <vector80>:
.globl vector80
vector80:
  pushl $0
80106d9a:	6a 00                	push   $0x0
  pushl $80
80106d9c:	6a 50                	push   $0x50
  jmp alltraps
80106d9e:	e9 b5 f6 ff ff       	jmp    80106458 <alltraps>

80106da3 <vector81>:
.globl vector81
vector81:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $81
80106da5:	6a 51                	push   $0x51
  jmp alltraps
80106da7:	e9 ac f6 ff ff       	jmp    80106458 <alltraps>

80106dac <vector82>:
.globl vector82
vector82:
  pushl $0
80106dac:	6a 00                	push   $0x0
  pushl $82
80106dae:	6a 52                	push   $0x52
  jmp alltraps
80106db0:	e9 a3 f6 ff ff       	jmp    80106458 <alltraps>

80106db5 <vector83>:
.globl vector83
vector83:
  pushl $0
80106db5:	6a 00                	push   $0x0
  pushl $83
80106db7:	6a 53                	push   $0x53
  jmp alltraps
80106db9:	e9 9a f6 ff ff       	jmp    80106458 <alltraps>

80106dbe <vector84>:
.globl vector84
vector84:
  pushl $0
80106dbe:	6a 00                	push   $0x0
  pushl $84
80106dc0:	6a 54                	push   $0x54
  jmp alltraps
80106dc2:	e9 91 f6 ff ff       	jmp    80106458 <alltraps>

80106dc7 <vector85>:
.globl vector85
vector85:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $85
80106dc9:	6a 55                	push   $0x55
  jmp alltraps
80106dcb:	e9 88 f6 ff ff       	jmp    80106458 <alltraps>

80106dd0 <vector86>:
.globl vector86
vector86:
  pushl $0
80106dd0:	6a 00                	push   $0x0
  pushl $86
80106dd2:	6a 56                	push   $0x56
  jmp alltraps
80106dd4:	e9 7f f6 ff ff       	jmp    80106458 <alltraps>

80106dd9 <vector87>:
.globl vector87
vector87:
  pushl $0
80106dd9:	6a 00                	push   $0x0
  pushl $87
80106ddb:	6a 57                	push   $0x57
  jmp alltraps
80106ddd:	e9 76 f6 ff ff       	jmp    80106458 <alltraps>

80106de2 <vector88>:
.globl vector88
vector88:
  pushl $0
80106de2:	6a 00                	push   $0x0
  pushl $88
80106de4:	6a 58                	push   $0x58
  jmp alltraps
80106de6:	e9 6d f6 ff ff       	jmp    80106458 <alltraps>

80106deb <vector89>:
.globl vector89
vector89:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $89
80106ded:	6a 59                	push   $0x59
  jmp alltraps
80106def:	e9 64 f6 ff ff       	jmp    80106458 <alltraps>

80106df4 <vector90>:
.globl vector90
vector90:
  pushl $0
80106df4:	6a 00                	push   $0x0
  pushl $90
80106df6:	6a 5a                	push   $0x5a
  jmp alltraps
80106df8:	e9 5b f6 ff ff       	jmp    80106458 <alltraps>

80106dfd <vector91>:
.globl vector91
vector91:
  pushl $0
80106dfd:	6a 00                	push   $0x0
  pushl $91
80106dff:	6a 5b                	push   $0x5b
  jmp alltraps
80106e01:	e9 52 f6 ff ff       	jmp    80106458 <alltraps>

80106e06 <vector92>:
.globl vector92
vector92:
  pushl $0
80106e06:	6a 00                	push   $0x0
  pushl $92
80106e08:	6a 5c                	push   $0x5c
  jmp alltraps
80106e0a:	e9 49 f6 ff ff       	jmp    80106458 <alltraps>

80106e0f <vector93>:
.globl vector93
vector93:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $93
80106e11:	6a 5d                	push   $0x5d
  jmp alltraps
80106e13:	e9 40 f6 ff ff       	jmp    80106458 <alltraps>

80106e18 <vector94>:
.globl vector94
vector94:
  pushl $0
80106e18:	6a 00                	push   $0x0
  pushl $94
80106e1a:	6a 5e                	push   $0x5e
  jmp alltraps
80106e1c:	e9 37 f6 ff ff       	jmp    80106458 <alltraps>

80106e21 <vector95>:
.globl vector95
vector95:
  pushl $0
80106e21:	6a 00                	push   $0x0
  pushl $95
80106e23:	6a 5f                	push   $0x5f
  jmp alltraps
80106e25:	e9 2e f6 ff ff       	jmp    80106458 <alltraps>

80106e2a <vector96>:
.globl vector96
vector96:
  pushl $0
80106e2a:	6a 00                	push   $0x0
  pushl $96
80106e2c:	6a 60                	push   $0x60
  jmp alltraps
80106e2e:	e9 25 f6 ff ff       	jmp    80106458 <alltraps>

80106e33 <vector97>:
.globl vector97
vector97:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $97
80106e35:	6a 61                	push   $0x61
  jmp alltraps
80106e37:	e9 1c f6 ff ff       	jmp    80106458 <alltraps>

80106e3c <vector98>:
.globl vector98
vector98:
  pushl $0
80106e3c:	6a 00                	push   $0x0
  pushl $98
80106e3e:	6a 62                	push   $0x62
  jmp alltraps
80106e40:	e9 13 f6 ff ff       	jmp    80106458 <alltraps>

80106e45 <vector99>:
.globl vector99
vector99:
  pushl $0
80106e45:	6a 00                	push   $0x0
  pushl $99
80106e47:	6a 63                	push   $0x63
  jmp alltraps
80106e49:	e9 0a f6 ff ff       	jmp    80106458 <alltraps>

80106e4e <vector100>:
.globl vector100
vector100:
  pushl $0
80106e4e:	6a 00                	push   $0x0
  pushl $100
80106e50:	6a 64                	push   $0x64
  jmp alltraps
80106e52:	e9 01 f6 ff ff       	jmp    80106458 <alltraps>

80106e57 <vector101>:
.globl vector101
vector101:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $101
80106e59:	6a 65                	push   $0x65
  jmp alltraps
80106e5b:	e9 f8 f5 ff ff       	jmp    80106458 <alltraps>

80106e60 <vector102>:
.globl vector102
vector102:
  pushl $0
80106e60:	6a 00                	push   $0x0
  pushl $102
80106e62:	6a 66                	push   $0x66
  jmp alltraps
80106e64:	e9 ef f5 ff ff       	jmp    80106458 <alltraps>

80106e69 <vector103>:
.globl vector103
vector103:
  pushl $0
80106e69:	6a 00                	push   $0x0
  pushl $103
80106e6b:	6a 67                	push   $0x67
  jmp alltraps
80106e6d:	e9 e6 f5 ff ff       	jmp    80106458 <alltraps>

80106e72 <vector104>:
.globl vector104
vector104:
  pushl $0
80106e72:	6a 00                	push   $0x0
  pushl $104
80106e74:	6a 68                	push   $0x68
  jmp alltraps
80106e76:	e9 dd f5 ff ff       	jmp    80106458 <alltraps>

80106e7b <vector105>:
.globl vector105
vector105:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $105
80106e7d:	6a 69                	push   $0x69
  jmp alltraps
80106e7f:	e9 d4 f5 ff ff       	jmp    80106458 <alltraps>

80106e84 <vector106>:
.globl vector106
vector106:
  pushl $0
80106e84:	6a 00                	push   $0x0
  pushl $106
80106e86:	6a 6a                	push   $0x6a
  jmp alltraps
80106e88:	e9 cb f5 ff ff       	jmp    80106458 <alltraps>

80106e8d <vector107>:
.globl vector107
vector107:
  pushl $0
80106e8d:	6a 00                	push   $0x0
  pushl $107
80106e8f:	6a 6b                	push   $0x6b
  jmp alltraps
80106e91:	e9 c2 f5 ff ff       	jmp    80106458 <alltraps>

80106e96 <vector108>:
.globl vector108
vector108:
  pushl $0
80106e96:	6a 00                	push   $0x0
  pushl $108
80106e98:	6a 6c                	push   $0x6c
  jmp alltraps
80106e9a:	e9 b9 f5 ff ff       	jmp    80106458 <alltraps>

80106e9f <vector109>:
.globl vector109
vector109:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $109
80106ea1:	6a 6d                	push   $0x6d
  jmp alltraps
80106ea3:	e9 b0 f5 ff ff       	jmp    80106458 <alltraps>

80106ea8 <vector110>:
.globl vector110
vector110:
  pushl $0
80106ea8:	6a 00                	push   $0x0
  pushl $110
80106eaa:	6a 6e                	push   $0x6e
  jmp alltraps
80106eac:	e9 a7 f5 ff ff       	jmp    80106458 <alltraps>

80106eb1 <vector111>:
.globl vector111
vector111:
  pushl $0
80106eb1:	6a 00                	push   $0x0
  pushl $111
80106eb3:	6a 6f                	push   $0x6f
  jmp alltraps
80106eb5:	e9 9e f5 ff ff       	jmp    80106458 <alltraps>

80106eba <vector112>:
.globl vector112
vector112:
  pushl $0
80106eba:	6a 00                	push   $0x0
  pushl $112
80106ebc:	6a 70                	push   $0x70
  jmp alltraps
80106ebe:	e9 95 f5 ff ff       	jmp    80106458 <alltraps>

80106ec3 <vector113>:
.globl vector113
vector113:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $113
80106ec5:	6a 71                	push   $0x71
  jmp alltraps
80106ec7:	e9 8c f5 ff ff       	jmp    80106458 <alltraps>

80106ecc <vector114>:
.globl vector114
vector114:
  pushl $0
80106ecc:	6a 00                	push   $0x0
  pushl $114
80106ece:	6a 72                	push   $0x72
  jmp alltraps
80106ed0:	e9 83 f5 ff ff       	jmp    80106458 <alltraps>

80106ed5 <vector115>:
.globl vector115
vector115:
  pushl $0
80106ed5:	6a 00                	push   $0x0
  pushl $115
80106ed7:	6a 73                	push   $0x73
  jmp alltraps
80106ed9:	e9 7a f5 ff ff       	jmp    80106458 <alltraps>

80106ede <vector116>:
.globl vector116
vector116:
  pushl $0
80106ede:	6a 00                	push   $0x0
  pushl $116
80106ee0:	6a 74                	push   $0x74
  jmp alltraps
80106ee2:	e9 71 f5 ff ff       	jmp    80106458 <alltraps>

80106ee7 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $117
80106ee9:	6a 75                	push   $0x75
  jmp alltraps
80106eeb:	e9 68 f5 ff ff       	jmp    80106458 <alltraps>

80106ef0 <vector118>:
.globl vector118
vector118:
  pushl $0
80106ef0:	6a 00                	push   $0x0
  pushl $118
80106ef2:	6a 76                	push   $0x76
  jmp alltraps
80106ef4:	e9 5f f5 ff ff       	jmp    80106458 <alltraps>

80106ef9 <vector119>:
.globl vector119
vector119:
  pushl $0
80106ef9:	6a 00                	push   $0x0
  pushl $119
80106efb:	6a 77                	push   $0x77
  jmp alltraps
80106efd:	e9 56 f5 ff ff       	jmp    80106458 <alltraps>

80106f02 <vector120>:
.globl vector120
vector120:
  pushl $0
80106f02:	6a 00                	push   $0x0
  pushl $120
80106f04:	6a 78                	push   $0x78
  jmp alltraps
80106f06:	e9 4d f5 ff ff       	jmp    80106458 <alltraps>

80106f0b <vector121>:
.globl vector121
vector121:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $121
80106f0d:	6a 79                	push   $0x79
  jmp alltraps
80106f0f:	e9 44 f5 ff ff       	jmp    80106458 <alltraps>

80106f14 <vector122>:
.globl vector122
vector122:
  pushl $0
80106f14:	6a 00                	push   $0x0
  pushl $122
80106f16:	6a 7a                	push   $0x7a
  jmp alltraps
80106f18:	e9 3b f5 ff ff       	jmp    80106458 <alltraps>

80106f1d <vector123>:
.globl vector123
vector123:
  pushl $0
80106f1d:	6a 00                	push   $0x0
  pushl $123
80106f1f:	6a 7b                	push   $0x7b
  jmp alltraps
80106f21:	e9 32 f5 ff ff       	jmp    80106458 <alltraps>

80106f26 <vector124>:
.globl vector124
vector124:
  pushl $0
80106f26:	6a 00                	push   $0x0
  pushl $124
80106f28:	6a 7c                	push   $0x7c
  jmp alltraps
80106f2a:	e9 29 f5 ff ff       	jmp    80106458 <alltraps>

80106f2f <vector125>:
.globl vector125
vector125:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $125
80106f31:	6a 7d                	push   $0x7d
  jmp alltraps
80106f33:	e9 20 f5 ff ff       	jmp    80106458 <alltraps>

80106f38 <vector126>:
.globl vector126
vector126:
  pushl $0
80106f38:	6a 00                	push   $0x0
  pushl $126
80106f3a:	6a 7e                	push   $0x7e
  jmp alltraps
80106f3c:	e9 17 f5 ff ff       	jmp    80106458 <alltraps>

80106f41 <vector127>:
.globl vector127
vector127:
  pushl $0
80106f41:	6a 00                	push   $0x0
  pushl $127
80106f43:	6a 7f                	push   $0x7f
  jmp alltraps
80106f45:	e9 0e f5 ff ff       	jmp    80106458 <alltraps>

80106f4a <vector128>:
.globl vector128
vector128:
  pushl $0
80106f4a:	6a 00                	push   $0x0
  pushl $128
80106f4c:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106f51:	e9 02 f5 ff ff       	jmp    80106458 <alltraps>

80106f56 <vector129>:
.globl vector129
vector129:
  pushl $0
80106f56:	6a 00                	push   $0x0
  pushl $129
80106f58:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106f5d:	e9 f6 f4 ff ff       	jmp    80106458 <alltraps>

80106f62 <vector130>:
.globl vector130
vector130:
  pushl $0
80106f62:	6a 00                	push   $0x0
  pushl $130
80106f64:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106f69:	e9 ea f4 ff ff       	jmp    80106458 <alltraps>

80106f6e <vector131>:
.globl vector131
vector131:
  pushl $0
80106f6e:	6a 00                	push   $0x0
  pushl $131
80106f70:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106f75:	e9 de f4 ff ff       	jmp    80106458 <alltraps>

80106f7a <vector132>:
.globl vector132
vector132:
  pushl $0
80106f7a:	6a 00                	push   $0x0
  pushl $132
80106f7c:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106f81:	e9 d2 f4 ff ff       	jmp    80106458 <alltraps>

80106f86 <vector133>:
.globl vector133
vector133:
  pushl $0
80106f86:	6a 00                	push   $0x0
  pushl $133
80106f88:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106f8d:	e9 c6 f4 ff ff       	jmp    80106458 <alltraps>

80106f92 <vector134>:
.globl vector134
vector134:
  pushl $0
80106f92:	6a 00                	push   $0x0
  pushl $134
80106f94:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106f99:	e9 ba f4 ff ff       	jmp    80106458 <alltraps>

80106f9e <vector135>:
.globl vector135
vector135:
  pushl $0
80106f9e:	6a 00                	push   $0x0
  pushl $135
80106fa0:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106fa5:	e9 ae f4 ff ff       	jmp    80106458 <alltraps>

80106faa <vector136>:
.globl vector136
vector136:
  pushl $0
80106faa:	6a 00                	push   $0x0
  pushl $136
80106fac:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106fb1:	e9 a2 f4 ff ff       	jmp    80106458 <alltraps>

80106fb6 <vector137>:
.globl vector137
vector137:
  pushl $0
80106fb6:	6a 00                	push   $0x0
  pushl $137
80106fb8:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106fbd:	e9 96 f4 ff ff       	jmp    80106458 <alltraps>

80106fc2 <vector138>:
.globl vector138
vector138:
  pushl $0
80106fc2:	6a 00                	push   $0x0
  pushl $138
80106fc4:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106fc9:	e9 8a f4 ff ff       	jmp    80106458 <alltraps>

80106fce <vector139>:
.globl vector139
vector139:
  pushl $0
80106fce:	6a 00                	push   $0x0
  pushl $139
80106fd0:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106fd5:	e9 7e f4 ff ff       	jmp    80106458 <alltraps>

80106fda <vector140>:
.globl vector140
vector140:
  pushl $0
80106fda:	6a 00                	push   $0x0
  pushl $140
80106fdc:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106fe1:	e9 72 f4 ff ff       	jmp    80106458 <alltraps>

80106fe6 <vector141>:
.globl vector141
vector141:
  pushl $0
80106fe6:	6a 00                	push   $0x0
  pushl $141
80106fe8:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106fed:	e9 66 f4 ff ff       	jmp    80106458 <alltraps>

80106ff2 <vector142>:
.globl vector142
vector142:
  pushl $0
80106ff2:	6a 00                	push   $0x0
  pushl $142
80106ff4:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106ff9:	e9 5a f4 ff ff       	jmp    80106458 <alltraps>

80106ffe <vector143>:
.globl vector143
vector143:
  pushl $0
80106ffe:	6a 00                	push   $0x0
  pushl $143
80107000:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107005:	e9 4e f4 ff ff       	jmp    80106458 <alltraps>

8010700a <vector144>:
.globl vector144
vector144:
  pushl $0
8010700a:	6a 00                	push   $0x0
  pushl $144
8010700c:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107011:	e9 42 f4 ff ff       	jmp    80106458 <alltraps>

80107016 <vector145>:
.globl vector145
vector145:
  pushl $0
80107016:	6a 00                	push   $0x0
  pushl $145
80107018:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010701d:	e9 36 f4 ff ff       	jmp    80106458 <alltraps>

80107022 <vector146>:
.globl vector146
vector146:
  pushl $0
80107022:	6a 00                	push   $0x0
  pushl $146
80107024:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107029:	e9 2a f4 ff ff       	jmp    80106458 <alltraps>

8010702e <vector147>:
.globl vector147
vector147:
  pushl $0
8010702e:	6a 00                	push   $0x0
  pushl $147
80107030:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107035:	e9 1e f4 ff ff       	jmp    80106458 <alltraps>

8010703a <vector148>:
.globl vector148
vector148:
  pushl $0
8010703a:	6a 00                	push   $0x0
  pushl $148
8010703c:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107041:	e9 12 f4 ff ff       	jmp    80106458 <alltraps>

80107046 <vector149>:
.globl vector149
vector149:
  pushl $0
80107046:	6a 00                	push   $0x0
  pushl $149
80107048:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010704d:	e9 06 f4 ff ff       	jmp    80106458 <alltraps>

80107052 <vector150>:
.globl vector150
vector150:
  pushl $0
80107052:	6a 00                	push   $0x0
  pushl $150
80107054:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107059:	e9 fa f3 ff ff       	jmp    80106458 <alltraps>

8010705e <vector151>:
.globl vector151
vector151:
  pushl $0
8010705e:	6a 00                	push   $0x0
  pushl $151
80107060:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107065:	e9 ee f3 ff ff       	jmp    80106458 <alltraps>

8010706a <vector152>:
.globl vector152
vector152:
  pushl $0
8010706a:	6a 00                	push   $0x0
  pushl $152
8010706c:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107071:	e9 e2 f3 ff ff       	jmp    80106458 <alltraps>

80107076 <vector153>:
.globl vector153
vector153:
  pushl $0
80107076:	6a 00                	push   $0x0
  pushl $153
80107078:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010707d:	e9 d6 f3 ff ff       	jmp    80106458 <alltraps>

80107082 <vector154>:
.globl vector154
vector154:
  pushl $0
80107082:	6a 00                	push   $0x0
  pushl $154
80107084:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107089:	e9 ca f3 ff ff       	jmp    80106458 <alltraps>

8010708e <vector155>:
.globl vector155
vector155:
  pushl $0
8010708e:	6a 00                	push   $0x0
  pushl $155
80107090:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107095:	e9 be f3 ff ff       	jmp    80106458 <alltraps>

8010709a <vector156>:
.globl vector156
vector156:
  pushl $0
8010709a:	6a 00                	push   $0x0
  pushl $156
8010709c:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801070a1:	e9 b2 f3 ff ff       	jmp    80106458 <alltraps>

801070a6 <vector157>:
.globl vector157
vector157:
  pushl $0
801070a6:	6a 00                	push   $0x0
  pushl $157
801070a8:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801070ad:	e9 a6 f3 ff ff       	jmp    80106458 <alltraps>

801070b2 <vector158>:
.globl vector158
vector158:
  pushl $0
801070b2:	6a 00                	push   $0x0
  pushl $158
801070b4:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801070b9:	e9 9a f3 ff ff       	jmp    80106458 <alltraps>

801070be <vector159>:
.globl vector159
vector159:
  pushl $0
801070be:	6a 00                	push   $0x0
  pushl $159
801070c0:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801070c5:	e9 8e f3 ff ff       	jmp    80106458 <alltraps>

801070ca <vector160>:
.globl vector160
vector160:
  pushl $0
801070ca:	6a 00                	push   $0x0
  pushl $160
801070cc:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801070d1:	e9 82 f3 ff ff       	jmp    80106458 <alltraps>

801070d6 <vector161>:
.globl vector161
vector161:
  pushl $0
801070d6:	6a 00                	push   $0x0
  pushl $161
801070d8:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801070dd:	e9 76 f3 ff ff       	jmp    80106458 <alltraps>

801070e2 <vector162>:
.globl vector162
vector162:
  pushl $0
801070e2:	6a 00                	push   $0x0
  pushl $162
801070e4:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801070e9:	e9 6a f3 ff ff       	jmp    80106458 <alltraps>

801070ee <vector163>:
.globl vector163
vector163:
  pushl $0
801070ee:	6a 00                	push   $0x0
  pushl $163
801070f0:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801070f5:	e9 5e f3 ff ff       	jmp    80106458 <alltraps>

801070fa <vector164>:
.globl vector164
vector164:
  pushl $0
801070fa:	6a 00                	push   $0x0
  pushl $164
801070fc:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107101:	e9 52 f3 ff ff       	jmp    80106458 <alltraps>

80107106 <vector165>:
.globl vector165
vector165:
  pushl $0
80107106:	6a 00                	push   $0x0
  pushl $165
80107108:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010710d:	e9 46 f3 ff ff       	jmp    80106458 <alltraps>

80107112 <vector166>:
.globl vector166
vector166:
  pushl $0
80107112:	6a 00                	push   $0x0
  pushl $166
80107114:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107119:	e9 3a f3 ff ff       	jmp    80106458 <alltraps>

8010711e <vector167>:
.globl vector167
vector167:
  pushl $0
8010711e:	6a 00                	push   $0x0
  pushl $167
80107120:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107125:	e9 2e f3 ff ff       	jmp    80106458 <alltraps>

8010712a <vector168>:
.globl vector168
vector168:
  pushl $0
8010712a:	6a 00                	push   $0x0
  pushl $168
8010712c:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107131:	e9 22 f3 ff ff       	jmp    80106458 <alltraps>

80107136 <vector169>:
.globl vector169
vector169:
  pushl $0
80107136:	6a 00                	push   $0x0
  pushl $169
80107138:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010713d:	e9 16 f3 ff ff       	jmp    80106458 <alltraps>

80107142 <vector170>:
.globl vector170
vector170:
  pushl $0
80107142:	6a 00                	push   $0x0
  pushl $170
80107144:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107149:	e9 0a f3 ff ff       	jmp    80106458 <alltraps>

8010714e <vector171>:
.globl vector171
vector171:
  pushl $0
8010714e:	6a 00                	push   $0x0
  pushl $171
80107150:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107155:	e9 fe f2 ff ff       	jmp    80106458 <alltraps>

8010715a <vector172>:
.globl vector172
vector172:
  pushl $0
8010715a:	6a 00                	push   $0x0
  pushl $172
8010715c:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107161:	e9 f2 f2 ff ff       	jmp    80106458 <alltraps>

80107166 <vector173>:
.globl vector173
vector173:
  pushl $0
80107166:	6a 00                	push   $0x0
  pushl $173
80107168:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010716d:	e9 e6 f2 ff ff       	jmp    80106458 <alltraps>

80107172 <vector174>:
.globl vector174
vector174:
  pushl $0
80107172:	6a 00                	push   $0x0
  pushl $174
80107174:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107179:	e9 da f2 ff ff       	jmp    80106458 <alltraps>

8010717e <vector175>:
.globl vector175
vector175:
  pushl $0
8010717e:	6a 00                	push   $0x0
  pushl $175
80107180:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107185:	e9 ce f2 ff ff       	jmp    80106458 <alltraps>

8010718a <vector176>:
.globl vector176
vector176:
  pushl $0
8010718a:	6a 00                	push   $0x0
  pushl $176
8010718c:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107191:	e9 c2 f2 ff ff       	jmp    80106458 <alltraps>

80107196 <vector177>:
.globl vector177
vector177:
  pushl $0
80107196:	6a 00                	push   $0x0
  pushl $177
80107198:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010719d:	e9 b6 f2 ff ff       	jmp    80106458 <alltraps>

801071a2 <vector178>:
.globl vector178
vector178:
  pushl $0
801071a2:	6a 00                	push   $0x0
  pushl $178
801071a4:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801071a9:	e9 aa f2 ff ff       	jmp    80106458 <alltraps>

801071ae <vector179>:
.globl vector179
vector179:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $179
801071b0:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801071b5:	e9 9e f2 ff ff       	jmp    80106458 <alltraps>

801071ba <vector180>:
.globl vector180
vector180:
  pushl $0
801071ba:	6a 00                	push   $0x0
  pushl $180
801071bc:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801071c1:	e9 92 f2 ff ff       	jmp    80106458 <alltraps>

801071c6 <vector181>:
.globl vector181
vector181:
  pushl $0
801071c6:	6a 00                	push   $0x0
  pushl $181
801071c8:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801071cd:	e9 86 f2 ff ff       	jmp    80106458 <alltraps>

801071d2 <vector182>:
.globl vector182
vector182:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $182
801071d4:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801071d9:	e9 7a f2 ff ff       	jmp    80106458 <alltraps>

801071de <vector183>:
.globl vector183
vector183:
  pushl $0
801071de:	6a 00                	push   $0x0
  pushl $183
801071e0:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801071e5:	e9 6e f2 ff ff       	jmp    80106458 <alltraps>

801071ea <vector184>:
.globl vector184
vector184:
  pushl $0
801071ea:	6a 00                	push   $0x0
  pushl $184
801071ec:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801071f1:	e9 62 f2 ff ff       	jmp    80106458 <alltraps>

801071f6 <vector185>:
.globl vector185
vector185:
  pushl $0
801071f6:	6a 00                	push   $0x0
  pushl $185
801071f8:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801071fd:	e9 56 f2 ff ff       	jmp    80106458 <alltraps>

80107202 <vector186>:
.globl vector186
vector186:
  pushl $0
80107202:	6a 00                	push   $0x0
  pushl $186
80107204:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107209:	e9 4a f2 ff ff       	jmp    80106458 <alltraps>

8010720e <vector187>:
.globl vector187
vector187:
  pushl $0
8010720e:	6a 00                	push   $0x0
  pushl $187
80107210:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107215:	e9 3e f2 ff ff       	jmp    80106458 <alltraps>

8010721a <vector188>:
.globl vector188
vector188:
  pushl $0
8010721a:	6a 00                	push   $0x0
  pushl $188
8010721c:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107221:	e9 32 f2 ff ff       	jmp    80106458 <alltraps>

80107226 <vector189>:
.globl vector189
vector189:
  pushl $0
80107226:	6a 00                	push   $0x0
  pushl $189
80107228:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010722d:	e9 26 f2 ff ff       	jmp    80106458 <alltraps>

80107232 <vector190>:
.globl vector190
vector190:
  pushl $0
80107232:	6a 00                	push   $0x0
  pushl $190
80107234:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107239:	e9 1a f2 ff ff       	jmp    80106458 <alltraps>

8010723e <vector191>:
.globl vector191
vector191:
  pushl $0
8010723e:	6a 00                	push   $0x0
  pushl $191
80107240:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107245:	e9 0e f2 ff ff       	jmp    80106458 <alltraps>

8010724a <vector192>:
.globl vector192
vector192:
  pushl $0
8010724a:	6a 00                	push   $0x0
  pushl $192
8010724c:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107251:	e9 02 f2 ff ff       	jmp    80106458 <alltraps>

80107256 <vector193>:
.globl vector193
vector193:
  pushl $0
80107256:	6a 00                	push   $0x0
  pushl $193
80107258:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010725d:	e9 f6 f1 ff ff       	jmp    80106458 <alltraps>

80107262 <vector194>:
.globl vector194
vector194:
  pushl $0
80107262:	6a 00                	push   $0x0
  pushl $194
80107264:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107269:	e9 ea f1 ff ff       	jmp    80106458 <alltraps>

8010726e <vector195>:
.globl vector195
vector195:
  pushl $0
8010726e:	6a 00                	push   $0x0
  pushl $195
80107270:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107275:	e9 de f1 ff ff       	jmp    80106458 <alltraps>

8010727a <vector196>:
.globl vector196
vector196:
  pushl $0
8010727a:	6a 00                	push   $0x0
  pushl $196
8010727c:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107281:	e9 d2 f1 ff ff       	jmp    80106458 <alltraps>

80107286 <vector197>:
.globl vector197
vector197:
  pushl $0
80107286:	6a 00                	push   $0x0
  pushl $197
80107288:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010728d:	e9 c6 f1 ff ff       	jmp    80106458 <alltraps>

80107292 <vector198>:
.globl vector198
vector198:
  pushl $0
80107292:	6a 00                	push   $0x0
  pushl $198
80107294:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107299:	e9 ba f1 ff ff       	jmp    80106458 <alltraps>

8010729e <vector199>:
.globl vector199
vector199:
  pushl $0
8010729e:	6a 00                	push   $0x0
  pushl $199
801072a0:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801072a5:	e9 ae f1 ff ff       	jmp    80106458 <alltraps>

801072aa <vector200>:
.globl vector200
vector200:
  pushl $0
801072aa:	6a 00                	push   $0x0
  pushl $200
801072ac:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801072b1:	e9 a2 f1 ff ff       	jmp    80106458 <alltraps>

801072b6 <vector201>:
.globl vector201
vector201:
  pushl $0
801072b6:	6a 00                	push   $0x0
  pushl $201
801072b8:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801072bd:	e9 96 f1 ff ff       	jmp    80106458 <alltraps>

801072c2 <vector202>:
.globl vector202
vector202:
  pushl $0
801072c2:	6a 00                	push   $0x0
  pushl $202
801072c4:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801072c9:	e9 8a f1 ff ff       	jmp    80106458 <alltraps>

801072ce <vector203>:
.globl vector203
vector203:
  pushl $0
801072ce:	6a 00                	push   $0x0
  pushl $203
801072d0:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801072d5:	e9 7e f1 ff ff       	jmp    80106458 <alltraps>

801072da <vector204>:
.globl vector204
vector204:
  pushl $0
801072da:	6a 00                	push   $0x0
  pushl $204
801072dc:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801072e1:	e9 72 f1 ff ff       	jmp    80106458 <alltraps>

801072e6 <vector205>:
.globl vector205
vector205:
  pushl $0
801072e6:	6a 00                	push   $0x0
  pushl $205
801072e8:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801072ed:	e9 66 f1 ff ff       	jmp    80106458 <alltraps>

801072f2 <vector206>:
.globl vector206
vector206:
  pushl $0
801072f2:	6a 00                	push   $0x0
  pushl $206
801072f4:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801072f9:	e9 5a f1 ff ff       	jmp    80106458 <alltraps>

801072fe <vector207>:
.globl vector207
vector207:
  pushl $0
801072fe:	6a 00                	push   $0x0
  pushl $207
80107300:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107305:	e9 4e f1 ff ff       	jmp    80106458 <alltraps>

8010730a <vector208>:
.globl vector208
vector208:
  pushl $0
8010730a:	6a 00                	push   $0x0
  pushl $208
8010730c:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107311:	e9 42 f1 ff ff       	jmp    80106458 <alltraps>

80107316 <vector209>:
.globl vector209
vector209:
  pushl $0
80107316:	6a 00                	push   $0x0
  pushl $209
80107318:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010731d:	e9 36 f1 ff ff       	jmp    80106458 <alltraps>

80107322 <vector210>:
.globl vector210
vector210:
  pushl $0
80107322:	6a 00                	push   $0x0
  pushl $210
80107324:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107329:	e9 2a f1 ff ff       	jmp    80106458 <alltraps>

8010732e <vector211>:
.globl vector211
vector211:
  pushl $0
8010732e:	6a 00                	push   $0x0
  pushl $211
80107330:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107335:	e9 1e f1 ff ff       	jmp    80106458 <alltraps>

8010733a <vector212>:
.globl vector212
vector212:
  pushl $0
8010733a:	6a 00                	push   $0x0
  pushl $212
8010733c:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107341:	e9 12 f1 ff ff       	jmp    80106458 <alltraps>

80107346 <vector213>:
.globl vector213
vector213:
  pushl $0
80107346:	6a 00                	push   $0x0
  pushl $213
80107348:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010734d:	e9 06 f1 ff ff       	jmp    80106458 <alltraps>

80107352 <vector214>:
.globl vector214
vector214:
  pushl $0
80107352:	6a 00                	push   $0x0
  pushl $214
80107354:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107359:	e9 fa f0 ff ff       	jmp    80106458 <alltraps>

8010735e <vector215>:
.globl vector215
vector215:
  pushl $0
8010735e:	6a 00                	push   $0x0
  pushl $215
80107360:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107365:	e9 ee f0 ff ff       	jmp    80106458 <alltraps>

8010736a <vector216>:
.globl vector216
vector216:
  pushl $0
8010736a:	6a 00                	push   $0x0
  pushl $216
8010736c:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107371:	e9 e2 f0 ff ff       	jmp    80106458 <alltraps>

80107376 <vector217>:
.globl vector217
vector217:
  pushl $0
80107376:	6a 00                	push   $0x0
  pushl $217
80107378:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010737d:	e9 d6 f0 ff ff       	jmp    80106458 <alltraps>

80107382 <vector218>:
.globl vector218
vector218:
  pushl $0
80107382:	6a 00                	push   $0x0
  pushl $218
80107384:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107389:	e9 ca f0 ff ff       	jmp    80106458 <alltraps>

8010738e <vector219>:
.globl vector219
vector219:
  pushl $0
8010738e:	6a 00                	push   $0x0
  pushl $219
80107390:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107395:	e9 be f0 ff ff       	jmp    80106458 <alltraps>

8010739a <vector220>:
.globl vector220
vector220:
  pushl $0
8010739a:	6a 00                	push   $0x0
  pushl $220
8010739c:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801073a1:	e9 b2 f0 ff ff       	jmp    80106458 <alltraps>

801073a6 <vector221>:
.globl vector221
vector221:
  pushl $0
801073a6:	6a 00                	push   $0x0
  pushl $221
801073a8:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801073ad:	e9 a6 f0 ff ff       	jmp    80106458 <alltraps>

801073b2 <vector222>:
.globl vector222
vector222:
  pushl $0
801073b2:	6a 00                	push   $0x0
  pushl $222
801073b4:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801073b9:	e9 9a f0 ff ff       	jmp    80106458 <alltraps>

801073be <vector223>:
.globl vector223
vector223:
  pushl $0
801073be:	6a 00                	push   $0x0
  pushl $223
801073c0:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801073c5:	e9 8e f0 ff ff       	jmp    80106458 <alltraps>

801073ca <vector224>:
.globl vector224
vector224:
  pushl $0
801073ca:	6a 00                	push   $0x0
  pushl $224
801073cc:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801073d1:	e9 82 f0 ff ff       	jmp    80106458 <alltraps>

801073d6 <vector225>:
.globl vector225
vector225:
  pushl $0
801073d6:	6a 00                	push   $0x0
  pushl $225
801073d8:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801073dd:	e9 76 f0 ff ff       	jmp    80106458 <alltraps>

801073e2 <vector226>:
.globl vector226
vector226:
  pushl $0
801073e2:	6a 00                	push   $0x0
  pushl $226
801073e4:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801073e9:	e9 6a f0 ff ff       	jmp    80106458 <alltraps>

801073ee <vector227>:
.globl vector227
vector227:
  pushl $0
801073ee:	6a 00                	push   $0x0
  pushl $227
801073f0:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801073f5:	e9 5e f0 ff ff       	jmp    80106458 <alltraps>

801073fa <vector228>:
.globl vector228
vector228:
  pushl $0
801073fa:	6a 00                	push   $0x0
  pushl $228
801073fc:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107401:	e9 52 f0 ff ff       	jmp    80106458 <alltraps>

80107406 <vector229>:
.globl vector229
vector229:
  pushl $0
80107406:	6a 00                	push   $0x0
  pushl $229
80107408:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010740d:	e9 46 f0 ff ff       	jmp    80106458 <alltraps>

80107412 <vector230>:
.globl vector230
vector230:
  pushl $0
80107412:	6a 00                	push   $0x0
  pushl $230
80107414:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107419:	e9 3a f0 ff ff       	jmp    80106458 <alltraps>

8010741e <vector231>:
.globl vector231
vector231:
  pushl $0
8010741e:	6a 00                	push   $0x0
  pushl $231
80107420:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107425:	e9 2e f0 ff ff       	jmp    80106458 <alltraps>

8010742a <vector232>:
.globl vector232
vector232:
  pushl $0
8010742a:	6a 00                	push   $0x0
  pushl $232
8010742c:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107431:	e9 22 f0 ff ff       	jmp    80106458 <alltraps>

80107436 <vector233>:
.globl vector233
vector233:
  pushl $0
80107436:	6a 00                	push   $0x0
  pushl $233
80107438:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010743d:	e9 16 f0 ff ff       	jmp    80106458 <alltraps>

80107442 <vector234>:
.globl vector234
vector234:
  pushl $0
80107442:	6a 00                	push   $0x0
  pushl $234
80107444:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107449:	e9 0a f0 ff ff       	jmp    80106458 <alltraps>

8010744e <vector235>:
.globl vector235
vector235:
  pushl $0
8010744e:	6a 00                	push   $0x0
  pushl $235
80107450:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107455:	e9 fe ef ff ff       	jmp    80106458 <alltraps>

8010745a <vector236>:
.globl vector236
vector236:
  pushl $0
8010745a:	6a 00                	push   $0x0
  pushl $236
8010745c:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107461:	e9 f2 ef ff ff       	jmp    80106458 <alltraps>

80107466 <vector237>:
.globl vector237
vector237:
  pushl $0
80107466:	6a 00                	push   $0x0
  pushl $237
80107468:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010746d:	e9 e6 ef ff ff       	jmp    80106458 <alltraps>

80107472 <vector238>:
.globl vector238
vector238:
  pushl $0
80107472:	6a 00                	push   $0x0
  pushl $238
80107474:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107479:	e9 da ef ff ff       	jmp    80106458 <alltraps>

8010747e <vector239>:
.globl vector239
vector239:
  pushl $0
8010747e:	6a 00                	push   $0x0
  pushl $239
80107480:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107485:	e9 ce ef ff ff       	jmp    80106458 <alltraps>

8010748a <vector240>:
.globl vector240
vector240:
  pushl $0
8010748a:	6a 00                	push   $0x0
  pushl $240
8010748c:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107491:	e9 c2 ef ff ff       	jmp    80106458 <alltraps>

80107496 <vector241>:
.globl vector241
vector241:
  pushl $0
80107496:	6a 00                	push   $0x0
  pushl $241
80107498:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010749d:	e9 b6 ef ff ff       	jmp    80106458 <alltraps>

801074a2 <vector242>:
.globl vector242
vector242:
  pushl $0
801074a2:	6a 00                	push   $0x0
  pushl $242
801074a4:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801074a9:	e9 aa ef ff ff       	jmp    80106458 <alltraps>

801074ae <vector243>:
.globl vector243
vector243:
  pushl $0
801074ae:	6a 00                	push   $0x0
  pushl $243
801074b0:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801074b5:	e9 9e ef ff ff       	jmp    80106458 <alltraps>

801074ba <vector244>:
.globl vector244
vector244:
  pushl $0
801074ba:	6a 00                	push   $0x0
  pushl $244
801074bc:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801074c1:	e9 92 ef ff ff       	jmp    80106458 <alltraps>

801074c6 <vector245>:
.globl vector245
vector245:
  pushl $0
801074c6:	6a 00                	push   $0x0
  pushl $245
801074c8:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801074cd:	e9 86 ef ff ff       	jmp    80106458 <alltraps>

801074d2 <vector246>:
.globl vector246
vector246:
  pushl $0
801074d2:	6a 00                	push   $0x0
  pushl $246
801074d4:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801074d9:	e9 7a ef ff ff       	jmp    80106458 <alltraps>

801074de <vector247>:
.globl vector247
vector247:
  pushl $0
801074de:	6a 00                	push   $0x0
  pushl $247
801074e0:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801074e5:	e9 6e ef ff ff       	jmp    80106458 <alltraps>

801074ea <vector248>:
.globl vector248
vector248:
  pushl $0
801074ea:	6a 00                	push   $0x0
  pushl $248
801074ec:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801074f1:	e9 62 ef ff ff       	jmp    80106458 <alltraps>

801074f6 <vector249>:
.globl vector249
vector249:
  pushl $0
801074f6:	6a 00                	push   $0x0
  pushl $249
801074f8:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801074fd:	e9 56 ef ff ff       	jmp    80106458 <alltraps>

80107502 <vector250>:
.globl vector250
vector250:
  pushl $0
80107502:	6a 00                	push   $0x0
  pushl $250
80107504:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107509:	e9 4a ef ff ff       	jmp    80106458 <alltraps>

8010750e <vector251>:
.globl vector251
vector251:
  pushl $0
8010750e:	6a 00                	push   $0x0
  pushl $251
80107510:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107515:	e9 3e ef ff ff       	jmp    80106458 <alltraps>

8010751a <vector252>:
.globl vector252
vector252:
  pushl $0
8010751a:	6a 00                	push   $0x0
  pushl $252
8010751c:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107521:	e9 32 ef ff ff       	jmp    80106458 <alltraps>

80107526 <vector253>:
.globl vector253
vector253:
  pushl $0
80107526:	6a 00                	push   $0x0
  pushl $253
80107528:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010752d:	e9 26 ef ff ff       	jmp    80106458 <alltraps>

80107532 <vector254>:
.globl vector254
vector254:
  pushl $0
80107532:	6a 00                	push   $0x0
  pushl $254
80107534:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107539:	e9 1a ef ff ff       	jmp    80106458 <alltraps>

8010753e <vector255>:
.globl vector255
vector255:
  pushl $0
8010753e:	6a 00                	push   $0x0
  pushl $255
80107540:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107545:	e9 0e ef ff ff       	jmp    80106458 <alltraps>
8010754a:	66 90                	xchg   %ax,%ax

8010754c <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
8010754c:	55                   	push   %ebp
8010754d:	89 e5                	mov    %esp,%ebp
8010754f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107552:	8b 45 0c             	mov    0xc(%ebp),%eax
80107555:	83 e8 01             	sub    $0x1,%eax
80107558:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010755c:	8b 45 08             	mov    0x8(%ebp),%eax
8010755f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107563:	8b 45 08             	mov    0x8(%ebp),%eax
80107566:	c1 e8 10             	shr    $0x10,%eax
80107569:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010756d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107570:	0f 01 10             	lgdtl  (%eax)
}
80107573:	c9                   	leave  
80107574:	c3                   	ret    

80107575 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107575:	55                   	push   %ebp
80107576:	89 e5                	mov    %esp,%ebp
80107578:	83 ec 04             	sub    $0x4,%esp
8010757b:	8b 45 08             	mov    0x8(%ebp),%eax
8010757e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107582:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107586:	0f 00 d8             	ltr    %ax
}
80107589:	c9                   	leave  
8010758a:	c3                   	ret    

8010758b <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
8010758b:	55                   	push   %ebp
8010758c:	89 e5                	mov    %esp,%ebp
8010758e:	83 ec 04             	sub    $0x4,%esp
80107591:	8b 45 08             	mov    0x8(%ebp),%eax
80107594:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107598:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010759c:	8e e8                	mov    %eax,%gs
}
8010759e:	c9                   	leave  
8010759f:	c3                   	ret    

801075a0 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801075a3:	8b 45 08             	mov    0x8(%ebp),%eax
801075a6:	0f 22 d8             	mov    %eax,%cr3
}
801075a9:	5d                   	pop    %ebp
801075aa:	c3                   	ret    

801075ab <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801075ab:	55                   	push   %ebp
801075ac:	89 e5                	mov    %esp,%ebp
801075ae:	8b 45 08             	mov    0x8(%ebp),%eax
801075b1:	05 00 00 00 80       	add    $0x80000000,%eax
801075b6:	5d                   	pop    %ebp
801075b7:	c3                   	ret    

801075b8 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801075b8:	55                   	push   %ebp
801075b9:	89 e5                	mov    %esp,%ebp
801075bb:	8b 45 08             	mov    0x8(%ebp),%eax
801075be:	05 00 00 00 80       	add    $0x80000000,%eax
801075c3:	5d                   	pop    %ebp
801075c4:	c3                   	ret    

801075c5 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801075c5:	55                   	push   %ebp
801075c6:	89 e5                	mov    %esp,%ebp
801075c8:	53                   	push   %ebx
801075c9:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801075cc:	e8 b0 b8 ff ff       	call   80102e81 <cpunum>
801075d1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801075d7:	05 60 23 11 80       	add    $0x80112360,%eax
801075dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801075df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e2:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801075e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075eb:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801075f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f4:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801075f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075fb:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801075ff:	83 e2 f0             	and    $0xfffffff0,%edx
80107602:	83 ca 0a             	or     $0xa,%edx
80107605:	88 50 7d             	mov    %dl,0x7d(%eax)
80107608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010760b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010760f:	83 ca 10             	or     $0x10,%edx
80107612:	88 50 7d             	mov    %dl,0x7d(%eax)
80107615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107618:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010761c:	83 e2 9f             	and    $0xffffff9f,%edx
8010761f:	88 50 7d             	mov    %dl,0x7d(%eax)
80107622:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107625:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107629:	83 ca 80             	or     $0xffffff80,%edx
8010762c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010762f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107632:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107636:	83 ca 0f             	or     $0xf,%edx
80107639:	88 50 7e             	mov    %dl,0x7e(%eax)
8010763c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010763f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107643:	83 e2 ef             	and    $0xffffffef,%edx
80107646:	88 50 7e             	mov    %dl,0x7e(%eax)
80107649:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010764c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107650:	83 e2 df             	and    $0xffffffdf,%edx
80107653:	88 50 7e             	mov    %dl,0x7e(%eax)
80107656:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107659:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010765d:	83 ca 40             	or     $0x40,%edx
80107660:	88 50 7e             	mov    %dl,0x7e(%eax)
80107663:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107666:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010766a:	83 ca 80             	or     $0xffffff80,%edx
8010766d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107673:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107677:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010767a:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107681:	ff ff 
80107683:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107686:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010768d:	00 00 
8010768f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107692:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107699:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801076a3:	83 e2 f0             	and    $0xfffffff0,%edx
801076a6:	83 ca 02             	or     $0x2,%edx
801076a9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801076af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801076b9:	83 ca 10             	or     $0x10,%edx
801076bc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801076c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801076cc:	83 e2 9f             	and    $0xffffff9f,%edx
801076cf:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801076d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801076df:	83 ca 80             	or     $0xffffff80,%edx
801076e2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801076e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076eb:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801076f2:	83 ca 0f             	or     $0xf,%edx
801076f5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801076fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076fe:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107705:	83 e2 ef             	and    $0xffffffef,%edx
80107708:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010770e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107711:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107718:	83 e2 df             	and    $0xffffffdf,%edx
8010771b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107724:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010772b:	83 ca 40             	or     $0x40,%edx
8010772e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107737:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010773e:	83 ca 80             	or     $0xffffff80,%edx
80107741:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774a:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107754:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010775b:	ff ff 
8010775d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107760:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107767:	00 00 
80107769:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010776c:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107776:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010777d:	83 e2 f0             	and    $0xfffffff0,%edx
80107780:	83 ca 0a             	or     $0xa,%edx
80107783:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107789:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010778c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107793:	83 ca 10             	or     $0x10,%edx
80107796:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010779c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801077a6:	83 ca 60             	or     $0x60,%edx
801077a9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801077af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801077b9:	83 ca 80             	or     $0xffffff80,%edx
801077bc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801077c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801077cc:	83 ca 0f             	or     $0xf,%edx
801077cf:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801077d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801077df:	83 e2 ef             	and    $0xffffffef,%edx
801077e2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801077e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077eb:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801077f2:	83 e2 df             	and    $0xffffffdf,%edx
801077f5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801077fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077fe:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107805:	83 ca 40             	or     $0x40,%edx
80107808:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010780e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107811:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107818:	83 ca 80             	or     $0xffffff80,%edx
8010781b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107821:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107824:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010782b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782e:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107835:	ff ff 
80107837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010783a:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107841:	00 00 
80107843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107846:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
8010784d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107850:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107857:	83 e2 f0             	and    $0xfffffff0,%edx
8010785a:	83 ca 02             	or     $0x2,%edx
8010785d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107866:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010786d:	83 ca 10             	or     $0x10,%edx
80107870:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107879:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107880:	83 ca 60             	or     $0x60,%edx
80107883:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107889:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107893:	83 ca 80             	or     $0xffffff80,%edx
80107896:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010789c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010789f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801078a6:	83 ca 0f             	or     $0xf,%edx
801078a9:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801078af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801078b9:	83 e2 ef             	and    $0xffffffef,%edx
801078bc:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801078c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801078cc:	83 e2 df             	and    $0xffffffdf,%edx
801078cf:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801078d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801078df:	83 ca 40             	or     $0x40,%edx
801078e2:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801078e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078eb:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801078f2:	83 ca 80             	or     $0xffffff80,%edx
801078f5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801078fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078fe:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107908:	05 b4 00 00 00       	add    $0xb4,%eax
8010790d:	89 c3                	mov    %eax,%ebx
8010790f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107912:	05 b4 00 00 00       	add    $0xb4,%eax
80107917:	c1 e8 10             	shr    $0x10,%eax
8010791a:	89 c1                	mov    %eax,%ecx
8010791c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791f:	05 b4 00 00 00       	add    $0xb4,%eax
80107924:	c1 e8 18             	shr    $0x18,%eax
80107927:	89 c2                	mov    %eax,%edx
80107929:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792c:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107933:	00 00 
80107935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107938:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
8010793f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107942:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107948:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010794b:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107952:	83 e1 f0             	and    $0xfffffff0,%ecx
80107955:	83 c9 02             	or     $0x2,%ecx
80107958:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010795e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107961:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107968:	83 c9 10             	or     $0x10,%ecx
8010796b:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107974:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010797b:	83 e1 9f             	and    $0xffffff9f,%ecx
8010797e:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107987:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010798e:	83 c9 80             	or     $0xffffff80,%ecx
80107991:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107997:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010799a:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801079a1:	83 e1 f0             	and    $0xfffffff0,%ecx
801079a4:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801079aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ad:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801079b4:	83 e1 ef             	and    $0xffffffef,%ecx
801079b7:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801079bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c0:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801079c7:	83 e1 df             	and    $0xffffffdf,%ecx
801079ca:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801079d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d3:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801079da:	83 c9 40             	or     $0x40,%ecx
801079dd:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801079e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e6:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801079ed:	83 c9 80             	or     $0xffffff80,%ecx
801079f0:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801079f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f9:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801079ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a02:	83 c0 70             	add    $0x70,%eax
80107a05:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107a0c:	00 
80107a0d:	89 04 24             	mov    %eax,(%esp)
80107a10:	e8 37 fb ff ff       	call   8010754c <lgdt>
  loadgs(SEG_KCPU << 3);
80107a15:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107a1c:	e8 6a fb ff ff       	call   8010758b <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a24:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107a2a:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107a31:	00 00 00 00 
}
80107a35:	83 c4 24             	add    $0x24,%esp
80107a38:	5b                   	pop    %ebx
80107a39:	5d                   	pop    %ebp
80107a3a:	c3                   	ret    

80107a3b <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107a3b:	55                   	push   %ebp
80107a3c:	89 e5                	mov    %esp,%ebp
80107a3e:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107a41:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a44:	c1 e8 16             	shr    $0x16,%eax
80107a47:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107a4e:	8b 45 08             	mov    0x8(%ebp),%eax
80107a51:	01 d0                	add    %edx,%eax
80107a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a59:	8b 00                	mov    (%eax),%eax
80107a5b:	83 e0 01             	and    $0x1,%eax
80107a5e:	85 c0                	test   %eax,%eax
80107a60:	74 17                	je     80107a79 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a65:	8b 00                	mov    (%eax),%eax
80107a67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a6c:	89 04 24             	mov    %eax,(%esp)
80107a6f:	e8 44 fb ff ff       	call   801075b8 <p2v>
80107a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a77:	eb 4b                	jmp    80107ac4 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107a79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107a7d:	74 0e                	je     80107a8d <walkpgdir+0x52>
80107a7f:	e8 67 b0 ff ff       	call   80102aeb <kalloc>
80107a84:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a8b:	75 07                	jne    80107a94 <walkpgdir+0x59>
      return 0;
80107a8d:	b8 00 00 00 00       	mov    $0x0,%eax
80107a92:	eb 47                	jmp    80107adb <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107a94:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107a9b:	00 
80107a9c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107aa3:	00 
80107aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa7:	89 04 24             	mov    %eax,(%esp)
80107aaa:	e8 ab d5 ff ff       	call   8010505a <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab2:	89 04 24             	mov    %eax,(%esp)
80107ab5:	e8 f1 fa ff ff       	call   801075ab <v2p>
80107aba:	83 c8 07             	or     $0x7,%eax
80107abd:	89 c2                	mov    %eax,%edx
80107abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ac2:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ac7:	c1 e8 0c             	shr    $0xc,%eax
80107aca:	25 ff 03 00 00       	and    $0x3ff,%eax
80107acf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad9:	01 d0                	add    %edx,%eax
}
80107adb:	c9                   	leave  
80107adc:	c3                   	ret    

80107add <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107add:	55                   	push   %ebp
80107ade:	89 e5                	mov    %esp,%ebp
80107ae0:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ae6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107aee:	8b 55 0c             	mov    0xc(%ebp),%edx
80107af1:	8b 45 10             	mov    0x10(%ebp),%eax
80107af4:	01 d0                	add    %edx,%eax
80107af6:	83 e8 01             	sub    $0x1,%eax
80107af9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107b01:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107b08:	00 
80107b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80107b10:	8b 45 08             	mov    0x8(%ebp),%eax
80107b13:	89 04 24             	mov    %eax,(%esp)
80107b16:	e8 20 ff ff ff       	call   80107a3b <walkpgdir>
80107b1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107b1e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107b22:	75 07                	jne    80107b2b <mappages+0x4e>
      return -1;
80107b24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b29:	eb 48                	jmp    80107b73 <mappages+0x96>
    if(*pte & PTE_P)
80107b2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b2e:	8b 00                	mov    (%eax),%eax
80107b30:	83 e0 01             	and    $0x1,%eax
80107b33:	85 c0                	test   %eax,%eax
80107b35:	74 0c                	je     80107b43 <mappages+0x66>
      panic("remap");
80107b37:	c7 04 24 70 89 10 80 	movl   $0x80108970,(%esp)
80107b3e:	e8 f7 89 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80107b43:	8b 45 18             	mov    0x18(%ebp),%eax
80107b46:	0b 45 14             	or     0x14(%ebp),%eax
80107b49:	83 c8 01             	or     $0x1,%eax
80107b4c:	89 c2                	mov    %eax,%edx
80107b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b51:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b56:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107b59:	75 08                	jne    80107b63 <mappages+0x86>
      break;
80107b5b:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107b5c:	b8 00 00 00 00       	mov    $0x0,%eax
80107b61:	eb 10                	jmp    80107b73 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107b63:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107b6a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107b71:	eb 8e                	jmp    80107b01 <mappages+0x24>
  return 0;
}
80107b73:	c9                   	leave  
80107b74:	c3                   	ret    

80107b75 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107b75:	55                   	push   %ebp
80107b76:	89 e5                	mov    %esp,%ebp
80107b78:	53                   	push   %ebx
80107b79:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107b7c:	e8 6a af ff ff       	call   80102aeb <kalloc>
80107b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107b84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107b88:	75 0a                	jne    80107b94 <setupkvm+0x1f>
    return 0;
80107b8a:	b8 00 00 00 00       	mov    $0x0,%eax
80107b8f:	e9 98 00 00 00       	jmp    80107c2c <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107b94:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107b9b:	00 
80107b9c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107ba3:	00 
80107ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ba7:	89 04 24             	mov    %eax,(%esp)
80107baa:	e8 ab d4 ff ff       	call   8010505a <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107baf:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107bb6:	e8 fd f9 ff ff       	call   801075b8 <p2v>
80107bbb:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107bc0:	76 0c                	jbe    80107bce <setupkvm+0x59>
    panic("PHYSTOP too high");
80107bc2:	c7 04 24 76 89 10 80 	movl   $0x80108976,(%esp)
80107bc9:	e8 6c 89 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107bce:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107bd5:	eb 49                	jmp    80107c20 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bda:	8b 48 0c             	mov    0xc(%eax),%ecx
80107bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be0:	8b 50 04             	mov    0x4(%eax),%edx
80107be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be6:	8b 58 08             	mov    0x8(%eax),%ebx
80107be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bec:	8b 40 04             	mov    0x4(%eax),%eax
80107bef:	29 c3                	sub    %eax,%ebx
80107bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf4:	8b 00                	mov    (%eax),%eax
80107bf6:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107bfa:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107bfe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107c02:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c09:	89 04 24             	mov    %eax,(%esp)
80107c0c:	e8 cc fe ff ff       	call   80107add <mappages>
80107c11:	85 c0                	test   %eax,%eax
80107c13:	79 07                	jns    80107c1c <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107c15:	b8 00 00 00 00       	mov    $0x0,%eax
80107c1a:	eb 10                	jmp    80107c2c <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c1c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107c20:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107c27:	72 ae                	jb     80107bd7 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107c2c:	83 c4 34             	add    $0x34,%esp
80107c2f:	5b                   	pop    %ebx
80107c30:	5d                   	pop    %ebp
80107c31:	c3                   	ret    

80107c32 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107c32:	55                   	push   %ebp
80107c33:	89 e5                	mov    %esp,%ebp
80107c35:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107c38:	e8 38 ff ff ff       	call   80107b75 <setupkvm>
80107c3d:	a3 38 51 11 80       	mov    %eax,0x80115138
  switchkvm();
80107c42:	e8 02 00 00 00       	call   80107c49 <switchkvm>
}
80107c47:	c9                   	leave  
80107c48:	c3                   	ret    

80107c49 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107c49:	55                   	push   %ebp
80107c4a:	89 e5                	mov    %esp,%ebp
80107c4c:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107c4f:	a1 38 51 11 80       	mov    0x80115138,%eax
80107c54:	89 04 24             	mov    %eax,(%esp)
80107c57:	e8 4f f9 ff ff       	call   801075ab <v2p>
80107c5c:	89 04 24             	mov    %eax,(%esp)
80107c5f:	e8 3c f9 ff ff       	call   801075a0 <lcr3>
}
80107c64:	c9                   	leave  
80107c65:	c3                   	ret    

80107c66 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107c66:	55                   	push   %ebp
80107c67:	89 e5                	mov    %esp,%ebp
80107c69:	53                   	push   %ebx
80107c6a:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107c6d:	e8 e5 d2 ff ff       	call   80104f57 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107c72:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c78:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107c7f:	83 c2 08             	add    $0x8,%edx
80107c82:	89 d3                	mov    %edx,%ebx
80107c84:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107c8b:	83 c2 08             	add    $0x8,%edx
80107c8e:	c1 ea 10             	shr    $0x10,%edx
80107c91:	89 d1                	mov    %edx,%ecx
80107c93:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107c9a:	83 c2 08             	add    $0x8,%edx
80107c9d:	c1 ea 18             	shr    $0x18,%edx
80107ca0:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107ca7:	67 00 
80107ca9:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107cb0:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107cb6:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107cbd:	83 e1 f0             	and    $0xfffffff0,%ecx
80107cc0:	83 c9 09             	or     $0x9,%ecx
80107cc3:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107cc9:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107cd0:	83 c9 10             	or     $0x10,%ecx
80107cd3:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107cd9:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107ce0:	83 e1 9f             	and    $0xffffff9f,%ecx
80107ce3:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107ce9:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107cf0:	83 c9 80             	or     $0xffffff80,%ecx
80107cf3:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107cf9:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107d00:	83 e1 f0             	and    $0xfffffff0,%ecx
80107d03:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107d09:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107d10:	83 e1 ef             	and    $0xffffffef,%ecx
80107d13:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107d19:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107d20:	83 e1 df             	and    $0xffffffdf,%ecx
80107d23:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107d29:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107d30:	83 c9 40             	or     $0x40,%ecx
80107d33:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107d39:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107d40:	83 e1 7f             	and    $0x7f,%ecx
80107d43:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107d49:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107d4f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d55:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107d5c:	83 e2 ef             	and    $0xffffffef,%edx
80107d5f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107d65:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d6b:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107d71:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d77:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107d7e:	8b 52 08             	mov    0x8(%edx),%edx
80107d81:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107d87:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107d8a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107d91:	e8 df f7 ff ff       	call   80107575 <ltr>
  if(p->pgdir == 0)
80107d96:	8b 45 08             	mov    0x8(%ebp),%eax
80107d99:	8b 40 04             	mov    0x4(%eax),%eax
80107d9c:	85 c0                	test   %eax,%eax
80107d9e:	75 0c                	jne    80107dac <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107da0:	c7 04 24 87 89 10 80 	movl   $0x80108987,(%esp)
80107da7:	e8 8e 87 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107dac:	8b 45 08             	mov    0x8(%ebp),%eax
80107daf:	8b 40 04             	mov    0x4(%eax),%eax
80107db2:	89 04 24             	mov    %eax,(%esp)
80107db5:	e8 f1 f7 ff ff       	call   801075ab <v2p>
80107dba:	89 04 24             	mov    %eax,(%esp)
80107dbd:	e8 de f7 ff ff       	call   801075a0 <lcr3>
  popcli();
80107dc2:	e8 d4 d1 ff ff       	call   80104f9b <popcli>
}
80107dc7:	83 c4 14             	add    $0x14,%esp
80107dca:	5b                   	pop    %ebx
80107dcb:	5d                   	pop    %ebp
80107dcc:	c3                   	ret    

80107dcd <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107dcd:	55                   	push   %ebp
80107dce:	89 e5                	mov    %esp,%ebp
80107dd0:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107dd3:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107dda:	76 0c                	jbe    80107de8 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107ddc:	c7 04 24 9b 89 10 80 	movl   $0x8010899b,(%esp)
80107de3:	e8 52 87 ff ff       	call   8010053a <panic>
  mem = kalloc();
80107de8:	e8 fe ac ff ff       	call   80102aeb <kalloc>
80107ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107df0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107df7:	00 
80107df8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107dff:	00 
80107e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e03:	89 04 24             	mov    %eax,(%esp)
80107e06:	e8 4f d2 ff ff       	call   8010505a <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0e:	89 04 24             	mov    %eax,(%esp)
80107e11:	e8 95 f7 ff ff       	call   801075ab <v2p>
80107e16:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107e1d:	00 
80107e1e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107e22:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e29:	00 
80107e2a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107e31:	00 
80107e32:	8b 45 08             	mov    0x8(%ebp),%eax
80107e35:	89 04 24             	mov    %eax,(%esp)
80107e38:	e8 a0 fc ff ff       	call   80107add <mappages>
  memmove(mem, init, sz);
80107e3d:	8b 45 10             	mov    0x10(%ebp),%eax
80107e40:	89 44 24 08          	mov    %eax,0x8(%esp)
80107e44:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e47:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4e:	89 04 24             	mov    %eax,(%esp)
80107e51:	e8 d3 d2 ff ff       	call   80105129 <memmove>
}
80107e56:	c9                   	leave  
80107e57:	c3                   	ret    

80107e58 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107e58:	55                   	push   %ebp
80107e59:	89 e5                	mov    %esp,%ebp
80107e5b:	53                   	push   %ebx
80107e5c:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e62:	25 ff 0f 00 00       	and    $0xfff,%eax
80107e67:	85 c0                	test   %eax,%eax
80107e69:	74 0c                	je     80107e77 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107e6b:	c7 04 24 b8 89 10 80 	movl   $0x801089b8,(%esp)
80107e72:	e8 c3 86 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107e77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107e7e:	e9 a9 00 00 00       	jmp    80107f2c <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e86:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e89:	01 d0                	add    %edx,%eax
80107e8b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107e92:	00 
80107e93:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e97:	8b 45 08             	mov    0x8(%ebp),%eax
80107e9a:	89 04 24             	mov    %eax,(%esp)
80107e9d:	e8 99 fb ff ff       	call   80107a3b <walkpgdir>
80107ea2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107ea5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107ea9:	75 0c                	jne    80107eb7 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80107eab:	c7 04 24 db 89 10 80 	movl   $0x801089db,(%esp)
80107eb2:	e8 83 86 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80107eb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107eba:	8b 00                	mov    (%eax),%eax
80107ebc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ec1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec7:	8b 55 18             	mov    0x18(%ebp),%edx
80107eca:	29 c2                	sub    %eax,%edx
80107ecc:	89 d0                	mov    %edx,%eax
80107ece:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107ed3:	77 0f                	ja     80107ee4 <loaduvm+0x8c>
      n = sz - i;
80107ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed8:	8b 55 18             	mov    0x18(%ebp),%edx
80107edb:	29 c2                	sub    %eax,%edx
80107edd:	89 d0                	mov    %edx,%eax
80107edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107ee2:	eb 07                	jmp    80107eeb <loaduvm+0x93>
    else
      n = PGSIZE;
80107ee4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eee:	8b 55 14             	mov    0x14(%ebp),%edx
80107ef1:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107ef4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ef7:	89 04 24             	mov    %eax,(%esp)
80107efa:	e8 b9 f6 ff ff       	call   801075b8 <p2v>
80107eff:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107f02:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107f06:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f0e:	8b 45 10             	mov    0x10(%ebp),%eax
80107f11:	89 04 24             	mov    %eax,(%esp)
80107f14:	e8 52 9e ff ff       	call   80101d6b <readi>
80107f19:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107f1c:	74 07                	je     80107f25 <loaduvm+0xcd>
      return -1;
80107f1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f23:	eb 18                	jmp    80107f3d <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107f25:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2f:	3b 45 18             	cmp    0x18(%ebp),%eax
80107f32:	0f 82 4b ff ff ff    	jb     80107e83 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107f38:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f3d:	83 c4 24             	add    $0x24,%esp
80107f40:	5b                   	pop    %ebx
80107f41:	5d                   	pop    %ebp
80107f42:	c3                   	ret    

80107f43 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107f43:	55                   	push   %ebp
80107f44:	89 e5                	mov    %esp,%ebp
80107f46:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107f49:	8b 45 10             	mov    0x10(%ebp),%eax
80107f4c:	85 c0                	test   %eax,%eax
80107f4e:	79 0a                	jns    80107f5a <allocuvm+0x17>
    return 0;
80107f50:	b8 00 00 00 00       	mov    $0x0,%eax
80107f55:	e9 c1 00 00 00       	jmp    8010801b <allocuvm+0xd8>
  if(newsz < oldsz)
80107f5a:	8b 45 10             	mov    0x10(%ebp),%eax
80107f5d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107f60:	73 08                	jae    80107f6a <allocuvm+0x27>
    return oldsz;
80107f62:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f65:	e9 b1 00 00 00       	jmp    8010801b <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80107f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f6d:	05 ff 0f 00 00       	add    $0xfff,%eax
80107f72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107f7a:	e9 8d 00 00 00       	jmp    8010800c <allocuvm+0xc9>
    mem = kalloc();
80107f7f:	e8 67 ab ff ff       	call   80102aeb <kalloc>
80107f84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107f87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107f8b:	75 2c                	jne    80107fb9 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80107f8d:	c7 04 24 f9 89 10 80 	movl   $0x801089f9,(%esp)
80107f94:	e8 07 84 ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107f99:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f9c:	89 44 24 08          	mov    %eax,0x8(%esp)
80107fa0:	8b 45 10             	mov    0x10(%ebp),%eax
80107fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
80107fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80107faa:	89 04 24             	mov    %eax,(%esp)
80107fad:	e8 6b 00 00 00       	call   8010801d <deallocuvm>
      return 0;
80107fb2:	b8 00 00 00 00       	mov    $0x0,%eax
80107fb7:	eb 62                	jmp    8010801b <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80107fb9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107fc0:	00 
80107fc1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107fc8:	00 
80107fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fcc:	89 04 24             	mov    %eax,(%esp)
80107fcf:	e8 86 d0 ff ff       	call   8010505a <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fd7:	89 04 24             	mov    %eax,(%esp)
80107fda:	e8 cc f5 ff ff       	call   801075ab <v2p>
80107fdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107fe2:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107fe9:	00 
80107fea:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107fee:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ff5:	00 
80107ff6:	89 54 24 04          	mov    %edx,0x4(%esp)
80107ffa:	8b 45 08             	mov    0x8(%ebp),%eax
80107ffd:	89 04 24             	mov    %eax,(%esp)
80108000:	e8 d8 fa ff ff       	call   80107add <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108005:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010800c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800f:	3b 45 10             	cmp    0x10(%ebp),%eax
80108012:	0f 82 67 ff ff ff    	jb     80107f7f <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108018:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010801b:	c9                   	leave  
8010801c:	c3                   	ret    

8010801d <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010801d:	55                   	push   %ebp
8010801e:	89 e5                	mov    %esp,%ebp
80108020:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108023:	8b 45 10             	mov    0x10(%ebp),%eax
80108026:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108029:	72 08                	jb     80108033 <deallocuvm+0x16>
    return oldsz;
8010802b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010802e:	e9 a4 00 00 00       	jmp    801080d7 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80108033:	8b 45 10             	mov    0x10(%ebp),%eax
80108036:	05 ff 0f 00 00       	add    $0xfff,%eax
8010803b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108040:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108043:	e9 80 00 00 00       	jmp    801080c8 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108052:	00 
80108053:	89 44 24 04          	mov    %eax,0x4(%esp)
80108057:	8b 45 08             	mov    0x8(%ebp),%eax
8010805a:	89 04 24             	mov    %eax,(%esp)
8010805d:	e8 d9 f9 ff ff       	call   80107a3b <walkpgdir>
80108062:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108065:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108069:	75 09                	jne    80108074 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
8010806b:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108072:	eb 4d                	jmp    801080c1 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80108074:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108077:	8b 00                	mov    (%eax),%eax
80108079:	83 e0 01             	and    $0x1,%eax
8010807c:	85 c0                	test   %eax,%eax
8010807e:	74 41                	je     801080c1 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80108080:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108083:	8b 00                	mov    (%eax),%eax
80108085:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010808a:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
8010808d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108091:	75 0c                	jne    8010809f <deallocuvm+0x82>
        panic("kfree");
80108093:	c7 04 24 11 8a 10 80 	movl   $0x80108a11,(%esp)
8010809a:	e8 9b 84 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
8010809f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080a2:	89 04 24             	mov    %eax,(%esp)
801080a5:	e8 0e f5 ff ff       	call   801075b8 <p2v>
801080aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801080ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
801080b0:	89 04 24             	mov    %eax,(%esp)
801080b3:	e8 9a a9 ff ff       	call   80102a52 <kfree>
      *pte = 0;
801080b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801080c1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080ce:	0f 82 74 ff ff ff    	jb     80108048 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801080d4:	8b 45 10             	mov    0x10(%ebp),%eax
}
801080d7:	c9                   	leave  
801080d8:	c3                   	ret    

801080d9 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801080d9:	55                   	push   %ebp
801080da:	89 e5                	mov    %esp,%ebp
801080dc:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
801080df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801080e3:	75 0c                	jne    801080f1 <freevm+0x18>
    panic("freevm: no pgdir");
801080e5:	c7 04 24 17 8a 10 80 	movl   $0x80108a17,(%esp)
801080ec:	e8 49 84 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801080f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801080f8:	00 
801080f9:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108100:	80 
80108101:	8b 45 08             	mov    0x8(%ebp),%eax
80108104:	89 04 24             	mov    %eax,(%esp)
80108107:	e8 11 ff ff ff       	call   8010801d <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010810c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108113:	eb 48                	jmp    8010815d <freevm+0x84>
    if(pgdir[i] & PTE_P){
80108115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108118:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010811f:	8b 45 08             	mov    0x8(%ebp),%eax
80108122:	01 d0                	add    %edx,%eax
80108124:	8b 00                	mov    (%eax),%eax
80108126:	83 e0 01             	and    $0x1,%eax
80108129:	85 c0                	test   %eax,%eax
8010812b:	74 2c                	je     80108159 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010812d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108130:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108137:	8b 45 08             	mov    0x8(%ebp),%eax
8010813a:	01 d0                	add    %edx,%eax
8010813c:	8b 00                	mov    (%eax),%eax
8010813e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108143:	89 04 24             	mov    %eax,(%esp)
80108146:	e8 6d f4 ff ff       	call   801075b8 <p2v>
8010814b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010814e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108151:	89 04 24             	mov    %eax,(%esp)
80108154:	e8 f9 a8 ff ff       	call   80102a52 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108159:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010815d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108164:	76 af                	jbe    80108115 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108166:	8b 45 08             	mov    0x8(%ebp),%eax
80108169:	89 04 24             	mov    %eax,(%esp)
8010816c:	e8 e1 a8 ff ff       	call   80102a52 <kfree>
}
80108171:	c9                   	leave  
80108172:	c3                   	ret    

80108173 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108173:	55                   	push   %ebp
80108174:	89 e5                	mov    %esp,%ebp
80108176:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108179:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108180:	00 
80108181:	8b 45 0c             	mov    0xc(%ebp),%eax
80108184:	89 44 24 04          	mov    %eax,0x4(%esp)
80108188:	8b 45 08             	mov    0x8(%ebp),%eax
8010818b:	89 04 24             	mov    %eax,(%esp)
8010818e:	e8 a8 f8 ff ff       	call   80107a3b <walkpgdir>
80108193:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108196:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010819a:	75 0c                	jne    801081a8 <clearpteu+0x35>
    panic("clearpteu");
8010819c:	c7 04 24 28 8a 10 80 	movl   $0x80108a28,(%esp)
801081a3:	e8 92 83 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
801081a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ab:	8b 00                	mov    (%eax),%eax
801081ad:	83 e0 fb             	and    $0xfffffffb,%eax
801081b0:	89 c2                	mov    %eax,%edx
801081b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b5:	89 10                	mov    %edx,(%eax)
}
801081b7:	c9                   	leave  
801081b8:	c3                   	ret    

801081b9 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801081b9:	55                   	push   %ebp
801081ba:	89 e5                	mov    %esp,%ebp
801081bc:	53                   	push   %ebx
801081bd:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801081c0:	e8 b0 f9 ff ff       	call   80107b75 <setupkvm>
801081c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801081c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081cc:	75 0a                	jne    801081d8 <copyuvm+0x1f>
    return 0;
801081ce:	b8 00 00 00 00       	mov    $0x0,%eax
801081d3:	e9 fd 00 00 00       	jmp    801082d5 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
801081d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801081df:	e9 d0 00 00 00       	jmp    801082b4 <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801081e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801081ee:	00 
801081ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801081f3:	8b 45 08             	mov    0x8(%ebp),%eax
801081f6:	89 04 24             	mov    %eax,(%esp)
801081f9:	e8 3d f8 ff ff       	call   80107a3b <walkpgdir>
801081fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108201:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108205:	75 0c                	jne    80108213 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108207:	c7 04 24 32 8a 10 80 	movl   $0x80108a32,(%esp)
8010820e:	e8 27 83 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80108213:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108216:	8b 00                	mov    (%eax),%eax
80108218:	83 e0 01             	and    $0x1,%eax
8010821b:	85 c0                	test   %eax,%eax
8010821d:	75 0c                	jne    8010822b <copyuvm+0x72>
      panic("copyuvm: page not present");
8010821f:	c7 04 24 4c 8a 10 80 	movl   $0x80108a4c,(%esp)
80108226:	e8 0f 83 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
8010822b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010822e:	8b 00                	mov    (%eax),%eax
80108230:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108235:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108238:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010823b:	8b 00                	mov    (%eax),%eax
8010823d:	25 ff 0f 00 00       	and    $0xfff,%eax
80108242:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108245:	e8 a1 a8 ff ff       	call   80102aeb <kalloc>
8010824a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010824d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108251:	75 02                	jne    80108255 <copyuvm+0x9c>
      goto bad;
80108253:	eb 70                	jmp    801082c5 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108255:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108258:	89 04 24             	mov    %eax,(%esp)
8010825b:	e8 58 f3 ff ff       	call   801075b8 <p2v>
80108260:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108267:	00 
80108268:	89 44 24 04          	mov    %eax,0x4(%esp)
8010826c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010826f:	89 04 24             	mov    %eax,(%esp)
80108272:	e8 b2 ce ff ff       	call   80105129 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108277:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010827a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010827d:	89 04 24             	mov    %eax,(%esp)
80108280:	e8 26 f3 ff ff       	call   801075ab <v2p>
80108285:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108288:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010828c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108290:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108297:	00 
80108298:	89 54 24 04          	mov    %edx,0x4(%esp)
8010829c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010829f:	89 04 24             	mov    %eax,(%esp)
801082a2:	e8 36 f8 ff ff       	call   80107add <mappages>
801082a7:	85 c0                	test   %eax,%eax
801082a9:	79 02                	jns    801082ad <copyuvm+0xf4>
      goto bad;
801082ab:	eb 18                	jmp    801082c5 <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801082ad:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801082b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
801082ba:	0f 82 24 ff ff ff    	jb     801081e4 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801082c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082c3:	eb 10                	jmp    801082d5 <copyuvm+0x11c>

bad:
  freevm(d);
801082c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082c8:	89 04 24             	mov    %eax,(%esp)
801082cb:	e8 09 fe ff ff       	call   801080d9 <freevm>
  return 0;
801082d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801082d5:	83 c4 44             	add    $0x44,%esp
801082d8:	5b                   	pop    %ebx
801082d9:	5d                   	pop    %ebp
801082da:	c3                   	ret    

801082db <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801082db:	55                   	push   %ebp
801082dc:	89 e5                	mov    %esp,%ebp
801082de:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801082e1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801082e8:	00 
801082e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801082ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801082f0:	8b 45 08             	mov    0x8(%ebp),%eax
801082f3:	89 04 24             	mov    %eax,(%esp)
801082f6:	e8 40 f7 ff ff       	call   80107a3b <walkpgdir>
801082fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801082fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108301:	8b 00                	mov    (%eax),%eax
80108303:	83 e0 01             	and    $0x1,%eax
80108306:	85 c0                	test   %eax,%eax
80108308:	75 07                	jne    80108311 <uva2ka+0x36>
    return 0;
8010830a:	b8 00 00 00 00       	mov    $0x0,%eax
8010830f:	eb 25                	jmp    80108336 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108311:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108314:	8b 00                	mov    (%eax),%eax
80108316:	83 e0 04             	and    $0x4,%eax
80108319:	85 c0                	test   %eax,%eax
8010831b:	75 07                	jne    80108324 <uva2ka+0x49>
    return 0;
8010831d:	b8 00 00 00 00       	mov    $0x0,%eax
80108322:	eb 12                	jmp    80108336 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108327:	8b 00                	mov    (%eax),%eax
80108329:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010832e:	89 04 24             	mov    %eax,(%esp)
80108331:	e8 82 f2 ff ff       	call   801075b8 <p2v>
}
80108336:	c9                   	leave  
80108337:	c3                   	ret    

80108338 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108338:	55                   	push   %ebp
80108339:	89 e5                	mov    %esp,%ebp
8010833b:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010833e:	8b 45 10             	mov    0x10(%ebp),%eax
80108341:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108344:	e9 87 00 00 00       	jmp    801083d0 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108349:	8b 45 0c             	mov    0xc(%ebp),%eax
8010834c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108351:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108354:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108357:	89 44 24 04          	mov    %eax,0x4(%esp)
8010835b:	8b 45 08             	mov    0x8(%ebp),%eax
8010835e:	89 04 24             	mov    %eax,(%esp)
80108361:	e8 75 ff ff ff       	call   801082db <uva2ka>
80108366:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108369:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010836d:	75 07                	jne    80108376 <copyout+0x3e>
      return -1;
8010836f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108374:	eb 69                	jmp    801083df <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108376:	8b 45 0c             	mov    0xc(%ebp),%eax
80108379:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010837c:	29 c2                	sub    %eax,%edx
8010837e:	89 d0                	mov    %edx,%eax
80108380:	05 00 10 00 00       	add    $0x1000,%eax
80108385:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108388:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010838b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010838e:	76 06                	jbe    80108396 <copyout+0x5e>
      n = len;
80108390:	8b 45 14             	mov    0x14(%ebp),%eax
80108393:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108396:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108399:	8b 55 0c             	mov    0xc(%ebp),%edx
8010839c:	29 c2                	sub    %eax,%edx
8010839e:	8b 45 e8             	mov    -0x18(%ebp),%eax
801083a1:	01 c2                	add    %eax,%edx
801083a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801083aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801083b1:	89 14 24             	mov    %edx,(%esp)
801083b4:	e8 70 cd ff ff       	call   80105129 <memmove>
    len -= n;
801083b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083bc:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801083bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083c2:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801083c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083c8:	05 00 10 00 00       	add    $0x1000,%eax
801083cd:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801083d0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801083d4:	0f 85 6f ff ff ff    	jne    80108349 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801083da:	b8 00 00 00 00       	mov    $0x0,%eax
}
801083df:	c9                   	leave  
801083e0:	c3                   	ret    
