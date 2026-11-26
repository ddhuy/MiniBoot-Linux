# Lab 1.1 — Two-stage architecture, VMA/LMA and linker scripts

## Objectives
Understand independent linking, physical storage vs LMA vs VMA, Flash/SRAM/SDRAM ownership, and conventional C runtime initialization. Build independently linked Stage 1 and Stage 2 images.

## Lessons
| Lesson | Topic | Status |
| --- | --- | --- |
| 1.1.1 | Two-stage boot architecture | Complete |
| 1.1.2 | Flash, SRAM and SDRAM layout | Complete |
| 1.1.3 | Storage address, VMA and LMA | Complete |
| 1.1.4 | Stage 1 linker script and startup | Complete |
| 1.1.5 | Stage 2 linker script and startup | Next |
| 1.1.6 | Independent compilation and verification | Pending |

## Stage 1 requirements (met)
- Flash XIP from 0x08000000, partition 128 KiB; internal SRAM 192 KiB.
- 4 KiB stack at top of SRAM, no heap; linker overlap and alignment checks.
- Retained vector table, Thumb entry, default and weak core handlers, explicit VTOR with barriers.
- Copy .data from Flash LMA to SRAM VMA, clear .bss, call main.
- Software floating-point ABI, freestanding compilation.
- Build ELF, BIN and MAP under build/bootloader/.
- Verify sections, segments, symbols, runtime values, vector table, VTOR and active BSS clearing.

## Build and inspect
```sh
make bootloader
arm-none-eabi-objdump -h build/bootloader/miniboot.elf
arm-none-eabi-readelf -lW build/bootloader/miniboot.elf
arm-none-eabi-nm -n build/bootloader/miniboot.elf
arm-none-eabi-size build/bootloader/miniboot.elf
```
Use installed toolchain prefix as needed. make flash_bl programs the board via OpenOCD; execute only with developer approval.

## Remaining work
Stage 2 is to be linked independently for SDRAM with initialized sections at VMA=LMA. Its startup clears BSS and establishes its runtime without recopying .data. Detailed implementation requirements follow in 1.1.5. Verify separate ELF/BIN artifacts in 1.1.6. SDRAM initialization/MPU setup (1.2), image format/CRC (1.3), and integrated handoff (1.4) are outside this lesson.

See [architecture](../../ARCHITECTURE.md), [memory layout](../../MEMORY_LAYOUT.md), [boot protocol](../../BOOT_PROTOCOL.md) and [results](NOTES.md).
