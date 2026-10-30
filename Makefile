ARCH ?= x86
ARCHES := x86 x86-64 aarch64

ifeq ($(filter $(ARCH),$(ARCHES)),)
$(error unsupported ARCH '$(ARCH)' (choose from: $(ARCHES)))
endif

BUILD_DIR := obj/$(ARCH)
KERNEL    := $(BUILD_DIR)/jawhar.elf
SIZE      ?= size

RUSTC ?= rustc
RUST_SYSROOT := $(shell $(RUSTC) --print sysroot)
rust_core = $(wildcard $(RUST_SYSROOT)/lib/rustlib/$(1)/lib/libcore*.rlib)
rust_pick_target = $(firstword $(foreach t,$(1),$(if $(call rust_core,$(t)),$(t))))

include arch/$(ARCH)/Makefile

OBJS := $(addprefix $(BUILD_DIR)/, \
          $(patsubst %.S,%.o,$(ASM_SRCS)) \
          $(patsubst %.rs,%.o,$(RUST_SRCS)))

RUST_LIBDIR := $(shell $(RUSTC) --print target-libdir --target $(RUST_TARGET))
RUST_LIBS   := $(wildcard $(RUST_LIBDIR)/libcore-*.rlib) \
               $(wildcard $(RUST_LIBDIR)/libcompiler_builtins-*.rlib)

.PHONY: all clean distclean $(ARCHES) size help

all: $(KERNEL)

$(KERNEL): $(OBJS) $(RUST_LIBS) $(LDSCRIPT)
	@mkdir -p $(@D)
	$(LD) $(LDFLAGS) -T $(LDSCRIPT) -o $@ $(OBJS) \
		--start-group $(RUST_LIBS) --end-group

$(BUILD_DIR)/%.o: %.S $(MAKEFILE_LIST)
	@mkdir -p $(@D)
	$(CC) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/%.o: %.rs $(MAKEFILE_LIST)
	@mkdir -p $(@D)
	$(RUSTC) $(RUSTFLAGS) --emit=obj --crate-type lib $< -o $@

$(ARCHES):
	$(MAKE) ARCH=$@

size: $(KERNEL)
	$(SIZE) $<

clean:
	rm -rf $(BUILD_DIR)

distclean:
	rm -rf obj

help:
	@echo "jawhar kernel"
	@echo "  make ARCH=x86"
	@echo "  make ARCH=x86-64"
	@echo "  make ARCH=aarch64"
	@echo "  make ARCH=<arch> clean"
	@echo "  make distclean"
