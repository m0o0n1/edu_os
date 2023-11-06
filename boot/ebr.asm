%ifndef _EBR_ASM_
%define _EBR_ASM_

ebr:
.drive_number: db 0x00
.nt_flag: db 0x00
.sig: db 0x29
.volume_id: dd 0xaaaa0bb0
.volume_label: db "OSCHKA     "
.sys_identifier: db "FAT16   "

%endif
