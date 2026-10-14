FLACS64 = -I ./include -nostdinc -nostdlib -static -Wall -Wextra -m64 -g -c
FLACS32 = -I ./include -nostdinc -nostdlib -static -Wall -Wextra -m32 -g -c
ARM7 = -march=armv7-a -I ./include -nostdinc -nostdlib -static -Wall -Wextra -g -c
ARM8 = -march=armv8-a -I ./include -nostdinc -nostdlib -static -Wall -Wextra -g -c
CC = gcc


all:
	mkdir -p obj
	$(CC) $(FLACS64) boot/x86-64/boot.S -o obj/x86-64.o
	$(CC) $(FLACS32) boot/x86/boot.S -o obj/x86.o
	$(CC) $(ARM7) boot/armv7/boot.S -o obj/armv7.o
	$(CC) $(ARM8) boot/aarch64/boot.S -o obj/aarch64.o



remove:
	rm -rf obj/*
