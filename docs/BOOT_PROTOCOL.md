# MiniBoot-Linux — Boot protocol

## Verified Stage 1 reset contract (Lab 1.1.4)
Normal internal Flash boot. Vector table at 0x08000000, 107 words (428 bytes), address aligned to 512 bytes. First word 0x20030000; second word 0x080001AD (Thumb entry). Actual reset instruction address 0x080001AC. Hardware reset uses vector entries, not ELF e_entry.
Startup sets MSP, writes SCB VTOR (0xE000ED08) to 0x08000000 and executes DSB/ISB. Copies aligned .data words from __sidata to [__sdata,__edata), zeros [__sbss,__ebss), calls main(), loops if main returns. Core exception handlers are weak aliases; external vectors use default handler except reserved IRQ 79. Soft-float ABI, no FPU initialization. Developer GDB tests verified vectors, VTOR, reset PC/MSP and active BSS clearing.

## Proposed bare-metal Stage 2 contract (not implemented)
- Raw binary linked for SDRAM at 0xD0000000; persistent storage provisionally 0x08020000.
- Loader must initialize SDRAM, establish executable Normal memory attributes (MPU or verified alternative), validate image length and all destination/runtime bounds, then copy initialized bytes to linked destination.
- Loader must validate vector table, aligned initial MSP within assigned stack bounds (one-past-end permitted), Thumb reset vector inside executable image, and non-overlapping live memory.
- Handoff must be from privileged Thread mode with appropriate MSP/CONTROL state, not an exception handler. Quiesce relevant interrupts, SysTick, pending NVIC state, DMA and peripherals; define which hardware state is inherited. Set VTOR and use required barriers; change MSP and branch without subsequent old-stack accesses (assembly trampoline).
- Stage 2 inherits initialized clocks/FMC/MPU as agreed. It must not clear initialized image bytes or disable the memory configuration supporting its own execution. It zeros its own BSS; no second .data copy when loaded at VMA=LMA. Interrupt mask policy and re-enabling are to be finalized before handoff.
- Entry is non-returning; failure stays in Stage 1 recovery path. Image header and integrity checks are designed in Lab 1.3, handoff implemented in 1.4.

## Future U-Boot and Linux contracts
Separate protocols will be derived from pinned upstream startup code and image formats. Do not assume vector-table entry or identical SDRAM mapping. Loading at linked address differs from relocation; relocation records identify selective fixups. CRC32 detects corruption, not authenticity.
