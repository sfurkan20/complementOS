CINCLUDE=-Ikernel -Idrivers -Ilibc

# -g: Include debug information
# -m32: Compile for IA-32
# -ffreestanding: No standard library
# -nostdlib: No stdlib links by default
# -fno-builtin: Avoid compile-time replacements for stdlib functions
# -fno-pie: No position independent code (PIE), needed for IA-32
CFLAGS = -g -m32 -ffreestanding -nostdlib -fno-builtin -nostartfiles -nodefaultlibs -fno-pie -Wall -Werror -Wextra

ASM_SOURCES = $(wildcard kernel/*/*.asm)
ASM_OBJ = ${ASM_SOURCES:.asm=.o}

C_SOURCES = $(wildcard kernel/*.c drivers/*.c kernel/*/*.c drivers/*/*.c libc/*.c libc/*/*.c)
C_HEADERS = $(wildcard kernel/*.h drivers/*.h kernel/*/*.h drivers/*/*.h libc/*.h libc/*/*.h)
C_OBJ = ${C_SOURCES:.c=.o}

BIN = $(wildcard boot/*.bin boot/*.o kernel/*.bin kernel/*.o kernel/*/*.bin kernel/*/*.o drivers/*.bin drivers/*.o libc/*.o libc/*/*.o)
LINKER_SCRIPT = linker_settings.lds

GDB_ADDRESS = localhost:1234

# First, clean all possible binaries created before, then create the OS image
all: clean bin/image

# Run the OS
run: bin/image
	qemu-system-x86_64 -fda $<

# Create OS image
bin/image: bin/boot.bin bin/kernel.bin
	cat $^ > $@

# Create binary for boot sector
bin/boot.bin: boot/bootloader.asm
	mkdir -p bin
	nasm -i boot -f bin $< -o $@

# Create binary for kernel
bin/kernel.bin: kernel/kernel_entry.o ${C_OBJ} ${ASM_OBJ}
	ld -m elf_i386 -T $(LINKER_SCRIPT) -o $@ --oformat binary $^

# ELF object file generated for debugging purposes
bin/kernel.elf: kernel/kernel_entry.o ${C_OBJ} ${ASM_OBJ}
	ld -m elf_i386 -T $(LINKER_SCRIPT) -o $@ $^

# Generic - Assembly code to object file
%.o: %.asm
	nasm -f elf $^ -o $@

# Generic - C code to object file (Give kernel folder as include path)
%.o: %.c ${C_HEADERS}
	gcc $(CINCLUDE) $(CFLAGS) -c $< -o $@
	
# Generic - Assembly code to binary file
%.bin: %.asm
	nasm -f bin $^ -o $@

clean:
	rm -rf *.bin *.o *.dis
	rm -rf ${BIN}

# Disassemble OS image (for debugging)
image.dis: bin/image
	ndisasm -b 32 $< > $@
	
# Disassemble kernel binary (for debugging)
kernel.dis: bin/kernel.bin
	ndisasm -b 32 $< > $@

# Start QEMU, then GDB to debug
debug: debug_qemu debug_gdb

# Start QEMU held ready waiting for GDB (-S flag)
debug_qemu: bin/image
	qemu-system-x86_64 -S -fda $<

# Start GDB to debug
debug_gdb: bin/image bin/kernel.elf
	gdb -ex "target remote $(GDB_ADDRESS)" -ex "symbol-file bin/kernel.elf"