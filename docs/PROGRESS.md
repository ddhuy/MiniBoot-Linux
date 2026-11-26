# MiniBoot-Linux — Progress

Last updated: 2026-11-25

Current lab: **Lab 1.1 — in progress; Lesson 1.1.5 ready to start**

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
- Initial architecture and memory layout documented in Lab 1.1.
- [x] Developer confirmed setup prerequisites; Lab 0 complete.

## Learning record

- Prior coursework: Cortex-M4 startup/linker scripts, SDRAM execution, interrupts, Flash bootloader, XMODEM, A/B selection and U-Boot Driver Model.
- Introductory question: answered B correctly. Loading a U-Boot image at an address different from its linked VMA can fail unless its startup and relocation contract supports that address.
- Stage 1 built and hardware-tested by developer; all runtime, vector, VTOR and active BSS clearing checks pass. Source commit 80893617ac11bae1457f23fe2f181ca03a72af0c.

## Lab 1.1 lesson progress

- [x] 1.1.1 Two-stage architecture (quiz B).
- [x] 1.1.2 Memory layout (quiz B and bonus correct).
- [x] 1.1.3 Storage, VMA/LMA (quiz C; pointer relocation follow-up B correct).
- [x] 1.1.4 Stage 1 linker/startup, build, source review and developer hardware verification.
- [ ] 1.1.5 Stage 2 linker and startup.
- [ ] 1.1.6 Independent compilation and verification.

See [requirements](labs/lab01/README.md) and [evidence](labs/lab01/NOTES.md).

## Phase status

| Phase | Completed | Status |
| --- | --- | --- |
| 1 — Custom bootloader | 0/4 | In progress (Lab 1.1, 4/6 lessons) |
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

- Stage 1 startup/linker/runtime test and root Makefile implemented. Other components remain scaffolding.
- third_party directories contain placeholders; actual submodules will be added at the relevant labs.
- docs/labs/lab01/ and lab02/ are tracked; add notes as labs proceed.
- build/ is the agreed output directory and is ignored by Git.
- Custom second-stage U-Boot support, SDRAM mapping, XIP placement and available Flash capacity require verification.
- Portable default toolchain path deferred; CROSS_COMPILE command-line override available.

## Next lab

Lesson 1.1.5 — Stage 2 linker script and startup. Implement independent SDRAM-linked payload, preserve initialized data and clear its own BSS. Integrated SDRAM setup and handoff follow in later labs.

## Record format for subsequent labs

For each lab record: date, status, learning objectives, implementation changes, build commands/results, hardware/GDB evidence, quiz outcome, unresolved issues and commit/tag. Do not mark a hardware milestone complete without evidence.
