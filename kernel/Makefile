all: kernel.o kernel_asm.o
	../../cross-compile/cross/bin/i686-elf-ld -T linker.ld -o kernel.bin -nostdlib kernel.o kernel_asm.o

%.o:%.c
	../../cross-compile/cross/bin/i686-elf-gcc -c $< -ffreestanding -O2 -Wall -Wextra
%.o:%.asm
	nasm -felf $< -o $@


clean: 
	rm -vf *.o *.bin