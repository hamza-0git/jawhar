ASM_SRCS  := arch/aarch64/boot.S
RUST_SRCS := arch/init.rs
LDSCRIPT  := arch/aarch64/linker.ld

ifeq ($(origin CC),default)
CC := clang
endif
ifeq ($(origin LD),default)
LD := ld.lld
endif

CLANG_TARGET ?= aarch64-elf

ASFLAGS := --target=$(CLANG_TARGET) -g -Wall -Wextra -c
LDFLAGS := -nostdlib -static --gc-sections

RUST_TARGET_CANDIDATES := aarch64-unknown-none aarch64-unknown-linux-gnu \
                          aarch64-unknown-linux-musl aarch64-linux-android
RUST_TARGET ?= $(call rust_pick_target,$(RUST_TARGET_CANDIDATES))
ifeq ($(strip $(RUST_TARGET)),)
$(error no Rust core for ARCH=$(ARCH); install one of: $(RUST_TARGET_CANDIDATES), or set RUST_TARGET)
endif
RUSTFLAGS   := --target $(RUST_TARGET) --edition 2021 \
               -g -C debuginfo=2 -C panic=abort -C relocation-model=static
