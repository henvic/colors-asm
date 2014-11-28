disk=build/disk.img

build: clean compile dist

compile:
	nasm boot1.asm -o build/boot1.bin
	nasm boot2.asm -o build/boot2.bin
	nasm kernel.asm -o build/kernel.bin

dist:
	dd if=/dev/zero of=$(disk) bs=512 count=100
	dd if=build/boot1.bin of=$(disk) bs=512 count=1 conv=notrunc
	dd if=build/boot2.bin of=$(disk) bs=512 seek=1 count=512 conv=notrunc
	dd if=build/kernel.bin of=$(disk) bs=512 seek=2 count=1024 conv=notrunc

hexdump:
	hexdump $(disk)

run:
	qemu-system-i386 -fda $(disk)

clean:
	touch build
	rm -r build
	mkdir build
