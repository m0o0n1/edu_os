[BITS 16]
[ORG 0x7C00]

jmp short _start
nop

bpb:
.oem: db "IGNORED "
.bytes_per_sector: dw 0x0200
.sectors_per_cluster: db 0x02
.number_of_reserved: dw 0x0002
.number_of_fats: db 0x02
.number_of_dir_entries: dw 0x0200
.numer_of_sectors_volume: dw 0x0000
.mdeia_decr_type: db 0xF8
.number_of_sectors_per_fat: dw 0x0080
.number_of_sectors_per_track: dw 0x0020
.number_of_heads: dw 0x0004
.number_of_hidden_sectors: dd 0x00000000
.large_sector_count: dd 0x00010000

ebr:
.drive_number: db 0x00
.nt_flag: db 0x00
.sig: db 0x29
.volume_id: dd 0xaaaa0bb0
.volume_label: db "OSCHKA     "
.sys_identifier: db "FAT16   "



_start:
    mov [ebr.drive_number], dl

    mov ah, 00h
    mov al, 03h
    int 10h

    


    jmp $


times 510 - ($ - $$) db 0x00
dw 0xaa55