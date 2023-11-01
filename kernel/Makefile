all: kernel.o stdio.o x86_video.obj kernel.obj
	../../cross-compile/cross/bin/i686-elf-gcc -T linker.ld -o kernel.bin -ffreestanding -O2 -nostdlib kernel.o stdio.o x86_video.obj -lgcc kernel.obj

%.o:%.c
	../../cross-compile/cross/bin/i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

%.obj:%.asm
	nasm -felf32 -w+gnu-elf-extensions $< -o $@


clean: 
	rm -vf *.o *.bin *.obj