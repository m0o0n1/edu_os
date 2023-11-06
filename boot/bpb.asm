%ifndef _BPB_ASM_
%define _BPB_ASM_

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

%endif
