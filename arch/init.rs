#![no_std]
#![no_main]

#[path = "mod.rs"]
mod arch;

#[path = "../drives/tty/tty.rs"]
mod tty;

#[path = "../lib/mem.rs"]
mod mem;

/// النوع الوحيد للمعامل الأول: ما يمرره boot.S.
/// x86/x86_64  → magic (في rdi/eax)، والثاني mbi (في rsi/ebx)
/// aarch64     → dtb_ptr (في x0)
/// نستخدم usize ونترك كل معمارية تفسّره.
#[no_mangle]
pub extern "C" fn gdt_init(a0: usize, a1: usize) -> ! {
    let _ = (a0, a1);   // معاملات Multiboot/DTB — تُستخدم لاحقًا

    arch::init();
    tty::init();
    tty::write_fmt(format_args!("jawhar\n"));

    arch::halt_forever();
}

#[panic_handler]
fn panic(_: &core::panic::PanicInfo) -> ! {
    arch::halt_forever();
}

#[no_mangle]
pub extern "C" fn rust_eh_personality() {}

