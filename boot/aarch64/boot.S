// aarch64 bare-metal entry — يستقبل FDT في x0
.section .text
.global _start

_start:
    msr daifset, #0xf
    mov x19, x0
    ldr x0, =__stack_top
    mov sp, x0
0:  wfi
    b 1b
