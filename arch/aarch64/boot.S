// AArch64 Limine/U-Boot entry — x0 = DTB ptr, x1 = 0
.section .text
.global _start
_start:
    // اقرأ x0 (DTB) واحفظه في x19 قبل ضبط المكدس
    mov x19, x0
    mov x20, x1

    // اضبط المكدس
    adrp x0, stack_top
    add  x0, x0, :lo12:stack_top
    mov  sp, x0

    // استدعِ kernel_main(a0, a1)
    mov x0, x19
    mov x1, x20
    bl  gdt_init
    bl tty

1:  wfe
    b   1b

.section .bss
.align 16
stack_bottom: .skip 16384
stack_top:
