
mov ax,0xb800
mov es,ax

mov byte [es:0x00], 'H'
mov byte [es:0x02], 'i'
mov byte [es:0x04], '!'


; 获取标号
mov ax, number
mov bx, 10

; 统一数据段/代码段
mov cx, cs
mov ds, cx

; 获取单个数字
mov dx, 0
div bx
mov [0x7c00+number+0x00], dl

; 转换为ASCII代码，并继续显示
mov al, [0x7c00+number+0x00]
add al, 0x30
mov [es:0x06], al
mov byte [es:0x08], 'D'



infi: jmp near infi

number db 0, 0, 0, 0, 0
times 445 db 0
db 0x55,0xaa