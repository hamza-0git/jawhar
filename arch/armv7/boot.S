// ARMv7 bare-metal entry — U-Boot يمرر FDT في r2
.section .text
.global _start

_start:
    cpsid if
    mov r4, r2
    ldr sp, =__stack_top
1:  wfi
    b 1b
