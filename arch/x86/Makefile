ASM_SRCS  := arch/x86/boot.S
RUST_SRCS := arch/init.rs
LDSCRIPT  := arch/x86/linker.ld

ifeq ($(origin CC),default)
CC := clang
endif
ifeq ($(origin LD),default)
LD := ld.lld
endif

CLANG_TARGET ?= i686-elf

ASFLAGS := --target=$(CLANG_TARGET) -g -Wall -Wextra -c
LDFLAGS := -m elf_i386 -nostdlib -static --gc-sections

RUST_TARGET_CANDIDATES := i686-unknown-none i686-unknown-linux-gnu \
                          i686-unknown-linux-musl i686-linux-android
RUST_TARGET ?= $(call rust_pick_target,$(RUST_TARGET_CANDIDATES))
ifeq ($(strip $(RUST_TARGET)),)
$(error no Rust core for ARCH=$(ARCH); install one of: $(RUST_TARGET_CANDIDATES), or set RUST_TARGET)
endif
RUSTFLAGS   := --target $(RUST_TARGET) --edition 2021 \
               -g -C debuginfo=2 -C panic=abort -C relocation-model=static
