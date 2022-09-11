# Author: Dylan Turner
# Description: Build the executable

# Options

## Assembly Build options
AS :=				nasm

## Stage 1 bootloader options
STG1_SRC :=			$(wildcard stage1/*.asm)
STG1_INC :=			-Istage1
STG1_AS_FLAGS :=	-f bin

## Stage 2 bootloader options
STG2_SRC :=			$(wildcard stage2/*.asm)
STG2_INC :=			-Istage2
STG2_AS_FLAGS :=	-f elf64

# Targets

## Helper targets

.PHONY: all
all: stage2.o stage1.bin

.PHONY: clean
clean:
	rm -rf *.bin
	rm -rf *.o

### The binaries making up the final thing

stage1.bin: $(STG1_SRC)
ifeq ($(DEBUG),)
	$(AS) $(STG1_AS_FLAGS) $(STG1_INC) -o $@ stage1/stage1.asm
else
	$(AS) -g $(STG1_AS_FLAGS) $(STG1_INC) -o $@ stage1/stage1.asm
endif

stage2.o: $(STG2_SRC)
ifeq ($(DEBUG),)
	$(AS) $(STG2_AS_FLAGS) $(STG2_INC) -o $@ stage2/stage2.asm
else
	$(AS) -g $(STG2_AS_FLAGS) $(STG2_INC) -o $@ stage2/stage2.asm
endif

