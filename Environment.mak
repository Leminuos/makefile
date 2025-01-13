GCC_DIR		:= C:\GNU_Toolchain
OBJ_COPY	:= $(GCC_DIR)\bin\arm-none-eabi-objcopy
CC 			:= $(GCC_DIR)\bin\arm-none-eabi-gcc
OUTPUT_DIR	:= .\Output
LINKER_DIR	:= .\Linker

CHIP 		:= cortex-m4
CCFLAGS		:= -c -mcpu=$(CHIP) -mthumb -std=gnu11 -O0 -IDriver\GPIO\inc
LDFLAGS		:= -nostdlib -T $(LINKER_DIR)\stm_ls.ld -Wl,-Map=Output\makefile.map