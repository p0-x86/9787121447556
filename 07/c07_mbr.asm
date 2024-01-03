

    jmp near start
mytext db 'L',0x07,'a',0x07,'b',0x07,'e',0x07,'l',0x07,' ',0x07,'o',0x07,\
          'f',0x07,'f',0x07,'s',0x07,'e',0x07,'t',0x07,':',0x07
number db 0,0,0,0,0

  start:
    mov ax, 0x7c0
    mov ds, ax

    mov ax, 0xb800
    mov es, ax

    cld

    ; DS:SI -> ES:DI
    mov si, mytext
    mov di, 0
    mov cx, (number-mytext)/2
    rep movsw

    ; 拆解数字
    mov ax, number  ; 获取标号地址

    mov bx, ax    ; 用于访问内存数据(写入后递增)
    mov cx, 5     ; 循环次数
    mov si, 10    ; 除数
  digit:
    xor dx, dx
    div si
    mov [bx], dl
    inc bx
    loop digit

    ; 显示数字
    mov bx, number
    mov si, 4

  show:
    mov al, [bx+si]   ; 获取最后一位数字
    add al, 0x30      ; 转化为ASCII编码
    mov ah, 0x04      ; 设置显示字符属性
    mov [es:di], ax   ; 送入内存
    add di, 2
    dec si
    jns show

    mov word [es:di], 0x744

    jmp near $

  times 510-($-$$) db 0
                   db 0x55,0xaa

