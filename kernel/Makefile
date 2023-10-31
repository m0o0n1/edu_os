all:
	i686-elf-as kernel_asm.s -o kernel_asm.o
	i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	i686-elf-gcc -T linker.lnk -o kernel.bin -ffreestanding -O2 -nostdlib kernel_asm.o kernel.o -lgcc


clean: 
	rm -vf *.o *.bin