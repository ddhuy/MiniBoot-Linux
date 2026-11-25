# MiniBoot-Linux — Learning Roadmap

Target: STM32F429I-DISC1 (ARM Cortex-M4, no MMU, 2 MiB internal Flash, 8 MiB external SDRAM).

## Goals and approach

Build a custom first-stage loader, understand real U-Boot startup, Global Data and relocation, then boot no-MMU Linux. Reuse previous bare-metal and MiniBoot-DM knowledge. Learn the mechanism, implement a minimal example, inspect upstream code, verify with GDB and hardware, and answer a quiz. The developer implements the labs; the agent mentors and reviews.

## Target boot paths

- A: MiniBoot -> bare-metal payload in SDRAM.
- B: MiniBoot -> adapted U-Boot -> Linux -> BusyBox.
- C: MiniBoot -> Linux -> BusyBox.

These are separate initial build/boot configurations, not a promise that all images fit in Flash simultaneously. Standard STM32F429 Discovery U-Boot boots without SPL; adapting it as a second stage is an experimental goal. Verify image entry, relocation, clock/SDRAM state and memory mapping against pinned upstream sources. No-MMU Linux XIP and root filesystem sizes must be measured.

## Lab 0 — Project setup

Review repository structure, AGENTS.md, documentation, Git access and local toolchain. Record compiler/debugger versions, board access and dependency revisions as they are established. Keep generated artifacts out of Git. See [PROGRESS.md](PROGRESS.md).

## Phase 1 — Custom first-stage bootloader

| Lab | Topic | Exercise / evidence |
| --- | --- | --- |
| 1.1 | Two-stage architecture, VMA and LMA | Design separate linker scripts; inspect ELF sections and load segments. |
| 1.2 | SDRAM initialization and memory layout | Verify FMC mapping and RAM read/write tests. |
| 1.3 | Image header, CRC32 and entry point | Validate image bounds, type and checksum; reject malformed images. |
| 1.4 | Safe CPU handoff | Inspect MSP, VTOR, Thumb entry, interrupts and peripheral state; execute test payload. |

Milestone: MiniBoot loads and executes a bare-metal payload from SDRAM.

## Phase 2 — Real U-Boot startup

| Lab | Topic | Exercise / evidence |
| --- | --- | --- |
| 2.1 | Build and boot upstream U-Boot | Pin revision, build STM32F429 Discovery configuration and capture UART console. |
| 2.2 | ELF, BIN, MAP and linker script | Inspect symbols, sections, segments and image layout. |
| 2.3 | Reset, start.S and _main | Trace actual Cortex-M startup in GDB. |
| 2.4 | board_init_f() and board_init_r() | Map early and late initialization and C runtime constraints. |

Milestone: Explain the reset-to-command-prompt sequence.

## Phase 3 — Global Data (GD)

| Lab | Topic | Exercise / evidence |
| --- | --- | --- |
| 3.1 | Why Global Data is needed | Explain early stack and unavailable ordinary writable globals. |
| 3.2 | Implement minimal struct global_data | Build a teaching payload with shared boot state. |
| 3.3 | ARM r9 and DECLARE_GLOBAL_DATA_PTR | Inspect generated assembly and register-bound pointer conventions. |
| 3.4 | Early allocation and initialization | Trace GD reservation, zeroing and stack setup. |
| 3.5 | GD, Driver Model and early malloc | Trace DM roots and early allocator state in selected upstream build. |

Milestone: Explain GD lifetime, allocation, access and its connection to Driver Model. Inspect r9 and GD fields in GDB.

## Phase 4 — U-Boot relocation and memory management

| Lab | Topic | Exercise / evidence |
| --- | --- | --- |
| 4.1 | Why self-relocation is needed | Distinguish loading, copying and address fixups. |
| 4.2 | SDRAM reservation and gd->relocaddr | Draw runtime memory reservations and verify addresses. |
| 4.3 | ELF relocation entries and .rel.dyn | Inspect relocation records and address-dependent references. |
| 4.4 | Relocate GD, stack and code | Observe old/new GD, SP and PC and runtime initialization. |
| 4.5 | Minimal self-relocating program | Implement and verify a teaching relocation mechanism. |

Milestone: Explain and demonstrate relocation using the selected target's actual relocation path. Study ram_base, ram_size, ram_top, relocaddr, reloc_off, start_addr_sp and new_gd where available.

## Phase 5 — U-Boot integration

| Lab | Topic | Exercise / evidence |
| --- | --- | --- |
| 5.1 | SPL versus custom loader | Define responsibilities and second-stage entry contract. |
| 5.2 | Adapt initial execution address and startup | Verify linker address and inherited hardware assumptions. |
| 5.3 | Driver Model before and after relocation | Trace early and runtime device state; connect to MiniBoot-DM. |
| 5.4 | MiniBoot -> real U-Boot | Capture console, inspect runtime addresses and validate handoff. |

Milestone: Reach U-Boot prompt via MiniBoot, subject to successful porting and memory constraints.

## Phase 6 — No-MMU Linux

| Lab | Topic | Exercise / evidence |
| --- | --- | --- |
| 6.1 | Buildroot, cross compilation and toolchains | Pin a working STM32F429 Discovery XIP reference configuration. |
| 6.2 | XIP kernel and CONFIG_MMU=n | Inspect vmlinux, xipImage, code/data placement and no-MMU limitations. |
| 6.3 | Device Tree and board initialization | Verify DTB, SDRAM mapping, UART and boot parameters. |
| 6.4 | Root filesystem, BusyBox and init | Capture kernel log and minimal user-space shell. |

Milestone: Boot reference no-MMU Linux; then validate U-Boot-to-Linux handoff with compatible images. Discuss scheduling, syscalls, allocation and no-MMU process limitations.

## Phase 7 — Direct Linux boot

| Lab | Topic | Exercise / evidence |
| --- | --- | --- |
| 7.1 | Cortex-M Linux entry | Trace selected kernel startup and exact entry ABI. |
| 7.2 | Device Tree placement and boot parameters | Validate addresses, alignment, reserved memory and CPU state. |
| 7.3 | Implement boot_linux() | Load or locate XIP image and perform verified kernel handoff. |
| 7.4 | Kernel initialization to userspace | Trace start_kernel(), init and capture direct-boot shell. |

Milestone: MiniBoot boots Linux without U-Boot, subject to board and image constraints.

## Phase 8 — Firmware updates and recovery

| Lab | Topic | Exercise / evidence |
| --- | --- | --- |
| 8.1 | Image verification, selection and Flash partitions | Measure image sizes, erase boundaries and test rejection paths. |
| 8.2 | Recovery boot, counters and rollback | Test recovery after a failed boot; use A/B only if storage permits. |

Milestone: Demonstrate a recoverable boot design. CRC32 detects accidental corruption, not authenticity.

## Repository and lab workflow

- bootloader/: architecture, board, drivers, common loading and handoff code.
- payloads/baremetal/: independent test payload.
- payloads/mini-uboot/: simplified GD, startup and relocation experiments.
- third_party/: pinned U-Boot, Linux and Buildroot dependencies (planned submodules).
- configs/ and patches/: reproducible configuration and upstream changes.
- tools/ and tests/: image tooling, debugging and validation.
- docs/labs/: lab requirements, observations and evidence, created as needed.
- build/: generated artifacts (ignore in Git).

For every lab, review requirements, implement locally, inspect staged/unstaged/untracked changes, build and test, record evidence and remaining issues, update PROGRESS.md, then commit/tag with developer approval. Never flash, commit or push automatically without permission.

## References

- [U-Boot Global Data](https://docs.u-boot.org/en/latest/develop/global_data.html)
- [U-Boot source](https://github.com/u-boot/u-boot)
- [Linux source](https://github.com/torvalds/linux)
- [Buildroot](https://buildroot.org/)
- [STM32 Linux notes](https://elinux.org/STM32)

Upstream versions, exact memory addresses, entry protocols and hardware results remain to be verified during the labs.
