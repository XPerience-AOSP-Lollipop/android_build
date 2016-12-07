## Clang/LLVM release versions.
LLVM_RELEASE_VERSION := 3.8
ifeq ($(XPERIENCE_OPTIMIZATION),false)
LLVM_PREBUILTS_VERSION ?= clang-2690385
else
LLVM_PREBUILTS_VERSION := 3.8-xpe
endif
LLVM_PREBUILTS_BASE ?= prebuilts/clang/host
