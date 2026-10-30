use core::arch::asm;
use core::mem::size_of;

#[repr(C, packed)]
#[derive(Clone, Copy)]
struct Desc {
    limit_lo: u16,
    base_lo:  u16,
    base_mid: u8,
    access:   u8,
    flags_hi: u8,
    base_hi:  u8,
}

impl Desc {
    const fn new(base: u32, limit: u32, access: u8, flags: u8) -> Self {
        Self {
            limit_lo: (limit & 0xFFFF) as u16,
            base_lo:  (base  & 0xFFFF) as u16,
            base_mid: ((base  >> 16) & 0xFF) as u8,
            access,
            flags_hi: ((flags & 0xF) << 4) | (((limit >> 16) & 0xF) as u8),
            base_hi:  ((base  >> 24) & 0xFF) as u8,
        }
    }
    const fn null()        -> Self { Self::new(0, 0,     0,    0) }
    const fn kernel_code() -> Self { Self::new(0, 0xFFFFF, 0x9A, 0xA) } // L=1
    const fn kernel_data() -> Self { Self::new(0, 0xFFFFF, 0x92, 0xC) }
}

#[repr(C, packed)]
struct Ptr { limit: u16, base: u64 }

static GDT: [Desc; 3] = [
    Desc::null(),
    Desc::kernel_code(),   // 0x08
    Desc::kernel_data(),   // 0x10
];

pub fn init() {
    let p = Ptr {
        limit: (size_of::<[Desc; 3]>() - 1) as u16,
        base:  GDT.as_ptr() as u64,
    };
    unsafe {
        asm!("lgdt [{}]", in(reg) &p, options(nostack));
        asm!(
            "mov ax, 0x10",
            "mov ds, ax", "mov es, ax", "mov fs, ax",
            "mov gs, ax", "mov ss, ax",
            out("ax") _,
        );
    }
}