# 第 13 章 操作数和有效地址的尺寸


|本期版本|上期版本
|:---:|:---:|
`Fri Aug 23 10:44:10 CST 2024` | `Mon Apr 15 22:13:58 CST 2024`


## 13.2 INTEL 808286 处理器的16位保护模式

* **32位处理器的描述符格式是从80286进化来的**

<img src="./01.png" />


## 13.3 指令的操作尺寸

* 所谓**操作尺寸**，是指操作的`数据长度`及指令在访问内存时的`有效地址长度`

### 13.3.1 16位操作尺寸

* 16位操作尺寸意味着指令的操作数长度是8位或者16位的，有效地址长度是16位的

### 13.3.2 32位操作尺寸

* 32位操作尺寸意味着指令的操作数长度是8位或者32位的，有效地址长度是32位的

### 13.3.3 默认操作尺寸

<img src="./02.png" />

* 让16位操作尺寸的指令和32位操作尺寸的指令使用相同的编码

```
8B 50 02

mov dx, [bx + si + 0x02]
mov edx, [eax + 0x02]
```

* **32 位处理器上，指令如何解释和执行，取决于CS描述符高数缓存器中的D位**
* 在处理器刚加电的时候，它由处理器的固件设置位0
* 如果D位是0，则按照16位操作尺寸执行，使用指令指针寄存器IP
* 如果D位是1， 则按照32位操作尺寸执行，使用指令指针寄存器EIP


### 13.3.4 操作尺寸反转前缀

```
89 C8
```

```s
如果当前默认的操作尺寸是16位的，即，CS描述高速缓存器中的D位是0
mov ax, cx
```

```s
如果当前默认的操作尺寸是32位的，即，CS描述高速缓存器中的D位是1
mov eax, ecx
```

* **指令前缀 `0x66` 具有反转当前默认操作数大小的作用**


```
89 C8
mov ax, cx

66 89 C8
mov eax, ecx
```

* **前缀 `0x67` 则用来反转有效地址尺寸**

```
8B 50 02
mov dx, [bx + si + 0x02]

66 67 50 02

mov edx, [eax + 0x02]
```

### 13.3.5 编译时的操作尺寸

```
mov edx, [eax + 0x02]

8B 50 02
66 67 50 02
```

* 答案你必须知道！你是一个汇编语言程序员，是处理器的控制者，处理器在什么时候处于什么状态，你必须清楚，而且你最清楚
* `bits 16` 通知编译器，编译后面的指令时，应当假设处理器的默认操作尺寸是16位
* **可以放在方括号中，也可以没有方括号**



## 13.4 清空流水线并串行优化处理器

> 前面的指令虽然是用默认的 bits 16来编译的，和描述符中的说明不匹配，但是前面的代码已经执行过了，不会在执行，所以也就无所谓了

* 在保护模式下执行远转移指令将导致段寄存器CS被修改，同时CS描述符高速缓存器的内容要用描述符的内容刷新
* jmp指令的执行，导致处理器清空流水线
* CS描述符高速缓存器中的D位决定了处理器使用IP还是EIP来取指令和执行指令

## 13.5 有效地址尺寸和内存访问

* **当计算机启动时，处理器复位时，这个段界限会被预置成0XFFFF**


## 13.6 一般指令在32位操作尺寸下的扩展

```
; byte 仅仅是给编译器用的，告诉它，压入的是字节
push byte 0x55      ; 实际
push word 0xffb
push dword
```

