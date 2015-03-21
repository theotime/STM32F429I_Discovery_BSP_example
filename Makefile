# Makefile

SRCS=lcd.c   main.c  mems.c  stm32f4xx_it.c  system_stm32f4xx.c  touchscreen.c  ts_calibration.c
SRCS += startup_stm32f429xx.s

#BSP files
SRCS += stm32f429i_discovery.c
SRCS += stm32f429i_discovery_lcd.c
SRCS += stm32f429i_discovery_sdram.c
SRCS += stm32f429i_discovery_ts.c
SRCS += stm32f429i_discovery_gyroscope.c

# Binaries will be generated with this name (.elf, .bin, .hex, etc)
PROJ_NAME=main

# Path
STM_COMMON=/opt/STM32Cube_FW_F4_V1.4.0

# Board/MCU
STM_SERIE=STM32F4XX
STM_MODEL=STM32F429xx
BSP_MODEL=STM32F429I-Discovery

# Linker
LINK=STM32F429ZI_FLASH.ld

#######################################################################################

export STM_COMMON
export STM_SERIE
export STM_MODEL

CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

CFLAGS  = -g -O2 -Wall -T$(LINK)
CFLAGS += -DUSE_STDPERIPH_DRIVER -D$(STM_SERIE) -D$(STM_MODEL)
CFLAGS += --specs=nosys.specs
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -I. -IInc

# Include files from STM libraries
CFLAGS += -I$(STM_COMMON)/Drivers/CMSIS/Include
CFLAGS += -I$(STM_COMMON)/Drivers/STM32F4xx_HAL_Driver/Inc
CFLAGS += -I$(STM_COMMON)/Drivers/CMSIS/Device/ST/STM32F4xx/Include/

# BSP drivers
SRCS += stmpe811.c l3gd20.c ili9341.c
vpath %.c $(STM_COMMON)/Drivers/BSP/Components/stmpe811
vpath %.c $(STM_COMMON)/Drivers/BSP/Components/l3gd20
vpath %.c $(STM_COMMON)/Drivers/BSP/Components/ili9341

# BSP 
CFLAGS += -I$(STM_COMMON)/Drivers/BSP/$(BSP_MODEL)
vpath %.c $(STM_COMMON)/Drivers/BSP/$(BSP_MODEL)

vpath %.c Src/

OBJS = $(SRCS:.c=.o)

LIBS=libs

.PHONY: lib proj

all: lib proj
	
lib:
	$(MAKE) -C $(LIBS)

proj: $(PROJ_NAME).elf

$(PROJ_NAME).elf: $(SRCS)
	$(CC) $(CFLAGS) $^ -o $@ -L$(LIBS) -lstmf4
	$(OBJCOPY) -O ihex $(PROJ_NAME).elf $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

clean:
	rm -f *.o
	rm -f $(PROJ_NAME).elf
	rm -f $(PROJ_NAME).hex
	rm -f $(PROJ_NAME).bin
	$(MAKE) -C $(LIBS) clean

burn:
	st-flash write $(PROJ_NAME).bin 0x8000000
