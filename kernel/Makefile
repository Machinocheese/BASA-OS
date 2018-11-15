# $@ = target
# $< = first dependency
# $^ = all dependencies

linker = /usr/local/i386elfgcc/bin/i386-elf-ld
gcc = /usr/local/i386elfgcc/bin/i386-elf-gcc
qemu = qemu-system-x86_64

all: run

#target     dependencies
kernel.bin: kernel_entry.o kernel.o
	$(linker) -o $@ -Ttext 0x1000 $^ --oformat binary

kernel_entry.o: kernel_entry.asm
	nasm $< -f elf -o $@

kernel.o: kernel.c
	$(gcc) -ffreestanding -c $< -o $@

bootsect.bin: bootsect.asm
	nasm $< -f bin -o $@

os-image.bin: bootsect.bin kernel.bin
	cat $^ > $@

run: os-image.bin
	$(qemu) -fda $<

clean:
	rm *.bin *.o
