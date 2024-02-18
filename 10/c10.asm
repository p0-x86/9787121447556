
  mov al, 0x70
  mov bl, 4
  mul bl
  mov bx, ax            ; 计算 0x70 号中断在IVT中的偏移