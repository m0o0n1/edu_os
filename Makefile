PROJDIR=$(realpath $(CURDIR))
BUILDDIR=$(PROJDIR)/build

TARGET=os.bin
ASM=nasm
CC=i686-elf-gcc

all: $(BUILDDIR)/$(TARGET) clean

$(BUILDDIR)/$(TARGET): $(BUILDDIR)/bootloader.bin
	dd if=/dev/zero of=$(BUILDDIR)/$(TARGET) bs=512 count=5900
	mkfs.fat -s 1 -S 512 -F 16 $(BUILDDIR)/$(TARGET)
	dd if=$(BUILDDIR)/bootloader.bin of=$(BUILDDIR)/$(TARGET) conv=notrunc
	mcopy -i $(BUILDDIR)/$(TARGET) kernel/kernel.bin "::kernel.bin"

$(BUILDDIR)/bootloader.bin: $(PROJDIR)/boot/boot.asm
	$(ASM) -f bin $(PROJDIR)/boot/boot.asm -o $(BUILDDIR)/bootloader.bin

qemu:
	qemu-system-i386 -fda $(BUILDDIR)/$(TARGET) -display curses -S -s

gdb: 	
		gdb -ex 'target remote localhost:1234' \
		-ex 'set architecture i8086' \
		-ex 'set disassembly-flavor intel' \
		-ex 'break *0x7d11' \
		-ex 'break *0x7cf1' \
		-ex 'continue'	

clean:
	find $(BUILDDIR)/ ! -name $(TARGET) -type f -exec rm -f {} +
