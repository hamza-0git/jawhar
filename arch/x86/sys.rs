#![no_std]
use core::arch::asm;

const SYS_syscall = 0;
const SYS_exit = 1;
const SYS_fork = 2;
const SYS_read = 3;
const SYS_write = 4;
const SYS_open = 5;
const SYS_close = 6;
const SYS_wait4 = 7;

const SYS_link = 9;
const SYS_unlink = 10
mod sys {
    pub fn call(num: u32) {
		if (num == SYS_syscall) {
            asm!("movl eax, $0",
                           out("eax") _,
                           options(att_syntax),
            );
        } else if (num == SYS_exit) {
            asm("movl eax, $1",
                out("eax") _,
                options(att_syntax),
            );
            
        
        }
    }
}
