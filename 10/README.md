## 9.2 内部中断

### 9.3.1 BIOS 中断

* 最有名的软中断是 BIOS 中断, 之所以称为 BIOS 中断，是因为这些中断功能是在计算机加电之后，BIOS程序执行期间建立的


## Ref

* [操作系统真象还原 学习笔记08--中断](https://www.kn0sky.com/?p=47)

### [131 启用更新周期结束中断](https://study.163.com/course/courseLearn.htm?courseId=1209670804#/learn/video?lessonId=1280833423&courseId=1209670804)

<img src="./01.png" />

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

