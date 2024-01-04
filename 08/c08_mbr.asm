      jmp near start
  message db '1+2+3+...+100='
  start:
    mov ax, 0x7c0
    mov ds, ax

    mov ax, 0xb800
    mov es, ax

    ; 显示字符
    mov si, message
    mov di, 0
    mov cx, start-message
  @g:
      mov al, [si]
      mov [es:di], al
      inc di
      mov byte [es:di], 0x07
      inc di
      inc si
    loop @g

    ; 计算加法
    xor ax, ax
    mov cx, 1

    @f:
      add ax, cx
      inc cx
      cmp cx, 100
      jle @f

    ; 设置堆栈
    xor cx, cx
    mov ss, cx
    mov sp, cx

    ; 分解数字
    mov bx, 10
    xor cx, cx

    @d
      inc cx
      xor dx, dx
      div bx
      or dl, 0x30
      push dx
      cmp ax, 0
      jne @d


        jmp near $ 
       

times 510-($-$$) db 0
                 db 0x55,0xaa