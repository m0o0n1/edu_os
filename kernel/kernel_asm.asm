[bits 32]

section .text
    global _start_pre_main
    extern kmain

_start_pre_main:
  
    call kmain

    jmp $  
    






