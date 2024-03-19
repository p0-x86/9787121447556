;===============================================================================
SECTION header vstart=0
  program_length  dd program_end              ;[0x00]

  code_entry      dw start                    ;[0x04]
                    dd section.code.start     ;[0x06] 

  realloc_tbl_len dw (header_end-realloc_begin)/4 ;[0x0a]

  realloc_begin:

  code_segment dd section.code.start   ;[0x0c]
  data_segment    dd section.data.start   ;[0x14]
  stack_segment   dd section.stack.start  ;[0x1c]

header_end:

; 数据段  
;===============================================================================
SECTION data align=16 vstart=0

    init_msg       db 'Starting...',0x0d,0x0a,0
                   
    inst_msg       db 'Installing a new interrupt 70H...',0
    
    done_msg       db 'Done.',0x0d,0x0a,0

    tips_msg       db 'Clock is now working.',0


; 栈段
;===============================================================================
SECTION stack align=16 vstart=0
           
                 resb 256
ss_pointer:


; 代码段
;===============================================================================
SECTION code align=16 vstart=0

;-------------------------------------------------------------------------------
start:
  ; 初始化段寄存器
  mov ax,[stack_segment]
  mov ss,ax
  mov sp,ss_pointer
  mov ax,[data_segment]
  mov ds,ax


  mov al, 0x70
  mov bl, 4
  mul bl
  mov bx, ax            ; 计算 0x70 号中断在IVT中的偏移


    cli                                ; 暂停中断

    push es
    mov ax,0x0000
    mov es,ax
    mov word [es:bx],new_int_0x70      ; 偏移地址
                                          
    mov word [es:bx+2],cs              ; 段地址
      pop es