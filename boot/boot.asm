[BITS 16]
[ORG 0x7C00]

jmp short _start
nop

bpb:
.oem: db "IGNORED "
.bytes_per_sector: dw 0x0200
.sectors_per_cluster: db 0x01
.number_of_reserved: dw 0x0001
.number_of_fats: db 0x02
.number_of_dir_entries: dw 0x0200
.sectors_per_volume: dw 0x1660
.media_descr_type: db 0xF8
.sectors_per_fat: dw 0x0017
.sectors_per_track: dw 0x0020
.number_of_heads: dw 0x0002
.number_of_hidden_sectors: dd 0x00
.large_sector_count: dd 0x00

ebr:
.drive_number: db 0x00
.nt_flag: db 0x00
.sig: db 0x29
.volume_id: dd 0xaaaa0bb0
.volume_label: db "OSCHKA     "
.sys_identifier: db "FAT16   "



root_dir_lba: dw 0x00
data_lba: dw 0x00

_start:
    mov [ebr.drive_number], dl

    mov ah, 00h
    mov al, 03h
    int 10h

    mov ah, 013h
    mov al, 01h 
    xor bx, bx
    mov cx, 12  ; 12 -- size of the message to print
    xor dx, dx
    mov bp, boot_msg
    int 010h

    xor ax, ax
    mov es, ax
    mov ds, ax

    mov ax, [bpb.number_of_fats]
    mul word [bpb.sectors_per_fat]
    add ax, [bpb.number_of_hidden_sectors]
    add ax, [bpb.number_of_reserved]
    mov [root_dir_lba], ax

    mov ax, 0x20
    mul word [bpb.number_of_dir_entries]
    mov bx, [bpb.bytes_per_sector]
    add ax, bx
    ;dec ax
    div bx
    
    add ax, word [root_dir_lba]
    mov [data_lba], ax

    mov ax, [bpb.sectors_per_fat]
    mul word [bpb.number_of_fats]
    mov cx, [bpb.number_of_reserved]
    xchg cx, ax
    mov bx, 0x500
    mov dl, byte [ebr.drive_number]
    call disk_read

    jmp $

; in
;   ax - lba
; out
;   CH = low eight bits of cylinder number
;   CL = sector number 1-63 (bits 0-5)
;   DH = head number
lba_to_chs:
    push ax
    push dx

    xor dx, dx
    div word [bpb.sectors_per_track] ; ax = lba / spt
    inc dx                      ; dx = lba % spt + 1    = sector

    mov cx, dx

    xor dx, dx
    div word [bpb.number_of_heads]   ; ax = cylinder, dx = head

    mov dh, dl
    mov ch, al
    shl ah, 6
    or cl, ah

    pop ax
    mov dl, al
    pop ax
    ret


; in
;   ax - lba
;   cx - number of sectors to read
;   dl - drive number
;   es:bx - data buffer
; out
;   carry flag is set on error
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
error_happened:
    mov ah, 013h
    mov al, 01h 
    xor bx, bx
    mov cx, 03fh
    xor dx, dx
    mov bp, error_msg
    int 010h

    mov ah, 00h
    int 016h

    jmp 0ffffh:00h

boot_msg: db "Booting...", 0x0a, 0x0d
error_msg:  db "There was an error. Check your drive and press a key to reboot."
sys_files: db "IO      SYSKERNEL  SYS"
times 510 - ($ - $$) db 0x00
dw 0xaa55