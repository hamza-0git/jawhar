CC      = cc
RS      = rustc
ASFLAGS = -g -Wall -Wextra -c
RSFLAGS = --emit=obj \
          -W unused \
          -W unreachable-pub \
          -W missing-debug-implementations \
          -C debuginfo=2

all:
	mkdir -p obj/x86
	$(CC) $(ASFLAGS) -m32 arch/x86/boot.S -o obj/x86/boot.o
	$(RS) $(RSFLAGS) --target i686-unknown-linux-gnu drives/tty/main.rs -o obj/x86/tty.o

clean:
<<<<<<< HEAD
	rm -f obj/x86/*.o
        $(CC) $(ASFLAGS) -m32 arch/x86/boot.S -o obj/x86/boot.o
        $(RS) $(RSFLAGS) --target i686-unknown-linux-gnu drives/tty/main.rs -o obj/x86/tty.o
        rm -f obj/x86/*.o

=======
	    rm -f obj/*

        
        rm -f obj/x86/*.o
>>>>>>> 058e542220ffb80fe99f8fefb4b265dfb9c05aca
