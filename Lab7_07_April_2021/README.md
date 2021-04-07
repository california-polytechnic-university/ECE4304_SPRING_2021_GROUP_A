# Lab 7 - ALU/Barrel Rotator/UART System
Submitted by Group A - Yuta Akiya, Kyle Le, Megan Luong

## Description
The system incorporates many of the past labs together. The system uses UART to write an 8-bit value to either FIFO buffer A or B. These values are then pushed using a button so that the system is updated. These two values are displayed on the 7-segment display as hex. Switches on the board are able to rotate the values if needed. Values A and B are connected to an ALU, which has 4 modes of operation: addition, subtraction, multiplication, and division. The result of the operation is also displayed on the 7-segment display. There are also status LEDs which return the FIFO status for A and B, as well as ALU flags.

1. UART
    * Data loaded into FIFOs
    * One switch controls if UART is loading into FIFO A or FIFO B
    * 9600 Baud Rate
2. Barrel Rotator
    * Three switches for each value dictates how much it is rotated by (default rotate left)
3. ALU
    * Takes resulting value from barrel rotator and applies ALU arithmetic
    * Three modes:
        * 0 - Addition
        * 1 - Subtraction
        * 2 - Multiplication
        * 3 - Division
4. 7-Segment Display
    * Displays in hex
    * Displays value from barrel rotator for value A and value B
    * Displays result from ALU
5. LEDs
    * Displays empty and full flags for FIFOs A and B
    * Displays ALU result flags
        * Negative LED for negative output
        * Error LED for divide by 0 output

## Video Demonstration Link
https://youtu.be/0Qc3oRGGkxc
