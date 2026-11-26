    .syntax unified
    .cpu cortex-m4
    .fpu softvfp
    .thumb


/**
 * Vector table. The linker script places .isr_vector at the start of
 * flash, where the core looks for it after reset:
 *   word 0 -> initial MSP, word 1 -> reset handler.
 */
    .section .isr_vector, "a", %progbits
    .global vector_table
vector_table:
    .word   __estack
    .word   reset_handler
    .word   nmi_handler
    .word   hardfault_handler
    .word   memmanage_handler
    .word   busfault_handler
    .word   usagefault_handler
    .word   0
    .word   0
    .word   0
    .word   0
    .word   svc_handler
    .word   debugmon_handler
    .word   0
    .word   pendsv_handler
    .word   systick_handler

    /* STM32F429 IRQs 0..90; IRQ 79 is reserved.
     * Replace used slots with named handlers before enabling interrupts. */
    .rept   79
    .word   default_handler
    .endr
    .word   0
    .rept   11
    .word   default_handler
    .endr


/**
 * Reset handler: build the C environment, then call main().
 * The symbols come from linker.ld.
 */
    .section .text.reset_handler, "ax", %progbits
    .global reset_handler
    .type   reset_handler, %function
    .thumb_func
reset_handler:
    ldr sp, =__estack /* set stack pointer */

/* Copy the data segment initializers from flash to SRAM */
    ldr r0, =__sdata
    ldr r1, =__edata
    ldr r2, =__sidata
    movs r3, #0
    b _loop_cp_data_init

_cp_data_init:
    ldr r4, [r2, r3]
    str r4, [r0, r3]
    adds r3, r3, #4
_loop_cp_data_init:
    adds r4, r0, r3
    cmp r4, r1
    bcc _cp_data_init

/* Zero fill the bss segment. */
    ldr r2, =__sbss
    ldr r4, =__ebss
    movs r3, #0
    b _loop_fill_bss

_fill_zero:
    str r3, [r2]
    adds r2, r2, #4

_loop_fill_bss:
    cmp r2, r4
    bcc _fill_zero

/* Call the application's entry point.*/
    bl main
    /* Reset has no caller to return to if main exits. */
.Lmain_returned:
    b .Lmain_returned


/* Unexpected exception: park here so the debugger shows where we are */
    .section .text.default_handler, "ax", %progbits
    .type   default_handler, %function
    .thumb_func
default_handler:
    b       default_handler

/* Weak aliases: defining a handler with the same name in C overrides one */
    .macro  weak_handler name
    .weak   \name
    .thumb_set \name, default_handler
    .endm

    weak_handler nmi_handler
    weak_handler hardfault_handler
    weak_handler memmanage_handler
    weak_handler busfault_handler
    weak_handler usagefault_handler
    weak_handler svc_handler
    weak_handler debugmon_handler
    weak_handler pendsv_handler
    weak_handler systick_handler
