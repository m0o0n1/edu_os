%ifndef _IO_ASM_
%define _IO_ASM_

; Function puts prints string
; in: 	bp - string to be printed
;	cx - length of string
puts:
    pusha

    mov ah, 013h
    mov al, 01h
    xor bx, bx
    xor dx, dx
    int 010h

    popa
    ret

; Function wait_keystroke wait until user push a key
wait_keystroke:
    pusha	

    mov ah, 00h
    int 016h

    popa 
    ret

%endif
