use core::arch::asm;

/// aarch64 لا يحتوي GDT. التهيئة المعمارية تكافئ:
/// - ضبط SCTLR_EL1 (MMU off حتى نبني جداول الترجمة)
/// - قراءة CurrentEL للتأكد أننا في EL1
pub fn init() {
    let el: u64;
    unsafe { asm!("mrs {}, CurrentEL", out(reg) el, options(nostack)); }
    // EL = el >> 2  → 1 = EL1, 2 = EL2
    // لا نفعل شيئًا الآن؛ MMU يُهيَّأ لاحقًا في mmu.rs
    let _ = el;
}
