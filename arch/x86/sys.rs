
#![no_std]
use core::arch::asm;
/*
 * syscall = 0
 * open = 2
 * fork = 3
 * close = 4
 * exit = 5
 * read = 6
 * write = 7
 * execute = 8
 * wait = 9
 * link = 10
 * unlink = 11
 */
mod call {
    pub fn open(name: String)
    {
		asm(
            "movw $2, eax",
            out("eax") _,
        );
            
    }
}
