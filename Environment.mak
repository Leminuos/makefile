GCC_DIR		:= C:/GNU_Arm_Embedded_Toolchain
OBJ_COPY	:= $(GCC_DIR)/bin/arm-none-eabi-objcopy
CC			:= $(GCC_DIR)/bin/arm-none-eabi-gcc
OUTPUT_DIR	:= ./Output
LINKER_DIR	:= ./Linker

# Include files
INC_DIRS 	:= ./Driver/GPIO/inc ./Driver/NVIC/inc
INC_FILES   := $(foreach INC_DIR, $(INC_DIRS), $(wildcard $(INC_DIR)/*))

# Source files
SRC_DIRS	:= ./Driver/GPIO/src ./Driver/NVIC/src
SRC_FILES   := $(foreach SRC_DIR, $(SRC_DIRS), $(wildcard $(SRC_DIR)/*))

# CC option for INC_DIRS
INC_DIRS_OPT:= $(foreach INC_DIR, $(INC_DIRS), -I$(INC_DIR))

# Compiler options
CHIP 		:= cortex-m4
CCFLAGS		:= -c -mcpu=$(CHIP) -mthumb -std=gnu11 -O0 $(INC_DIRS_OPT)

# Linker options
LDFLAGS		:= -nostdlib -T $(LINKER_DIR)/stm_ls.ld -Wl,-Map=Output/makefile.map