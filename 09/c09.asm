SECTION header vstart=0

    ; 用户程序的尺寸
    program_length  dd program_end                                  ; 大小 [0x00]

    ; 应用程序的入口点
    code_entry    dw start                                          ; 偏移地址 [0x04]
                  dd section.code_1.start                           ; 段地址 [0x06]

    realloc_tbl_len dw (header_end - code_1_segment) / 4            ; 段重定位的项目数 [0x0a]

    code_1_segment  dd section.code_1.start ;[0x0c]
    code_2_segment  dd section.code_2.start ;[0x10]
    data_1_segment  dd section.data_1.start ;[0x14]
    data_2_segment  dd section.data_2.start ;[0x18]
    stack_segment   dd section.stack.start  ;[0x1c]

    header_end:

SECTION code_1 align=16 vstart=0

;===============================================================================
SECTION code_1 align=16 vstart=0 

put_string:                              ;��ʾ��(0��β)��
                                         ;���룺DS:BX=����ַ
         mov cl,[bx]
         or cl,cl                        ;cl=0 ?
         jz .exit                        ;�ǵģ����������� 
         call put_char
         inc bx                          ;��һ���ַ� 
         jmp put_string

   .exit:
         ret
         
start:

    mov ax,[stack_segment]
    mov ss,ax
    mov sp,stack_end

    mov ax,[data_1_segment]
    mov ds,ax
    

    mov bx,msg0
    call put_string


;===============================================================================
SECTION code_2 align=16 vstart=0          ;��������2��16�ֽڶ��룩

  begin:
         push word [es:code_1_segment]
         mov ax,continue
         push ax                          ;����ֱ��push continue,80386+
         
         retf                             ;ת�Ƶ������1����ִ�� 

SECTION data_1 align=16 vstart=0

    msg0 db '  This is NASM - the famous Netwide Assembler. '
         db 'Back at SourceForge and in intensive development! '
         db 'Get the current versions from http://www.nasm.us/.'
         db 0x0d,0x0a,0x0d,0x0a
         db '  Example code for calculate 1+2+...+1000:',0x0d,0x0a,0x0d,0x0a
         db '     xor dx,dx',0x0d,0x0a
         db '     xor ax,ax',0x0d,0x0a
         db '     xor cx,cx',0x0d,0x0a
         db '  @@:',0x0d,0x0a
         db '     inc cx',0x0d,0x0a
         db '     add ax,cx',0x0d,0x0a
         db '     adc dx,0',0x0d,0x0a
         db '     inc cx',0x0d,0x0a
         db '     cmp cx,1000',0x0d,0x0a
         db '     jle @@',0x0d,0x0a
         db '     ... ...(Some other codes)',0x0d,0x0a,0x0d,0x0a
         db 0

;===============================================================================
SECTION data_2 align=16 vstart=0

    msg1 db '  The above contents is written by LeeChung. '
         db '2011-05-06'
         db 0

;===============================================================================
SECTION stack align=16 vstart=0
           
         resb 256

stack_end:  

;===============================================================================
SECTION trail align=16
program_end: