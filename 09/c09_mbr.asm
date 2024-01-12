

    app_lba_start equ 100

SECTION mbr align=16 vstart=0x7c00

  ; 初始化段
  mov ax,0      
  mov ss,ax
  mov sp,ax

  ; 转换为逻辑地址
  mov ax,[cs:phy_base]
  mov dx,[cs:phy_base+0x02]
  mov bx,16
  div bx
  mov ds,ax
  mov es,ax


; 读取硬盘
; LBA: DI:SI
: DS:BX
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

    pop dx
    pop cx
    pop bx
    pop ax

    ret



  phy_base dd 0x10000

  times 510-($-$$) db 0
                  db 0x55,0xaa