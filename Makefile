<<<<<<< HEAD
CC      = cc
RS      = rustc 
=======

CC      = cc
RS      = rustc
>>>>>>> 486f358bbb33ed39490d4ffa33cb9ba917f4355c
ASFLAGS = -g -Wall -Wextra -c
RSFLAGS = --emit=obj \
          -W unused \
          -W unreachable-pub \
          -W missing-debug-implementations \
          -C debuginfo=2

all:
<<<<<<< HEAD
	mkdir -p obj/x86
	$(CC) $(ASFLAGS) -m32 arch/x86/boot.S -o obj/x86/boot.o
	$(RS) $(RSFLAGS) --target i686-unknown-linux-gnu drives/tty/main.rs -o obj/x86/tty.o

clean:
	rm -f obj/x86/*.o
=======
        mkdir -p obj/x86
        $(CC) $(ASFLAGS) -m32 arch/x86/boot.S -o obj/x86/boot.o
        $(RS) $(RSFLAGS) --target i686-unknown-linux-gnu drives/tty/main.rs -o obj/x86/tty.o

clean:
        rm -f obj/x86/*.o
>>>>>>> 486f358bbb33ed39490d4ffa33cb9ba917f4355c
