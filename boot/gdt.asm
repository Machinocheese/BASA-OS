; GDT - Implementing "Basic Flat Model" - two overlapping segments of code and data
; TL;DR: a struct for memory segments (eg. data, code)

;Some basic terms:
;Base = where code segment begins in physical memory
;	For some reason, base address is fragmented. Who knows...
;Limit = segment size
;Present: if segment is present in memory (1)
;Privilige: 0 for ring 0 (root)
;Descriptor type: 1 for code/data, 0 for traps
;Type:
;    Code = 1 for code (code segment)
;    Conforming = code in a lower ring cannot call (vital to memory protection)
;    Readable = 1 for readable, 0 for exec-only
;    Accessed = useful for debugging / virtual memory
;Granularity: if 1, multiply Limit by 48 (shift address 3 hex bytes left)
;32-bit default: if 1, sets default data unit size to 32-bit, otherwise still 16-bit
;64-bit default: unused on 32-bit
;AVL: free for use

gdt_start:

gdt_null: ; the  mandatory  null  descriptor
dd 0x0   ; ’dd’ means  define  double  word (i.e. 4 bytes)
dd 0x0   ; used as an error handler for attempting to access an address
         ; before setting up a particular segment register

gdt_code: ; the  code  segment  descriptor
; base=0x0, limit=0xfffff ,
; 1st  flags: (present )1 (privilege )00 (descriptor  type)1 -> 1001b
; type  flags: (code)1 (conforming )0 (readable )1 (accessed )0 -> 1010b
; 2nd  flags: (granularity )1 (32-bit  default )1 (64-bit  seg)0 (AVL)0 -> 1100b
dw 0xffff     ; Limit (bits  0-15)
dw 0x0         ; Base (bits  0-15)
db 0x0         ; Base (bits  16 -23)
db  10011010b ; 1st flags , type  flags
db  11001111b ; 2nd flags , Limit (bits  16-19)
db 0x0         ; Base (bits  24 -31)

gdt_data: ;the  data  segment  descriptor
; Same as code  segment  except  for  the  type  flags:
; type  flags: (code)0 (expand  down)0 (writable )1 (accessed )0 -> 0010b
dw 0xffff     ; Limit (bits  0-15)
dw 0x0         ; Base (bits  0-15)
db 0x0         ; Base (bits  16 -23)
db  10010010b ; 1st flags , type  flags
db  11001111b ; 2nd flags , Limit (bits  16-19)
db 0x0         ; Base (bits  24 -31)

gdt_end:         ; The  reason  for  putting a label  at the  end of the
; GDT is so we can  have  the  assembler  calculate
; the  size of the  GDT  for  the GDT  decriptor (below)
; GDT  descriptior

gdt_descriptor:
dw  gdt_end  - gdt_start  - 1   ; Size of our GDT , always  less  one
; of the  true  size
dd  gdt_start                   ; Start  address  of our  GDT
; Define  some  handy  constants  for  the  GDT  segment  descriptor  offsets , which
; are  what  segment  registers  must  contain  when in  protected  mode.  For  example ,
; when we set DS = 0x10 in PM , the  CPU  knows  that we mean it to use  the
; segment  described  at  offset 0x10 (i.e. 16  bytes) in our GDT , which in our
; case is the  DATA  segment  (0x0 -> NULL; 0x08  -> CODE; 0x10  -> DATA)
CODE_SEG  equ  gdt_code  - gdt_start
DATA_SEG  equ  gdt_data  - gdt_start
