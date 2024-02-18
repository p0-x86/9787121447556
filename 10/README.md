### [131 启用更新周期结束中断](https://study.163.com/course/courseLearn.htm?courseId=1209670804#/learn/video?lessonId=1280833423&courseId=1209670804)

<img src="./01.png" />


# 第 10 章 中断和动态时钟显示

## 10.1 外部硬件中断

### 10.1.2 可屏蔽中断

* 中断屏蔽寄存器(Interrupt Mask Register, IMR), 这是8位寄存器，对应着该芯片的8个中断输入引脚，0表示允许，1表示阻断
* 主片的端口是 `0x20` 和 `0x21`，从片的端口是 `0xa0 和0xa1`

**中断标志(Interrupt Flag)** 

* 0: 忽略 / `cli`
* 1: 接受 / `sti`


###  10.1.3 实模式下的中断向量表


* 中断向量表（Interrupt Vector Table， IVT）: 从物理地址`0x00000`开始到 `0x003ff`结束，共 1KB的空间
* 每个中断在中断向量表中占 2 个字，分别是中断处理程序的偏移地址和逻辑段地址

**1 - 保护断点的现场**

* 标志寄存器 FLAGS 压栈, 然后清楚它的IF位和TF位
* 再将 CS 和 IP 压栈

**2 - 执行中断程序**

* 中断号**乘4获**取中断向量表偏移地址
* 从向量表中获取偏移地址和段地址, 并分别传送到IP和CS

**3 - 返回断点接着执行**

* 最后一条指令必须是中断返回指令 `iret` (从栈中弹出: IP、CS、FLAGS)


### 10.1.4 实时时钟、CMOS RAM 和 BCD编码


## 9.2 内部中断

### 9.3.1 BIOS 中断

* 最有名的软中断是 BIOS 中断, 之所以称为 BIOS 中断，是因为这些中断功能是在计算机加电之后，BIOS程序执行期间建立的


## Ref

* [操作系统真象还原 学习笔记08--中断](https://www.kn0sky.com/?p=47)



### [14 外中断和时钟](https://www.bilibili.com/video/BV1b44y1k7mT?p=14)

端口 | 说明 | 标记
---|---|---
0x20 | 主 PIC 命令端口 | PIC\_M\_CMD
0x21 | 主 PIC 数据端口 | PIC\_M\_DATA
0xA0 | 从 PIC 命令端口 | PIC\_S\_CMD
0xA1 | 从 PIC 数据端口 | PIC\_S\_DATA

**寄存器**

* ICW1 ~ ICW4 用于初始化 8259 initialization Command Words
* OCW1 ~ OCW3 用于操作 Operation Command Words

```nasm
mov al, 0b1111_1110
out PIC_M_DATA, al

mov al, 0x20
out PIC_M_CMD, al
```

**操作步骤**

* 向 `OCW1` 写入屏蔽字，打开时钟中断
* sti 设置 cpu 允许外中断
*  向 `OCW2` 写入 `0x20` ，表示中断处理完毕

