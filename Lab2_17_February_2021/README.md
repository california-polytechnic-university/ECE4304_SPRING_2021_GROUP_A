# Lab 2 - Generic Nx(2^N) Decoder with Limited I/O
Submitted by Group A - Yuta Akiya, Kyle Le, Megan Luong

## Description
 A generic Nx(2^N) decoder is made using a network of 2x4 decoders and for loops. This is then tested as a 5x32 decoder in the testbench as well as in hardware a demo on the Nexys A7 100T FPGA board.
 For the simulation, the testbench included the use of the textio library for importing a stream of inputs to the simulation and storing the output into a separate text file.

# Board Implementation
Since the Nexys A7 100T FPGA only has 16 LED outputs, the generic Nx1 mux from Lab 1 must be modified to accept N bits in order to cycle between the 32 inputs of the 5x32 decoder.

## Video Demonstration Link
https://youtu.be/cjkCATmSFAQ
