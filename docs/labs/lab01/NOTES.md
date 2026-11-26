# Lab 1.1 — Learning and verification notes

## Theory and quizzes
- 1.1.1: B, correct. Each ELF independently resolves linker symbols such as __sbss.
- 1.1.2: B, correct. Initial stack/data/BSS cannot depend on SDRAM before initialization. Uninitialized accesses may fault or behave unreliably; locals can also reside in registers.
- Bonus: Stage 2 linker need not know Flash storage address when the raw image is copied to its linked SDRAM base.
- 1.1.3: C, correct. The loader places initialized data; Stage 2 clears BSS.
- Pointer bonus initially confused absolute pointers with relative offsets. Follow-up B, correct: add 0x00200000 to stored 0xD0000700 to obtain 0xD0200700 when relocating image by 2 MiB. Do not adjust integers or all words blindly. Loading at linked VMA is not self-relocation.

## Lab 1.1.4 implementation
Source commit: [8089361](https://github.com/ddhuy/MiniBoot-Linux/commit/80893617ac11bae1457f23fe2f181ca03a72af0c).
Reviewed committed Makefile, startup.S and linker.ld; results below supplied by developer from local build and physical board, not independently reproduced by reviewer.

### Review findings
| ID | Finding | Resolution |
| --- | --- | --- |
| R01 | Portable toolchain default | Deferred; CROSS_COMPILE can be overridden on make command line; default path remains local |
| R02 | Explicit soft-float ABI | Fixed |
| R03 | Explicit VTOR + barriers | Fixed |
| R04 | Linker word alignment assertions | Fixed |
| R05 | Separate .text/.rodata | Fixed |
| R06 | Post-indexed copy | Fixed |

No blocking findings. Future robustness: revisit stack overlap checks when adding SRAM sections; actual vector table address is aligned although ELF section reports alignment 2**0.

### ELF inspection
```
Section       Size       VMA       LMA
.isr_vector   000001ac   08000000  08000000
.text         000000c0   080001ac  080001ac
.rodata       00000004   0800026c  0800026c
.data         00000004   20000000  08000270
.bss          00000008   20000004  08000274 (no stored contents)

Entry point 0x080001ad
Type Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
LOAD 0x001000 0x08000000 0x08000000 0x00270 0x00270 R E 0x1000
LOAD 0x002000 0x20000000 0x08000270 0x00004 0x0000c RW  0x1000

text data bss dec hex
624  4    8   636 27c

08000000 R vector_table
080001ac T reset_handler
0800020c T main
0800026c R rodata_test
08000270 A __sidata
20000000 D data_test / __sdata
20000004 B bss_test / __sbss
20000004 D __edata
20000008 B boot_status
2000000c B __ebss
2002f000 A __stack_limit
20030000 R __estack
```
Flash payload 628 bytes expected; SRAM static 12 bytes; stack budget 4096 bytes. Second LOAD has 4 file bytes and 12 memory bytes; extra 8 bytes correspond to BSS. ELF entry low bit indicates Thumb, not an odd instruction address.

### GDB evidence (developer)
```
(gdb) p/x data_test
$1 = 0x12345678
(gdb) p/x bss_test
$2 = 0x0
(gdb) p/x rodata_test
$3 = 0xabcdef12
(gdb) p/x boot_status
$4 = 0x600d600d
(gdb) x/2wx 0x08000000
0x8000000: 0x20030000 0x080001ad
(gdb) x/wx 0xE000ED08
0xe000ed08: 0x08000000
(gdb) monitor reset halt
Unable to match requested speed 2000 kHz, using 1800 kHz
Unable to match requested speed 2000 kHz, using 1800 kHz
[stm32f4x.cpu] halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x080001ac msp: 0x20030000
(gdb) set variable bss_test = 0xDEADBEEF
(gdb) b main
Breakpoint 1 at 0x8000210: file bootloader/common/main.c, line 19.
Note: automatically using hardware breakpoints for read-only addresses.
(gdb) c
Continuing.
Breakpoint 1, main () at bootloader/common/main.c:19
19      if (data_test != 0x12345678U)
(gdb) p/x bss_test
$5 = 0x0
```
All tests pass. Active BSS clear demonstrated by deliberately poisoning the variable before startup and observing zero at main. Adapter clock fallback 1800 kHz is nonblocking. Reset PC is even; vector entry contains Thumb bit; xPSR T bit is set.

## Outcome
Lesson 1.1.4 passed. Stage 1 C runtime verified on developer's board. Lab 1.1 as a whole is still in progress; Stage 2 and independent build verification remain. Next: Lesson 1.1.5. No SDRAM or integrated handoff tests yet.
