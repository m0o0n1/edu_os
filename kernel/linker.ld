ENTRY(_start_pre_main)
OUTPUT_FORMAT(binary)
OUTPUT(kernel.bin)

SECTIONS
{
    . = 0x10000;
    .text.start(0x10000) : {
        kernel_asm.o(.text)
    }
    .text : ALIGN(4K) {
        _TEXT_START_ = .;
        *(.text)
        _TEXT_END_ = .;
    }
    .data : ALIGN(4K) {
        _DATA_START_ = .;
        *(.data)
        _DATA_END_ = .;
    }

  .bss : ALIGN(4K) {
        _BSS_START_ = .;
        *(.bss)
        _BSS_END_ = .;
    }
}