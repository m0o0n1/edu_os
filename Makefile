PROJDIR=$(realpath $(CURDIR))
BUILDDIR=$(PROJDIR)/build

TARGET=os.bin
ASM=nasm
CC=i686-elf-gcc

all: $(TARGET) clean

$(TARGET): $(BUILDDIR)/bootloader.bin
	dd if=/dev/zero of=$(BUILDDIR)/$(TARGET) bs=512 count=65536
	mkfs.fat -s 2 -S 512 -F 16 $(BUILDDIR)/$(TARGET)
	dd if=$(BUILDDIR)/bootloader.bin of=$(BUILDDIR)/$(TARGET) conv=notrunc

$(BUILDDIR)/bootloader.bin: $(PROJDIR)/boot/boot.asm
	$(ASM) -f bin $(PROJDIR)/boot/boot.asm -o $(BUILDDIR)/bootloader.bin

clean:
	find $(BUILDDIR)/ ! -name $(TARGET) -type f -exec rm -f {} +