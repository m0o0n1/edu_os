[bits 16]


global x86_Video_Teletype_Print_Char

x86_Video_Teletype_Print_Char:
    push bp
    mov bp, sp


    mov ah, 0eh
    mov al, [bp + 4]
    int 10h

    mov sp, bp
    pop bp
    ret