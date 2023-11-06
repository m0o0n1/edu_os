%ifndef _DISK_ROUTINE_ASM_
%define _DISK_ROUTINE_ASM_

floppy_error_msg: db "[ERROR]. Press a key to reboot."

%include "bpb.asm"
%include "ebr.asm"
%include "io.asm"
; Function lba_to_chs converts ax (lba address) to chs
; in: 	ax - lba
; out: 	ch - low eight bits of cylinder number
;	cl - sector number 1-63 (bits 0-5)
;	dh - head number
lba_to_chs:
    push ax
    push dx

    xor dx, dx
    div word [bpb.sectors_per_track]
    inc dx

    mov cx, dx
    
    xor dx, dx
    div word [bpb.number_of_heads]
 
    mov dh, dl
    mov ch, al
    shl ah, 6
    or cl, ah

    pop ax
    mov dl, al
    pop ax
    ret	

; Function disk_read reads cx sectors of drive dl starting from ax to the buffer
; es:bx
; in:	ax - lba
;	cx - number of sectors to read
;	dl - drive_number
;	es:bx - data buffer
disk_read:
    pusha
    push cx

    call lba_to_chs
    stc
	
    pop ax
    mov ah, 02h
    int 13h
    jc .carry_happened

    popa
    ret
.carry_happened:
    popa
; Procedure floppy_error should be called if there was a disk error
floppy_error:
    mov cx, 0x1f
    mov bp, floppy_error_msg
    call puts

    call wait_keystroke

    jmp 0ffffh:00h	; reboot


%endif
