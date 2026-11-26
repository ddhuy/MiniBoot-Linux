# MiniBoot-Linux — Architecture

Status: Lab 1.1.4 verified by developer hardware tests. Stage 2 is planned, not implemented.

## Target and goals
STM32F429I-DISC1, Cortex-M4 without MMU. Learn independent loading, U-Boot startup, Global Data, relocation and no-MMU Linux.

## Boot paths
```
Reset -> MiniBoot (internal Flash, internal SRAM)
             |-> bare-metal payload (SDRAM)
             |-> educational Mini U-Boot
             |-> adapted real U-Boot -> Linux
             |-> direct Linux
```
These are alternative configurations; simultaneous Flash residency is not assumed. Native STM32F429 U-Boot normally boots without SPL; second-stage integration is experimental.

## Stage responsibilities
Stage 1 owns its vector table, stack, .data copy and .bss zeroing. Future responsibilities: board clocks, FMC SDRAM initialization, executable memory attributes, image validation/loading and payload-specific handoff.
Stage 2 is independently linked for SDRAM. Its initialized sections are placed by the loader; startup clears its own .bss and establishes runtime state. It does not need to know persistent Flash storage addresses. No self-relocation is required for a load at the linked address.
Each payload has its own entry contract; Linux and U-Boot are not assumed to use a bare-metal vector-table handoff.

## Repository and build
- bootloader/arch/arm/cortex-m4/: startup and future handoff.
- bootloader/board/stm32f429i-disc1/: linker and board initialization.
- bootloader/common/: runtime test and future image/loading policy.
- bootloader/drivers/ and lib/: reusable drivers and utilities.
- payloads/baremetal/: independent Stage 2 test.
- payloads/mini-uboot/: future GD and relocation experiments.
- third_party/, configs/, patches/: future pinned upstream dependencies.
- Root Makefile currently owns build rules; component Makefiles may be introduced later.
- make bootloader produces build/bootloader/miniboot.elf, .bin and .map; build/ is ignored.

## Verified Stage 1 sequence
Reset -> MSP from vector table -> reset_handler (sets SP and VTOR, DSB/ISB) -> copy .data Flash to SRAM -> zero .bss -> main() -> runtime test and infinite loop.
Soft-float ABI, no heap, 4 KiB stack. No clock/SDRAM/MPU setup or Stage 2 handoff yet.

See [memory layout](MEMORY_LAYOUT.md), [boot protocol](BOOT_PROTOCOL.md), [lab requirements](labs/lab01/README.md), and [evidence](labs/lab01/NOTES.md).
