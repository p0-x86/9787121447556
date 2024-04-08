# 第 14 章 存储器的保护

|本期版本|上期版本
|:---:|:---:|
`Sun Apr  7 17:05:25 CST 2024` |


## 14.2 进入32位保护模式

### 14.2.2 创建GDT并安装段描述符

```s
pdgt dw 0
     dd 0x00007e00
```

* 在32位处理器上，即使是在实模式下，也可以使用32位寄存器
* 如果需要访问代码段内的数据，只能重新为该段安装一个新的描述符，并将其定义为可读可写的数据段


## 14.3 修改段寄存器时的保护


## 14.5 使用别名访问代码段对字符排序

> 主要演示如何在保护模式下使用别名段