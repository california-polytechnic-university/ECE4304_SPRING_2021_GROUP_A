# Lab 1 - Generic Nx1 Mux
Submitted by Group A - Yuta Akiya, Kyle Le, Megan Luong

## Description
 A generic Nx1 mux is made using a network of 2x1 muxes and for loops. This is then tested as a 64x1 mux in the testbench and 16x1 in hardware demo on the Nexys A7 100T FPGA board.
 For the simulation, the testbench included the use of the textio library for importing a stream of inputs to the simulation and storing the output into a separate text file.

## Nx1 Testbench Description
### Edge Case Testing
Tested edge case of the Nx1 mux when N is not a power of 2. Tested with a 13x1 Mux
* Input file: lab1_edge_input.txt 
* Output file: lab1_edge_output.txt

### 64x1 Testing
Tested values for a 64x1 mux
* Input file: lab1_64x1_inputs.txt 
* Output file: lab1_64x1_outputs.txt 

## Video Demonstration Link
https://youtu.be/wjK51PRZtYM 
