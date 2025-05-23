/* COE838 - System-on-Chip
 * Lab 4 - Custom IP for HPS/FPGA Systems
 * main.c
 *	
 *  Created on: 2014-11-15
 *  Author: Anita Tino
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"
#include "hps_0.h"

#define LW_SIZE 0x00200000
#define LWHPS2FPGA_BASE 0xff200000

volatile uint32_t *mult_control = NULL;
volatile uint32_t *mult_data = NULL;
int success, total;

void reset_system(){
	alt_write_word(mult_control+1, 0x1); //assert reset
	while(!(alt_read_word(mult_control+1) & 0x1));
	
	printf("Reset done. Deasserting signal\n");
	while((alt_read_word(mult_control+1) & 0x1));//deassert	
}

void copy_to_input(uint32_t a, uint32_t b){
	
	alt_write_word(mult_data, a); //write to unit
	alt_write_word(mult_data+1, b); //write to unit

	//start conversion
	alt_write_word(mult_control, 0x00000001); 

	//double check that start was asserted
	while(!(alt_read_word(mult_control) & 0x1));
	
	printf("Start successful\n");
}

void copy_output(){
	uint32_t word, op1, op2; 
	//wait for done	
	printf("waiting for done\n");
	while(!(alt_read_word(mult_control+2) & 0x1));

	printf("conversion done\n");
	word = alt_read_word(mult_data+0);
	op1 = alt_read_word(mult_data+1); 
	op2 = alt_read_word(mult_data+2);
	printf("0x%08x * 0x%08x = 0x%08x. [Expected] 0x%08x\n",  op1, op2, word, (op1*op2));
	if(word == (op1*op2)){
		printf("[SUCCESSFUL]\n");
		success++;
	}else{
		printf("[FAILED]\n");
	}
	total++;
	printf("------------------------------------------------\n");
	
}

int main(int argc, char **argv){
	int fd, i;
	void *virtual_base; 
	success = 0; total = 0;
	
	//map address space of fpga for software to access here
	if((fd = open("/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	virtual_base =  mmap( NULL, LW_SIZE, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, LWHPS2FPGA_BASE);

	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return(1);
	}

	//initialize the addresses
	mult_control = virtual_base + ((uint32_t)( MULT_CONTROL_0_BASE) );
	mult_data = virtual_base + ((uint32_t)(MULT_DATA_0_BASE));
	
	printf("------>Finished initializing HPS/FPGA system<-------\n");

	for(i = 1; i < 31; i++){
	printf("---------------- Iteration %d ------------------\n", i);
		reset_system();
		copy_to_input((uint32_t)i, (uint32_t)i+1);		
		copy_output();	
	}	
	printf("[TEST PASSED] %d/%d\n", success, total);

	// clean up our memory mapping and exit
	if( munmap( virtual_base, LW_SIZE) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	close( fd );

	
	return 0;

}
