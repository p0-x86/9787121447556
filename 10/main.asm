SECTION mbr align=16 vstart=0x7c00
    ; 初始化栈
    mov ax,0      
    mov ss,ax
    mov sp,ax

    ; 清除屏幕
    mov ax, 3
    int 0x10

    mov cx

hlt

  message db 'Hello friend', 0x0d, 0x0a
  msg_end
  times 510-($-$$) db 0
                   db 0x55,0xaa
