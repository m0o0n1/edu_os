[bits 16]

section .text
    global _start_pre_main
    extern kmain

_start_pre_main:
    mov ah, 00h
    mov al, 03h
    int 10h

    call kmain

    jmp $  
    






