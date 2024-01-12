SECTION header vstart=0
    program_length  dd program_end    ; 大小 [0x00]

    code_entry    dw start            ; 偏移地址 [0x04]
                  dd section.code_1.start ; 段地址 [0x06]

    realloc_tbl_len dw (header_end - code_1_segment) / 4        ;[0x0a]

    code_1_segment  dd section.code_1.start ;[0x0c]
    code_2_segment  dd section.code_2.start ;[0x10]
    data_1_segment  dd section.data_1.start ;[0x14]
    data_2_segment  dd section.data_2.start ;[0x18]
    stack_segment   dd section.stack.start  ;[0x1c]

    header_end:

SECTION code_1 align=16 vstart=0

;---------------
start:

SECTION data


;===============================================================================
SECTION trail align=16
program_end: