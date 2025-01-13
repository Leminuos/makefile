include Environment.mak

build: makefile.hex

clean:
	rm -f Output/*

GPIO.o:Driver\GPIO\src\GPIO.c
	$(CC) $(CCFLAGS) -o Output\GPIO.o Driver\GPIO\src\GPIO.c
	@echo Echo $<

main.o:User\main.c
	$(CC) $(CCFLAGS) -o Output\main.o User\main.c

stm32_startup.o:Startup\stm32_startup.c
	$(CC) $(CCFLAGS) -c Startup\stm32_startup.c -o Output\stm32_startup.o

makefile.elf:GPIO.o main.o stm32_startup.o
	$(CC) $(LDFLAGS) -o $(OUTPUT_DIR)\makefile.elf $(OUTPUT_DIR)\GPIO.o  $(OUTPUT_DIR)\main.o  $(OUTPUT_DIR)\stm32_startup.o

makefile.hex:makefile.elf
	$(OBJ_COPY) -O ihex $(OUTPUT_DIR)\makefile.elf $(OUTPUT_DIR)\makefile.hex