PROJDIR=$(realpath $(CURDIR))
BUILDDIR=$(PROJDIR)/build

BOOTLOADER_SRC_DIR=$(PROJDIR)/boot
KERNEL_SRC_DIR=$(PROJDIR)/kernel

TARGET=os.bin
ASM=nasm
CC=i686-elf-gcc

FS=mkfs.fat
FS_FLAGS=-s 1 -S 512 -F 16
all: always $(BUILDDIR)/$(TARGET) clean

always:
ifeq ($(wildcard $(BUILDDIR)),)
	mkdir $(BUILDDIR)
endif


$(BUILDDIR)/$(TARGET): $(BUILDDIR)/bootloader.bin $(BUILDDIR)/kernel.bin
	dd if=/dev/zero of=$(BUILDDIR)/$(TARGET) bs=512 count=5900
	mkfs.fat -s 1 -S 512 -F 16 $(BUILDDIR)/$(TARGET)
	dd if=$(BUILDDIR)/bootloader.bin of=$(BUILDDIR)/$(TARGET) conv=notrunc
	mcopy -i $(BUILDDIR)/$(TARGET) $(BUILDDIR)/kernel.bin "::kernel.bin"

$(BUILDDIR)/bootloader.bin: $(PROJDIR)/boot/boot.asm
	cd $(BOOTLOADER_SRC_DIR); make BUILDDIR=$(BUILDDIR)
$(BUILDDIR)/kernel.bin:
	cd $(KERNEL_SRC_DIR); make BUILDDIR=$(BUILDDIR)

qemu:
	qemu-system-i386 -fda $(BUILDDIR)/$(TARGET) -display curses -S -s

gdb: 	
		gdb -ex 'target remote localhost:1234' \
		-ex 'set architecture i8086' \
		-ex 'set disassembly-flavor intel' \
		-ex 'break *0x7c42' \
		-ex 'continue'	

clean:
	find $(BUILDDIR)/ ! -name $(TARGET) -type f -exec rm -f {} +
	cd $(KERNEL_SRC_DIR); make clean
