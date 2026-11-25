# MiniBoot-Linux — Progress

Last updated: 2026-11-25

Current lab: **Lab 0 — Project setup (in progress)**

Curriculum: [ROADMAP.md](ROADMAP.md). Implementation labs completed: 0 / 32 (excluding Lab 0).

## Lab 0 checklist

- [x] Create GitHub repository and initial directory structure.
- [x] Review repository structure and AGENTS.md.
- [x] Verify GitHub read access and declared write permission.
- [x] Populate ROADMAP.md with eight phases and 32 labs.
- [x] Prepare initial PROGRESS.md (this file).
- [ ] Pull documentation changes locally and confirm GitHub write test.
- [ ] Check local compiler, binutils, Make, Python, GDB and OpenOCD versions.
- [ ] Confirm ST-LINK connection and UART console setup.
- [ ] Choose generated output directory (build/ or .build/) and align .gitignore.
- [ ] Record initial architecture and memory layout during Lab 1.1; no hardware addresses are finalized here.
- [ ] Confirm Lab 0 completion with the developer.

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
| arm-none-eabi-gcc / binutils | To be recorded |
| GDB / OpenOCD | To be recorded |
| Make / Python | To be recorded |
| U-Boot revision | Not pinned |
| Linux revision | Not pinned |
| Buildroot revision / Linux toolchain | Not pinned |
| Hardware tests | Not performed |

## Open setup notes

- Source files and Makefiles are scaffolding, not functional implementations.
- third_party directories contain placeholders; actual submodules will be added at the relevant labs.
- docs/labs/ can be created when the first lab notes are added.
- README heading currently duplicates AGENTS.md; consider a project-specific heading and links.
- .gitignore currently ignores .build/ but not build/; decide on one convention.
- Custom second-stage U-Boot support, SDRAM mapping, XIP placement and available Flash capacity require verification.

## Next lab

Lab 1.1 — Two-stage architecture, VMA/LMA and linker scripts. Define Stage 1 and Stage 2 responsibilities, memory regions, independent ELF images and handoff assumptions.

## Record format for subsequent labs

For each lab record: date, status, learning objectives, implementation changes, build commands/results, hardware/GDB evidence, quiz outcome, unresolved issues and commit/tag. Do not mark a hardware milestone complete without evidence.
