# -----------------------------------------------------------------------------
# Multiboot x86 (32-bit) entry, pure assembly (AT&T/GAS)
# GRUB enters here already in 32-bit protected mode with A20 on.
# No paging, no long mode, no printing. Just set up and halt.
# -----------------------------------------------------------------------------

# --------------------------- Multiboot header --------------------------------
.set MB_MAGIC,    0x1BADB002
.set MB_FLAGS,    0x00000003        # align modules + memory info
.set MB_CHECKSUM, -(MB_MAGIC + MB_FLAGS)

.section .multiboot, "a"
.align 4
mb_header:
    .long MB_MAGIC
    .long MB_FLAGS
    .long MB_CHECKSUM

# --------------------------- Writable data -----------------------------------
.section .bss
.align 16
stack_bottom:   .skip 16384
stack_top:

# --------------------------- 32-bit entry ------------------------------------
.section .text
.code32
.global _start
_start:
    cli

    # Set up our own GDT (GRUB's may not be what we want)
    lgdt gdt_desc

    # Reload segment registers with our data selector
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss

    # Far-jump to reload CS with our code selector
    ljmp $0x08, $reload_cs
    call tty

reload_cs:
    # Set up stack
    movl $stack_top, %esp
    movl %esp, %ebp

    # Done: halt forever
1:  cli
    hlt
    jmp 1b

# --------------------------- GDT (32-bit) ------------------------------------
.section .rodata
.align 8
gdt:
    .quad 0x0000000000000000        # 0x00 null

    # 0x08: 32-bit code, ring 0
    # base=0, limit=0xFFFFF, access=0x9A, flags=0xCF (4K gran, 32-bit)
    .word 0xFFFF
    .word 0x0000
    .byte 0x00
    .byte 0x9A
    .byte 0xCF
    .byte 0x00

    # 0x10: 32-bit data, ring 0
    .word 0xFFFF
    .word 0x0000
    .byte 0x00
    .byte 0x92
    .byte 0xCF
    .byte 0x00

gdt_desc:
    .word gdt_desc - gdt - 1
    .long gdt
