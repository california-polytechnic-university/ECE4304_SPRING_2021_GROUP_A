# Lab 2 - Generic Nx(2^N) Decoder with Limited I/O
Submitted by Group A - Yuta Akiya, Kyle Le, Megan Luong

## Description
 A generic Nx(2^N) decoder is made using a network of 2x4 decoders and for loops. This is then tested as a 5x32 decoder in the testbench as well as in hardware a demo on the Nexys A7 100T FPGA board.
 For the simulation, the testbench included the use of the textio library for importing a stream of inputs to the simulation and storing the output into a separate text file.

# Test Benches
To test the generic decoder, a text io program is used to read inputs in from a text file and write the outputs onto another text file. For the generic decode without limited I/O, a 5 bit input and a 6 bit input test cases, 5bitinputs.txt and 6bitinputs.txt, produced outputs 32bitoutputs.txt and 64bitsoutput.txt respectively. The outputs simply one hot encode the input into the decoder into a (2^input size) bit long binary output.
To test the generic decoder with limtied I/O for when the decoder is implemented onto the FPGA board, a separate testbench program is made. A top module is created to link the generic decoder to a generic mux (designed in lab 1) in order to output 16 bits of the total output at a time based on select bits. The file inputs_limited_io.txt shows the test bench inputs. Since corner cases were already verified to be cleared in the last test bench, only a 6 bit input was used. For a 6 bit input sequence, a 2 bit select is needed becasue the the mux takes in 16 bit inputs (for the 16 LEDS on the FPGA) and the total output size, 64, divided by 16 is 2^2. One test case for input 0 and one test case for input 1 is included in inputs_limited_io.txt. The outputs can be seen in outputs_limited_io.txt

# Board Implementation
Since the Nexys A7 100T FPGA only has 16 LED outputs, the generic Nx1 mux from Lab 1 must be modified to accept N bits in order to cycle between the 32 inputs of the 5x32 decoder.

## Video Demonstration Link
https://youtu.be/cjkCATmSFAQ
