#![allow(dead_code)]

#[cfg(target_arch = "x86_64")]
#[path = "x86-64/mod.rs"]
pub mod x86_64;

#[cfg(target_arch = "x86")]
pub mod x86;

#[cfg(target_arch = "aarch64")]
pub mod aarch64;

/// يُستدعى من kernel_main() مرة واحدة في بداية النواة.
/// كل معمارية تنفّذ ما يناسبها:
///   - x86_64/x86 → gdt::init()
///   - aarch64    → mmu::init()  (لا يوجد GDT)
pub fn init() {
    #[cfg(target_arch = "x86_64")]
    x86_64::init();

    #[cfg(target_arch = "x86")]
    x86::init();

    #[cfg(target_arch = "aarch64")]
    aarch64::init();
}

pub fn halt_forever() -> ! {
    loop {
        #[cfg(any(target_arch = "x86_64", target_arch = "x86"))]
        unsafe { core::arch::asm!("cli; hlt", options(nostack)); }

        #[cfg(target_arch = "aarch64")]
        unsafe { core::arch::asm!("wfe", options(nostack)); }
    }
}
