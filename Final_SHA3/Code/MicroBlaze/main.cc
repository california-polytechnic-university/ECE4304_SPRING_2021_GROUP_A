
#include "xil_printf.h"
#include "xparameters.h"
#include "xuartlite.h"
#include "sleep.h"
#include "math.h"
#include "stdlib.h"
#include "SHA_3.h"

#define SHA3_ADDR XPAR_SHA_3_0_S00_AXI_BASEADDR
#define BUFFER_SIZE 16
#define UART_ID XPAR_AXI_UARTLITE_0_DEVICE_ID
// UART read buffer
u8 RecvBuffer[BUFFER_SIZE];
uint32_t values[50];
XUartLite UART;


void Read1600Bits()
{
	uint32_t UART_8Byte = 0;			// 32-bit (8-byte) data for each loop when reading UART
	uint8_t UART_Value;					// Returned (8-bit) ASCII data from UART buffer
	int UART_Counter = 0;				// Counter for measuring 8-bytes from UART
	char valuechar[2] = { '0', '\0'};	// Char array used for strtol conversion from string to hex integer

	int Msg_Counter = 0;		// Counter for measuring amount of messages (8-bytes) have been received
	bool EarlyEnter = false;	// Boolean for flag when an "Enter" was given before all 1600 bits are received (pads rest with 0s).

	XUartLite_ResetFifos(&UART);	// Clear UART FIFO of any old data

	while( Msg_Counter != 50 )	// Message count stops at 50 (8-byte * 50 = 1600 bits)
	{
		if( EarlyEnter )	// Pad rest of registers with 0s if "Enter" is given before all messages are received.
		{
			SHA_3_mWriteReg(SHA3_ADDR, Msg_Counter * 4, 0);
			Msg_Counter++;
		}
		else if(XUartLite_Recv(&UART, &UART_Value, 1) == 1)	// Poll UART until a character is available
		{
			valuechar[0] = '0';	// Reset char array
			if( (UART_Value >= 48 && UART_Value <= 57) ||
				(UART_Value >= 65 && UART_Value <= 70) ||
				(UART_Value >= 97 && UART_Value <= 102))	// Make sure input text is valid hex (0-9, a-f, A-F)
			{
				valuechar[0] = (char)UART_Value;			// Take the 8-bit ASCII integer from UART input and convert to string using char array.
				UART_8Byte = UART_8Byte << 4;				// Shift value for current message to the left to account for incoming 4-bit hex value.
				UART_8Byte += (uint32_t)strtol(valuechar, NULL, 16);	// Use strtol to get the integer value of the hex string input. Add to current message.
				UART_Counter += 1;							// Increment UART byte counter
			}
			else if( UART_Value == 13 )		// Check if enter key was the input, send 0 to register and set EarlyEnter flag as true
			{
				SHA_3_mWriteReg(SHA3_ADDR, Msg_Counter * 4, 0);
				Msg_Counter++;
				EarlyEnter = true;
			}

			if( UART_Counter == 8 )			// Check if 8-bytes were read by UART, send the data to the AXI register. Reset values and increment message counter.
			{
				SHA_3_mWriteReg(SHA3_ADDR, Msg_Counter * 4, UART_8Byte);
				UART_Counter = 0;
				UART_8Byte = 0;
				Msg_Counter++;
			}
		}
	}

}

int main()
{
	// Initialize UART
	XUartLite_Initialize(&UART, UART_ID);

	while(1)
	{
		xil_printf("*****Input 1600 bit \"prepared\" message in hex******");
		xil_printf("\n\r");

		// Read 1600 bits (hex input) from UART
		usleep(2000);	// Delay to allow UART print to catch up
		Read1600Bits();

		// Control register (slv_reg100) for starting the encryption
		uint32_t go = 0x1;
		uint32_t stop = 0x0;
		uint32_t ready = 0x2;
		// Start encryption
		SHA_3_mWriteReg(SHA3_ADDR, SHA_3_S00_AXI_SLV_REG100_OFFSET, go);
		usleep(5);
		// Stop encryption
		SHA_3_mWriteReg(SHA3_ADDR, SHA_3_S00_AXI_SLV_REG100_OFFSET, stop);
		usleep(5);
		// Ready core
		SHA_3_mWriteReg(SHA3_ADDR, SHA_3_S00_AXI_SLV_REG100_OFFSET, ready);

		// Computation is done by now (10 us more than enough)

		// Read and print value inputted into algorithm
		uint32_t val;
		xil_printf("Input MSG (1600 bits): ");
		for( int i = 0; i < 50; i++)
		{
			val = SHA_3_mReadReg(SHA3_ADDR, i * 4);
			usleep(400);
			xil_printf("%08llx", val);
		}
		xil_printf("\n\n\r");

		// Read and print output hash
		xil_printf("Output hash (256 bits): ");
		for( int i = 99; i > 99 - 8; i--)
		{
			val = SHA_3_mReadReg(SHA3_ADDR, i * 4);
			usleep(400);
			xil_printf("%08llx", val);
		}

		xil_printf("\n\n\n\r");
		sleep(1);
	}

	return 0;
}
