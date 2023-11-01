

section .text
    global _start
    extern kmain

_start:
    mov ax, ds
    mov ss, ax
    mov sp, 0
    mov bp, sp

    call kmain

    jmp $   ; should never happen


    






