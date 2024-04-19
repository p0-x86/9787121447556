```bash
brew install nasm bochs virtualbox
```

```bash
nasm -f bin exam.asm -o exam.bin
```

```bash
# 4MB = 4 * 1024 * 1024 = 4194816D = 0400200H
# 4194816 - 512 = 4194304

VBoxManage createmedium disk --filename demo --format VHD --variant Fixed --size 4
hexdump -s 4194304 -n 512 -C demo.vhd
```

```bash
dd if=mbr.bin of=c.img bs=512 count=1 seek=100 conv=notrunc
```

清除屏幕

```
; 将显示模式设置位文本模式，清除模式
mov ax, 3
int 0x10
```

自动断点

```
magic_break: enabled=1

xchg bx, bx
```

入口点

```
jmp 0x0000:0x7c00
; 0x07c0:0x0000
```

有效主引导扇区

```
; $: 当前位置汇编地址
; $$: 当前段的起始汇编地址
times 510 - ($ - $$) db 0

; 有效启动标识
						 db 0x55 0xAA
```

文本模式

```
0xB8000 ~ 0xBFFFF
ASCII: 0x30
显示属性: 前景色 / 背景色
0x0D: 回车
0x0A: 换行
```

无限循环

```
jmp $
; 进入低功耗模式
hlt
```


堆栈

```
SS:SP
PUSH / POP
```

无条件跳转

```
jmp
jmp far
```

过程调用

```
<ip>: call / ret
<cs:ip>: call far / retf
```

中断

```
int / iret
eflags、cs、ip
```

伪指令

```
times
equ
DB / DW / DD / DQ

```




### Bochs



* 单步执行: `s`
* 断点: `b`
* 持续执行: `c`
* 显示通用寄存器: `r`
* 显示段寄存器: `sreg`
* 显示内存的内容： `xp`
* 退出调试: `q`
* 越过循环体: `c`, 控制循环次数的是寄存器CX，它可以自动监视整个循环过程
* 反汇编: `u`
* 查看标志寄存器: `info eflags`

