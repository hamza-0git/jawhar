FLACS = -I ./include -nostdinc -nostdlib -static -Wall -Wextra -m64 -g -c
CC = gcc


all: $(OUT)
	$(CC) $(FLACS) boot/x86-64/boot.S -o build/x86-64.o
	$(CC) $(FLACS) boot/x86/boot.S -o build/x86.o



remove:
	rm -rf $(BUILD)
	rm -rf $(OUT)
