ASM = boot.asm
BIN = boot.bin

all: $(BIN)

$(BIN): $(ASM)
	nasm -f bin $(ASM) -o $(BIN)

run: $(BIN)
	qemu-system-x86_64 -hda $(BIN)

clean:
	rm -f $(BIN)
