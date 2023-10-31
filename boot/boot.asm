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
.sectors_per_volume: dw 5900
.media_descr_type: db 0xF8
.sectors_per_fat: dw 0x0017
.sectors_per_track: dw 0x24
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

    push es
    mov ah, 08h
    int 13h
    jc error_happened
    pop es

    and cl, 03fh
    xor ch, ch
    mov [bpb.sectors_per_track], cx;

    inc dh
    mov [bpb.number_of_heads], dh

    mov ah, 00h
    mov al, 03h
    int 10h

    mov ah, 013h
    mov al, 01h 
    xor bx, bx
    mov cx, 12
    xor dx, dx
    mov bp, boot_msg
    int 010h

    xor ax, ax
    mov es, ax
    mov ds, ax

    ; load FAT at 0x00:0x500
    mov ax, [bpb.sectors_per_fat]
    mul word [bpb.number_of_fats]

    mov cx, [bpb.number_of_reserved]
    xchg cx, ax
    mov bx, [fat_address]
    mov dl, byte [ebr.drive_number]
    call disk_read

    ; calculate root_dir entry sector (lba)
    mov ax, [bpb.number_of_fats]
    mov bx, [bpb.sectors_per_fat]
    mul bx

    add ax, [bpb.number_of_reserved]
    push ax

    ; how many sectors occupied by root_dir
    mov ax, [bpb.number_of_dir_entries]
    shl ax, 5
    xor dx, dx
    div word [bpb.bytes_per_sector]
    test dx, dx
    jz .root_dir_load

    inc ax

    xor cx, cx
.root_dir_load:
    mov cl, al  ; cl -- sectors to read

    pop ax      ; ax -- lba of root_dir
    mov bx, ax
    add bx, cx
    mov [data_lba], bx
    mov bx, [rd_address]
    mov dl, [ebr.drive_number]
    call disk_read

.find_kernel:
    mov di, [rd_address]

.find_kernel_loop:
    mov si, sys_files
    mov cx, 11
    push di
    repe cmpsb
    pop di
    je .found_kernel

    add di, 32
    jmp .find_kernel_loop   ; out of dir entries mb


.found_kernel:
    mov ax, [di + 26]

    mov bx, kernel_load_segment
    mov es, bx
    mov bx, kernel_load_offset


.load_kernel_loop:
    xor cx, cx
    sub ax, 2
    mov [previous_cluster], ax
    add ax, [data_lba]

    mov cl, 1
    mov dl, [ebr.drive_number]
    call disk_read

    add bx, [bpb.bytes_per_sector]
    push bx
    
    mov bx, [fat_address]
    mov cx, [previous_cluster]
    shl cx, 1
    add cx, 4
    add bx, cx
    mov ax, [bx]
    pop bx

    cmp ax, 0xFFFE      ; i hecked this shit aga
    jg .loaded
    
    jmp .load_kernel_loop

.loaded:
    mov dx, kernel_load_segment
    mov es, dx
    mov ds, dx

    jmp kernel_load_segment:kernel_load_offset

    nop
    nop
    nop
    nop
    nop

    jmp error_happened

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

fat_address: dw 0x500
rd_address: dw 0x7e00
boot_msg: db "Booting...", 0x0a, 0x0d
error_msg:  db "There was an error. Check your drive and press a key to reboot."
sys_files: db "KERNEL  BIN"
previous_cluster: dw 0x0000

kernel_load_segment equ 0x1000
kernel_load_offset  equ 0x0000
times 510 - ($ - $$) db 0x00
dw 0xaa55