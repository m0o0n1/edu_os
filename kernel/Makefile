K_DIR=$(realpath $(CURDIR))
BUILDDIR?=build

ASM?=nasm
LD_SCRIPT=$(K_DIR)/linker.ld
CC=i686-elf-gcc
CC_FLAGS=-ffreestanding -O2 -Wall -Wextra
LD=i686-elf-ld

TARGET=kernel.bin
OBJS=kernel.o kernel_asm.o

all: $(OBJS) $(LD_SCRIPT)
	$(LD) -T $(LD_SCRIPT) -o $(BUILDDIR)/$(TARGET) -nostdlib $(OBJS)

%.o:%.c
	$(CC) -c $< $(CC_FLAGS)
%.o:%.asm
	$(ASM) -felf $< -o $@

clean:
	rm -vf *.o
