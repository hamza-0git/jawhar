ASM_SRCS  := arch/x86-64/boot.S
RUST_SRCS := arch/init.rs
LDSCRIPT  := arch/x86-64/linker.ld

ifeq ($(origin CC),default)
CC := clang
endif
ifeq ($(origin LD),default)
LD := ld.lld
endif

CLANG_TARGET ?= x86_64-elf

ASFLAGS := --target=$(CLANG_TARGET) -g -Wall -Wextra -c
LDFLAGS := -m elf_x86_64 -nostdlib -static --gc-sections

RUST_TARGET_CANDIDATES := x86_64-unknown-none x86_64-unknown-linux-gnu \
                          x86_64-unknown-linux-musl x86_64-linux-android
RUST_TARGET ?= $(call rust_pick_target,$(RUST_TARGET_CANDIDATES))
ifeq ($(strip $(RUST_TARGET)),)
$(error no Rust core for ARCH=$(ARCH); install one of: $(RUST_TARGET_CANDIDATES), or set RUST_TARGET)
endif
RUSTFLAGS   := --target $(RUST_TARGET) --edition 2021 \
               -g -C debuginfo=2 -C panic=abort -C relocation-model=static
