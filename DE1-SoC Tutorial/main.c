#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hps_0.h"
#include "seg7.h"

#define LW_SIZE 0x00200000
#define LWHPS2FPGA_BASE 0xff200000

volatile uint32_t *h2p_lw_led_addr = NULL;
volatile uint32_t *h2p_lw_hex_addr = NULL;
volatile uint32_t *h2p_lw_sw_addr = NULL;

void led_blink(void) {
    for (int i = 0; i < 10; i++) {
        printf("LED Blinking: %d\n", i);
        LEDR_LightCount(i);
        usleep(100000);
    }
}

void monitor_switches(void) {
    uint32_t prev_state = 0;
    while(1) {
        uint32_t switch_state = alt_read_word(h2p_lw_sw_addr);
        if (switch_state != prev_state) {
            printf("Switch Change Detected: %X\n", switch_state);
            alt_write_word(h2p_lw_led_addr, switch_state);
            prev_state = switch_state;
        }
        usleep(100000);
    }
}

int main() {
    int fd;
    void *virtual_base;

    if ((fd = open("/dev/mem", O_RDWR | O_SYNC)) == -1) {
        printf("ERROR: Could not open /dev/mem\n");
        return 1;
    }

    virtual_base = mmap(NULL, LW_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, LWHPS2FPGA_BASE);
    if (virtual_base == MAP_FAILED) {
        printf("ERROR: mmap() failed\n");
        close(fd);
        return 1;
    }

    h2p_lw_led_addr = virtual_base + ((uint32_t)(LED_PIO_BASE));
    h2p_lw_hex_addr = virtual_base + ((uint32_t)(SEG7_IF_0_BASE));
    h2p_lw_sw_addr  = virtual_base + ((uint32_t)(SWITCH_PIO_BASE));

    printf("Starting Light Show...\n");
    led_blink();
    
    printf("Displaying Message...\n");
    display_msg();

    printf("Monitoring Switches...\n");
    monitor_switches();

    munmap(virtual_base, LW_SIZE);
    close(fd);
    return 0;
}


