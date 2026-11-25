# MiniBoot-Linux — Progress

Last updated: 2026-11-25

Current lab: **Lab 1.1 — Two-stage architecture, VMA/LMA and linker scripts (ready to start)**

Curriculum: [ROADMAP.md](ROADMAP.md). Implementation labs completed: 0 / 32 (excluding Lab 0).

## Lab 0 checklist — completed 2026-11-25

- [x] Create GitHub repository and initial directory structure.
- [x] Review repository structure and AGENTS.md.
- [x] Verify GitHub read access and declared write permission.
- [x] Populate ROADMAP.md with eight phases and 32 labs.
- [x] Prepare initial PROGRESS.md (this file).
- [x] Documentation write test verified; developer reports subsequent local changes committed.
- [x] Local development toolchain works (developer-confirmed; exact versions not recorded).
- [x] ST-LINK and UART connections work (developer-confirmed).
- [x] Use build/ as generated output directory; verified .gitignore on master.
- [x] Verify docs/labs/lab01/ and lab02/ tracked on master.
- Initial architecture and memory layout deferred to Lab 1.1.
- [x] Developer confirmed setup prerequisites; Lab 0 complete.

## Learning record

- Prior coursework: Cortex-M4 startup/linker scripts, SDRAM execution, interrupts, Flash bootloader, XMODEM, A/B selection and U-Boot Driver Model.
- Introductory question: answered B correctly. Loading a U-Boot image at an address different from its linked VMA can fail unless its startup and relocation contract supports that address.
- No MiniBoot-Linux firmware has been built or hardware-tested yet.

## Phase status

| Phase | Completed | Status |
| --- | --- | --- |
| 1 — Custom bootloader | 0/4 | Not started |
| 2 — U-Boot startup | 0/4 | Not started |
| 3 — Global Data | 0/5 | Not started |
| 4 — Relocation | 0/5 | Not started |
| 5 — Integration | 0/4 | Not started |
| 6 — No-MMU Linux | 0/4 | Not started |
| 7 — Direct Linux boot | 0/4 | Not started |
| 8 — Recovery | 0/2 | Not started |

## Environment and dependencies

| Item | Version / status |
| --- | --- |
| Target | STM32F429I-DISC1 |
| Host OS | To be recorded |
| arm-none-eabi-gcc / binutils | Toolchain working per developer; versions not recorded |
| GDB / OpenOCD | Exact versions not recorded |
| Make / Python | To be recorded |
| U-Boot revision | Not pinned |
| Linux revision | Not pinned |
| Buildroot revision / Linux toolchain | Not pinned |
| Hardware connectivity | ST-LINK and UART working per developer |

## Open setup notes

- Source files and Makefiles are scaffolding, not functional implementations.
- third_party directories contain placeholders; actual submodules will be added at the relevant labs.
- docs/labs/lab01/ and lab02/ are tracked; add notes as labs proceed.
- build/ is the agreed output directory and is ignored by Git.
- Custom second-stage U-Boot support, SDRAM mapping, XIP placement and available Flash capacity require verification.

## Next lab

Lab 1.1 — Two-stage architecture, VMA/LMA and linker scripts. Define Stage 1 and Stage 2 responsibilities, memory regions, independent ELF images and handoff assumptions.

## Record format for subsequent labs

For each lab record: date, status, learning objectives, implementation changes, build commands/results, hardware/GDB evidence, quiz outcome, unresolved issues and commit/tag. Do not mark a hardware milestone complete without evidence.
