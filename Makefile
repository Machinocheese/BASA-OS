# $@ = target
# $< = first dependency
# $^ = all dependencies

linker = /usr/local/i386elfgcc/bin/i386-elf-ld
gcc = /usr/local/i386elfgcc/bin/i386-elf-gcc
GDB = /usr/local/i386elfgcc/i386-elf-gdb
qemu = qemu-system-x86_64

all: run

#target     dependencies
kernel.bin: kernel_entry.o kernel.o
	$(linker) -o $@ -Ttext 0x1000 $^ --oformat binary

kernel_entry.o: boot/kernel_entry.asm
	nasm $< -f elf -o $@

kernel.o: kernel/kernel.c
	$(gcc) -ffreestanding -c $< -o $@

bootsect.bin: boot/bootsect.asm
	nasm $< -f bin -o $@

os-image.bin: bootsect.bin kernel.bin
	cat $^ > $@

run: os-image.bin
	$(qemu) -fda $<

debug: os-image.bin kernel.elf
	$(qemu) -fda $<
	$(GDB) -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"
		

clean:
	rm *.bin *.o
