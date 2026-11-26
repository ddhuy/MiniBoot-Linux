# MiniBoot-Linux — Memory layout

## Initial design (not a final Linux layout)

All ranges use exclusive upper bounds.

| Region | Start | End | Size | Owner |
| --- | --- | --- | --- | --- |
| Stage 1 Flash | 0x08000000 | 0x08020000 | 128 KiB | MiniBoot |
| Payload storage | 0x08020000 | 0x08200000 | 1920 KiB | Future loader |
| SRAM1 | 0x20000000 | 0x2001C000 | 112 KiB | Stage 1 |
| SRAM2 | 0x2001C000 | 0x20020000 | 16 KiB | Stage 1 |
| SRAM3 | 0x20020000 | 0x20030000 | 64 KiB | Stage 1 |
| CCM | 0x10000000 | 0x10010000 | 64 KiB | Unused |
| External SDRAM | 0xD0000000 | 0xD0800000 | 8 MiB | Proposed Stage 2 |

Flash boundary 0x08020000 separates the first five erase sectors from payload storage under the normal sector layout. Verify erase configuration before programming payloads. SDRAM assumes non-remapped FMC bank 2; initialization and executable MPU Normal memory attributes remain unverified. Do not assume the same mapping for upstream U-Boot/Linux.

## Actual Stage 1 ELF (Lab 1.1.4)
Source baseline: 80893617ac11bae1457f23fe2f181ca03a72af0c. Addresses from developer-provided objdump/nm/readelf output.

| Section | Size (bytes) | VMA | LMA |
| --- | ---: | --- | --- |
| .isr_vector | 428 | 0x08000000 | 0x08000000 |
| .text | 192 | 0x080001AC | 0x080001AC |
| .rodata | 4 | 0x0800026C | 0x0800026C |
| .data | 4 | 0x20000000 | 0x08000270 |
| .bss | 8 | 0x20000004 | No stored bytes (objdump reports 0x08000274) |

| Symbol | Address/value |
| --- | --- |
| __sidata | 0x08000270 |
| __sdata / data_test | 0x20000000 |
| __edata / __sbss / bss_test | 0x20000004 |
| boot_status | 0x20000008 |
| __ebss | 0x2000000C |
| __stack_limit | 0x2002F000 |
| __estack | 0x20030000 |
| __stack_size | 0x1000 |

Flash loadable bytes: 628 (0x274), leaving 130444 bytes in partition. Expected raw BIN size 628 bytes; actual file length not supplied. Static SRAM 12 bytes plus 4096-byte stack budget = 4108 bytes, leaving 192500 bytes. Stack is reserved by symbols/assertion, not an allocated ELF section. No heap. Linker checks current BSS/stack overlap and word alignment; revisit when adding other SRAM sections.

## Proposed Stage 2 layout
Link .isr_vector, .text, .rodata, .data with VMA=LMA in SDRAM, starting at 0xD0000000; .bss is NOLOAD. Stack top proposed 0xD0800000, stack size to be chosen in Lesson 1.1.5. The raw initialized image can be stored at 0x08020000 independently of its linked LMA. Do not allocate the same SDRAM to loader scratch buffers and live payload state. Actual sections and hardware execution are pending.
