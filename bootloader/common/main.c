#include <stdint.h>


/* Expected in .data */
volatile uint32_t data_test = 0x12345678;
/* Expected in .bss */
volatile uint32_t bss_test;
/* Expected in .rodata */
const uint32_t rodata_test = 0xABCDEF12;
/* Expected in .bss */
volatile uint32_t boot_status;


/**
 *
 */
int main (void)
{
    if (data_test != 0x12345678U)
    {
        boot_status = 1;
    }
    else if (bss_test != 0U)
    {
        boot_status = 2;
    }
    /* A volatile access forces a read while the object remains const. */
    else if (*(const volatile uint32_t *)&rodata_test != 0xABCDEF12U)
    {
        boot_status = 3;
    }
    else
    {
        boot_status = 0x600D600DU;
    }

    /* Main loop */
    while (1)
    {
    }
}
