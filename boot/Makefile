ASM?=nasm
BUILDDIR?=build
TARGET=bootloader.bin
ASMFLAGS=-fbin

all: boot.asm
	$(ASM) $(ASMFLAGS) boot.asm -o $(BUILDDIR)/$(TARGET)
