
#include "xil_printf.h"
#include "xparameters.h"
#include "xuartlite.h"
#include "xtmrctr.h"
#include "sleep.h"
#include "math.h"
#include "stdlib.h"
#include "SHA_3.h"

#define SHA3_ADDR XPAR_SHA_3_0_S00_AXI_BASEADDR
#define BUFFER_SIZE 16
#define UART_ID XPAR_AXI_UARTLITE_0_DEVICE_ID
#define TIMER_ID XPAR_AXI_TIMER_0_DEVICE_ID

// UART read buffer
u8 RecvBuffer[BUFFER_SIZE];

XUartLite UART;
XTmrCtr TIMER;

/* Read AXI registers
 @mode : integer: 0-3 denote the SHA-3 hash modes.
			0 - SHA3-224 hash output
			1 - SHA3-256 hash output
			2 - SHA3-384 hash output
			3 - SHA3-512 hash output
 @inout : boolean: true/false denotes reading input or output registers
			true  - Read SHA-3 input registers
			false - Read SHA-3 output registers
*/
void ReadRegisters(int mode, bool inout)
{
	int val;
	int outReg;

	if( inout )
	{
		// Read 1152 bits from input registers
		for( int i = 0; i < 36; i++)
		{
			val = SHA_3_mReadReg(SHA3_ADDR, i * 4);
			usleep(10);
			xil_printf("%08llx", val);
		}
		xil_printf("\n");
	}
	else
	{
		switch(mode)
		{
			case 0 : outReg = 36 + 7;  break;	// Read 224 bits from output registers
			case 1 : outReg = 36 + 8;  break;	// Read 256 bits from output registers
			case 2 : outReg = 36 + 12; break;	// Read 384 bits from output registers
			case 3 : outReg = 36 + 16; break;	// Read 512 bits from output registers
			default: outReg = 36 + 7; 			// Default read 224-bits
		}

		for( int i = 36; i < outReg; i++)
		{
			val = SHA_3_mReadReg(SHA3_ADDR, i * 4);
			usleep(10);
			xil_printf("%08llx", val);
		}
		xil_printf("\n");
	}

}

void ReadInputTXT()
{
	int val;
	// Read data from input registers
	for( int i = 0; i < 36; i++)
	{
		val = SHA_3_mReadReg(SHA3_ADDR, i * 4);
		usleep(10);
		for( int j = 3; j >= 0; j--)				// Read each byte (letter) individually
		{
			char value = (val >> (j * 8)) & 0xFF;	// Mask/shift according to which letter
			if( value == 0x06 )						// Check if it the end of the message (0x06 pad),
			{										// break if so
				xil_printf("\n");
				return;
			}
			else
				xil_printf("%c", value);
		}
	}
}

void ReadUART()
{
	uint32_t UART_8Byte = 0;			// 32-bit (8-byte) data for each loop when reading UART
	uint8_t UART_Value;					// Returned (8-bit) ASCII data from UART buffer
	int UART_Counter = 0;				// Counter for measuring 8-bytes from UART

	int Msg_Counter = 0;		// Counter for measuring amount of messages (8-bytes) have been received
	bool EarlyEnter = false;	// Boolean for flag when an "Enter" was given before all 1152 bits are received (pads rest with 0s).

	XUartLite_ResetFifos(&UART);	// Clear UART FIFO of any old data

	while( Msg_Counter != 36 )		// Message count stops at 36 (4-byte * 36 = 1152 bits)
	{
		if( EarlyEnter )			// Pad rest of registers with 0s if "Enter" is given before all messages are received.
		{
			SHA_3_mWriteReg(SHA3_ADDR, Msg_Counter * 4, 0);
			Msg_Counter++;
		}
		else if(XUartLite_Recv(&UART, &UART_Value, 1) == 1)	// Poll UART until a character is available
		{
			if( UART_Value == 13 )			// Check if enter key was the input, send 0 to register and set EarlyEnter flag as true
			{
				UART_8Byte += 6; 			// Pad 0x06 at end of message
				if( UART_Counter == 0 )
					UART_8Byte = UART_8Byte << 24;
				else
					UART_8Byte = UART_8Byte << (8 * (4 - UART_Counter - 1));
				SHA_3_mWriteReg(SHA3_ADDR, Msg_Counter * 4, UART_8Byte);
				Msg_Counter++;
				EarlyEnter = true;
			}
			else
			{
				UART_8Byte += UART_Value;				// Add UART value to current message
				UART_Counter += 1;						// Increment UART byte counter
				if( UART_Counter != 4 )
					UART_8Byte = UART_8Byte << 8;		// Shift value for current message to the left to account for next 4-bit hex value.
			}

			// Check if 4-bytes were read by UART OR if the message is about to max size, send the data to the AXI register. Reset values and increment message counter.
			if( ((Msg_Counter == 35 && UART_Counter == 3) || UART_Counter == 4) && !EarlyEnter )
			{
				if(Msg_Counter == 35 && UART_Counter == 3)
					UART_8Byte += 6;
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
	XTmrCtr_Initialize(&TIMER, TIMER_ID);

	while(1)
	{
		XTmrCtr_Reset(&TIMER, 0);	// Reset Timer to 0
		xil_printf("*****Insert input message (TEXT)******");
		xil_printf("\n\r");
		usleep(1500);	// Delay to allow UART print to catch up

		// Read text input from UART
		ReadUART();

		// Control register (slv_reg100) for starting the encryption
		uint32_t go = 0x1;
		uint32_t stop = 0x0;
		uint32_t ready = 0x2;
		uint32_t time;
		// Start encryption and timer
		SHA_3_mWriteReg(SHA3_ADDR, SHA_3_S00_AXI_SLV_REG52_OFFSET, go);
		XTmrCtr_Start(&TIMER, 0);

		while( !(SHA_3_mReadReg(SHA3_ADDR, SHA_3_S00_AXI_SLV_REG53_OFFSET) & 0x1) ); // Wait for done flag from SHA-3 IP

		time = XTmrCtr_GetValue(&TIMER, 0); // Grab timer value

		// Stop encryption
		SHA_3_mWriteReg(SHA3_ADDR, SHA_3_S00_AXI_SLV_REG52_OFFSET, stop);
		usleep(5);
		// Ready core
		SHA_3_mWriteReg(SHA3_ADDR, SHA_3_S00_AXI_SLV_REG52_OFFSET, ready);

		// Calculate and print timer value
		xil_printf("Clock cycles (10 ns) : %u\n", time);

		// Computation is done by now (10 us more than enough)
		// Read and print value inputted into algorithm

		// Display the input message as hex
		xil_printf("Input MSG (HEX): ");
		ReadRegisters(0, true);
		xil_printf("\n\r");

		// Display the input message as text
		xil_printf("Input MSG (TXT): ");
		ReadInputTXT();
		xil_printf("\n\r");

		// Display the output hashes for all 4 modes
		// SHA3-224
		xil_printf("Output Hash (224 bits): ");
		ReadRegisters(0, false);
		// SHA3-256
		xil_printf("Output Hash (256 bits): ");
		ReadRegisters(1, false);
		// SHA3-384
		xil_printf("Output Hash (384 bits): ");
		ReadRegisters(2, false);
		// SHA3-512
		xil_printf("Output Hash (512 bits): ");
		ReadRegisters(3, false);
		xil_printf("\n\n\r");
	}

	return 0;
}
