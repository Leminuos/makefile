include Environment.mak

# Include files
INC_DIRS 	:= ./Driver/GPIO/inc
INC_FILES   := $(foreach INC_DIR, $(INC_DIRS), $(wildcard $(INC_DIR)/*))

# Source files
SRC_DIRS	:= ./Driver/GPIO/src ./User ./Startup
SRC_FILES   := $(foreach SRC_DIR, $(SRC_DIRS), $(wildcard $(SRC_DIR)/*))

# Object files
OBJ_FILES	:= $(patsubst %.c, %.o, $(notdir $(SRC_FILES)))
OBJ_PATHS	:= $(foreach OBJ_FILE, $(OBJ_FILES), $(OUTPUT_DIR)/$(OBJ_FILE))

# CC option for INC_DIRS
INC_DIRS_OPT:= $(foreach INC_DIR, $(INC_DIRS), -I$(INC_DIR))

# Compiler options
CHIP 		:= cortex-m4
CCFLAGS		:= -c -mcpu=$(CHIP) -mthumb -std=gnu11 -O0 $(INC_DIRS_OPT)

# Linker options
LDFLAGS		:= -nostdlib -T $(LINKER_DIR)/stm_ls.ld -Wl,-Map=Output/makefile.map

vpath %.c $(SRC_DIRS)

build: makefile.hex

print-%:
	@echo $($(subst print-,,$@))

clean:
	rm -f Output/*

%.o:%.c
	$(CC) $(CCFLAGS) -o $(OUTPUT_DIR)/$@ $^

makefile.elf:$(OBJ_FILES)
	$(CC) $(LDFLAGS) -o $(OUTPUT_DIR)/$@ $(OBJ_PATHS)

makefile.hex:makefile.elf
	$(OBJ_COPY) -O ihex $(OUTPUT_DIR)/$^ $(OUTPUT_DIR)/$@