include Environment.mak

build: makefile.hex

print-%:
	@echo $($(subst print-,,$@))

clean:
	rm -f Output/*

GPIO.o:Driver/GPIO/src/GPIO.c
	$(CC) $(CCFLAGS) -o $(OUTPUT_DIR)/$@ $^

main.o:User/main.c
	$(CC) $(CCFLAGS) -o $(OUTPUT_DIR)/$@ $^

stm32_startup.o:Startup/stm32_startup.c
	$(CC) $(CCFLAGS) -o $(OUTPUT_DIR)/$@ $^

makefile.elf:GPIO.o main.o stm32_startup.o
	$(CC) $(LDFLAGS) -o $(OUTPUT_DIR)/$@ $(foreach obj, $^, $(OUTPUT_DIR)/$(obj))

makefile.hex:makefile.elf
	$(OBJ_COPY) -O ihex $(OUTPUT_DIR)/$^ $(OUTPUT_DIR)/$@