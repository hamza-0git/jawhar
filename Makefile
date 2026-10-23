CC = gcc
CPP = c++
FLACS = -I include/ -g -Wall -Wextra -c
all:
	$(CC) $(FLACS) -m32 boot/x86/boot.S -o obj/x86/boot.o
	$(CC) $(FLACS) -m32 driver/display/tty.c obj/x86/tty.o
