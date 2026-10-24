# -----------------------------------------------------------------------------
# x86_64 Multiboot entry, pure assembly (AT&T/GAS)
# يدخل الوضع الطويل 64-بت ثم يتوقف. لا طباعة، لا C.
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
.align 4096
pml4:           .skip 4096
pdpt:           .skip 4096
pd:             .skip 4096
.align 16
stack_bottom:   .skip 16384
stack_top:

# --------------------------- 32-bit entry ------------------------------------
.section .text
.code32
.global _start
_start:
    cli
    movl $stack_top, %esp
    movl %esp, %ebp

    # --- PML4[0] -> PDPT ---
    movl $pdpt, %eax
    orl  $0x03, %eax                # present | writable
    movl %eax, pml4

    # --- PDPT[0] -> PD ---
    movl $pd, %eax
    orl  $0x03, %eax
    movl %eax, pdpt

    # --- PD: identity-map first 1 GiB with 2 MiB pages ---
    movl $pd, %edi
    movl $0x00000083, %eax          # present | writable | PS
    movl $512, %ecx
1:
    movl %eax, (%edi)
    addl $0x200000, %eax
    addl $8, %edi
    loop 1b

    # Load PML4
    movl $pml4, %eax
    movl %eax, %cr3

    # Enable PAE (CR4.PAE)
    movl %cr4, %eax
    orl  $(1 << 5), %eax
    movl %eax, %cr4

    # Set LME in EFER
    movl $0xC0000080, %ecx
    rdmsr
    orl  $(1 << 8), %eax
    wrmsr

    # Enable paging (CR0.PG)
    movl %cr0, %eax
    orl  $(1 << 31), %eax
    movl %eax, %cr0

    # Load 64-bit GDT and far-jump into long mode
    lgdt gdt64_desc
    ljmp $0x08, $long_mode

# --------------------------- 64-bit long mode --------------------------------
.code64
long_mode:
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw %ax, %fs
    movw %ax, %gs

    movq $stack_top, %rsp
    movq %rsp, %rbp
    leaq stack_top(%rip), %rsp
    movq %rsp, %rbp

    # 3. صفّر .bss — إلزامي قبل أي كود Rust/C
    leaq __bss_start(%rip), %rdi
    leaq __bss_end(%rip),   %rcx
    subq %rdi, %rcx
    xorl %eax, %eax
    rep stosb

    # 4. (اختياري) إعادة تحميل GDT من Rust — يُفيد فقط لو أضفت TSS
    # call gdt_init

    # 5. مرّر معاملات Multiboot واستدعِ النواة
    movl mb_magic(%rip), %edi     # arg0
    movl mb_info(%rip),  %esi     # arg1
    call gdt_init
    sti
    call tty

    # لا شيء آخر: توقف نهائي
1:  cli
    hlt
    jmp 1b

# --------------------------- Read-only data ----------------------------------
.section .rodata
.align 8
gdt64:
    .quad 0x0000000000000000        # 0x00 null
    .quad 0x00AF9A000000FFFF        # 0x08 64-bit code (L=1)
    .quad 0x00AF92000000FFFF        # 0x10 64-bit data
gdt64_desc:
    .word gdt64_desc - gdt64 - 1
    .quad gdt64
