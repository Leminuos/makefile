include Environment.mak

GCC_DIR		:= C:\GNU_Arm_Embedded_Toolchain
OBJ_COPY	:= $(GCC_DIR)\bin\arm-none-eabi-objcopy
CC 			:= $(GCC_DIR)\bin\arm-none-eabi-gcc
OUTPUT_DIR	:= .\Output
LINKER_DIR	:= .\Linker

CHIP 		:= cortex-m4
CCFLAGS		:= -c -mcpu=$(CHIP) -mthumb -std=gnu11 -O0 -IDriver\GPIO\inc
LDFLAGS		:= -nostdlib -T $(LINKER_DIR)\stm_ls.ld -Wl,-Map=Output\makefile.map

build: makefile.hex

clean:
	rm -f Output/*

GPIO.o:Driver\GPIO\src\GPIO.c
	$(CC) $(CCFLAGS) -o Output\GPIO.o Driver\GPIO\src\GPIO.c

main.o:User\main.c
	$(CC) $(CCFLAGS) -o Output\main.o User\main.c

stm32_startup.o:Startup\stm32_startup.c
	$(CC) $(CCFLAGS) -c Startup\stm32_startup.c -o Output\stm32_startup.o

makefile.elf:GPIO.o main.o stm32_startup.o
	$(CC) $(LDFLAGS) -o $(OUTPUT_DIR)\makefile.elf $(OUTPUT_DIR)\GPIO.o  $(OUTPUT_DIR)\main.o  $(OUTPUT_DIR)\stm32_startup.o

makefile.hex:makefile.elf
	$(OBJ_COPY) -O ihex $(OUTPUT_DIR)\makefile.elf $(OUTPUT_DIR)\makefile.hex