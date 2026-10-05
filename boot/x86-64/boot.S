# 16-bit Boot Sector — AT&T/GAS syntax
.section .text
.code16
.global _start

_start:
    # Setup stack and segments
    xorw %ax, %ax
    movw %ax, %ss
    movw $0x7C00, %sp
    movw %ax, %ds
    movw %ax, %es

    # Load kernel sectors (simplified)
    movw $0x8000, %bx        # Load address for kernel
    movb $0x02, %ah          # BIOS read sector
    movb $5, %al             # Read 5 sectors
    movb $0, %ch             # Cylinder 0
    movb $2, %cl             # Sector 2
    movb $0, %dh             # Head 0
    int $0x13                # Call BIOS

    # Jump to 32-bit protected mode code
    lgdt gdt_descriptor      # Load GDT
    movl %cr0, %eax
    orl $1, %eax
    movl %eax, %cr0
    ljmp $0x08, $protect32
.code32
protect32:
    # Setup 32-bit segments
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss

    # Enable PAE and Long Mode
    movl $0xC0000080, %ecx   # EFER MSR
    rdmsr
    orl $(1 << 8), %eax      # Set LME bit
    wrmsr

    # Set up page tables and enable paging
    # ... (paging setup code) ...
    movl %cr0, %eax
    orl $(1 << 31), %eax     # Enable paging
    movl %eax, %cr0

    # Jump to 64-bit code
    ljmp $0x08, $protect64

.code64
protect64:
    # 64-bit code here
    # Set up stack, load kernel, etc.
    cli
    hlt

# GDT Definition
.align 8
gdt_start:
gdt_null:
    .quad 0

gdt_code:
    .word 0xFFFF
    .word 0
    .byte 0
    .byte 0x9A               # Present, Ring 0, Code
    .byte 0xCF               # 4K pages, 32-bit D/B set
    .byte 0

gdt_data:
    .word 0xFFFF
    .word 0
    .byte 0
    .byte 0x92               # Present, Ring 0, Data
    .byte 0x0F
    .byte 0

gdt_descriptor:
    .word gdt_end - gdt_start - 1
    .long gdt_start

gdt_end:

# Pad to 512 bytes and add boot signature
.org 510, 0
.word 0xAA55
