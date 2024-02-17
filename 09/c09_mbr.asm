

    ; 用户程序位于硬盘上的什么位置，它的起始逻辑扇区号是多少
    app_lba_start equ 100

SECTION mbr align=16 vstart=0x7c00

    ; 初始化栈
    mov ax,0      
    mov ss,ax
    mov sp,ax

    ; 将物理地址变成16位的段地址
    mov ax,[cs:phy_base]              ; 0000
    mov dx,[cs:phy_base+0x02]         ; 0010
    mov bx,16
    div bx
    mov ds,ax                         ; 0x1000
    mov es,ax


    ; 读取用户程序最开始的512字节
    xor di,di
    mov si,app_lba_start
    xor bx,bx
    call read_hard_disk_0


    ; 第6章 除法计算 32位除以16位: `DX(高16位):AX(低16位)/被除数`、`[R|M]16(除数)`、`AX(商)`、`DX(余数)`
    mov dx,[2]
    mov ax,[0]
    mov bx,512
    div bx              ; 判断用户程序占用多少个扇区

    cmp dx,0            
    jnz @1              ; 判断是否除尽。
                        ; 如果没有除尽，则转移到后面的代码，去读取剩余代码

    dec ax              ; 如果除尽了，则总扇区数减1（已经预读了一个扇区）
  @1:
    ; 小于512字节，或者恰好等于512字节
    cmp ax, 0           ;
    jz direct           ; 用户程序已经读完

    ; 每次往内存中加载一个扇区前，都重新在前面的数据尾部构造一个新的逻辑段
    push ds
    mov cx,ax
  @2:
    mov ax,ds
    add ax,0x20
    mov ds,ax
    xor bx,bx
    inc si                ; 切换到下一个逻辑扇区
    call read_hard_disk_0
    loop @2

    pop ds
    ; 用户程序读取完毕

  direct:
    mov dx, [0x08]
    mov ax, [0x06]
    call calc_segment_base
    mov [0x06], ax        ; 入口点代码段重定位


    ; 段重定位表
    mov cx, [0x0a]
    mov bx, 0x0c

  realloc:
    mov dx, [bx+0x02]
    mov ax, [bx]
    call calc_segment_base
    mov [bx], ax
    add bx, 4
    loop realloc

    jmp far [0x04]

  


; 读取硬盘
read_hard_disk_0:             ;读取硬盘
                              ; DI:SI LBA地址
                              ; DS:BX 加载内存地址
    push ax
    push bx
    push cx
    push dx

    mov dx, 0x1f2             ; 每次读取一个扇区
    mov al, 0x01
    out dx, al

    inc dx                    ; 0x1f3
    mov ax, si
    out dx, al                ; 7~0

    inc dx                    ; 0x1f4
    mov al, ah
    out dx, al                ; 15~8

    inc dx                    ; 0x1f5
    mov ax, di
    out dx, al                ; 23-16

    inc dx                    ; 0x1f6
    mov al, 0xe0
    or al, ah
    out dx, al                ; 27-24

    inc dx                    ; 0x1f7
    mov al, 0x20
    out dx, al

    ; 反复从硬盘接口哪里取得512字节的数据

    pop dx
    pop cx
    pop bx
    pop ax

    ret

;-------------------------------------------------------------------------------
calc_segment_base:
                  ; DX:AX 32位汇编地址
                  ; AX 返回16位的段地址
  push dx
  add ax, [cs:phy_base]
  adc dx, [cs:phy_base+0X02]
  shr ax, 4
  ror dx, 4
  and dx 0xf000
  or ax, dx

  pop dx
  ret



  ; 加载用户程序需要确定一个内存物理地址
  phy_base dd 0x10000

  times 510-($-$$) db 0
                  db 0x55,0xaa