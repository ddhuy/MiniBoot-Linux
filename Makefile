TOOLCHAIN_PATH := /workspace/toolchain/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi
CROSS_COMPILE  := $(TOOLCHAIN_PATH)/bin/arm-none-eabi-

CC       := $(CROSS_COMPILE)gcc
CXX      := $(CROSS_COMPILE)g++
AS       := $(CROSS_COMPILE)as
LD       := $(CROSS_COMPILE)ld
OBJCOPY  := $(CROSS_COMPILE)objcopy
OBJDUMP  := $(CROSS_COMPILE)objdump
SIZE     := $(CROSS_COMPILE)size
READELF  := $(CROSS_COMPILE)readelf
PYTHON   := python3


# Layers, like U-Boot: arch (CPU core) <- soc (chip) <- board (PCB).
# Code includes "arch/...", "soc/..." and "board.h"; these variables pick which.
ARCH  ?= cortex-m4
SOC   ?= stm32f429
BOARD ?= stm32f429i-disc1


BUILD := build


BL_DIR    := bootloader
BL_TARGET := $(BUILD)/$(BL_DIR)/miniboot

BL_SRCS := $(BL_DIR)/arch/arm/$(ARCH)/startup.S
BL_SRCS += $(BL_DIR)/common/main.c

BL_LDS  := $(BL_DIR)/board/$(BOARD)/linker.ld

BL_OBJS := $(patsubst %,$(BUILD)/%.o,$(basename $(BL_SRCS)))

BL_INCLUDES := -I./ -I$(BL_DIR)/include

CPU_FLAGS := -mcpu=cortex-m4 -mthumb -mfloat-abi=soft

CFLAGS  = $(CPU_FLAGS) -O0 -g3 \
			-Wall -Wextra -Wmissing-prototypes \
			-ffreestanding -fno-builtin -ffunction-sections -fdata-sections \
			-MMD -MP

LDFLAGS = $(CPU_FLAGS) -nostdlib \
			-Wl,--gc-sections -Wl,--fatal-warnings -Wl,-Map=$(BL_TARGET).map


.PHONY: all bootloader clean flash_bl

all: bootloader

clean:
	@rm -rf $(BUILD)
	@echo "==== Cleaned!"


bootloader: $(BL_TARGET).bin

$(BL_TARGET).bin: $(BL_TARGET).elf
	@echo "==== $<"
	$(OBJCOPY) -O binary $< $@
	@echo ""

$(BL_TARGET).elf: $(BL_OBJS) $(BL_LDS)
	@echo "==== $<"
	$(CC) $(LDFLAGS) -T $(BL_LDS) $(BL_OBJS) -lgcc -o $@
	@echo ""

$(BUILD)/%.o: %.S
	@echo "==== $<"
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(BL_INCLUDES) -c $< -o $@
	@echo ""

$(BUILD)/%.o: %.c
	@echo "==== $<"
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(BL_INCLUDES) -c $< -o $@
	@echo ""

flash_bl: $(BL_TARGET).elf
	openocd -f board/stm32f429disc1.cfg -c "program $< verify reset exit"
	@echo ""

-include $(BL_OBJS:.o=.d)
