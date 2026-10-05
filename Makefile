FLACS = -I ./include -nostdinc -nostdlib -static -Wall -Wextra --target=x86_64-unknown-linux-gnu -c
CC = clang


all: $(OUT)
	$(CC) $(FLACS) driver/tty/tty.c -o build/tty.o
	$(CC) $(FLACS) driver/tty/keyboard.c -o build/keyboard.o
	$(CC) $(FLACS) boot/x86-64/boot.S -o build/boot.o



remove:
	rm -rf $(BUILD)
	rm -rf $(OUT)
