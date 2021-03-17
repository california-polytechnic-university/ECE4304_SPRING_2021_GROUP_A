# Lab 5 - BCD Arithmetic Unit with Inputs/Output Display
Submitted by Group A - Yuta Akiya, Kyle Le, Megan Luong

## Description
Using two 4-bit input from the switches on the FPGA, arithmetic operations could be applied to them. By programming in an ALU with 4 math operations: addition, subtraction, multiplication, and division, an 8-bit output could be created.

Both 4-bit inputs are displayed onto a digit on the FPGA's 7-segment display, with the 8-bit result from the ALU being displayed onto two digits. Since the ALU will only be taking in BCD inputs, a toggle switch for each input is made to toggle between displaying the respective input in BCD or Hex. Also, two switches will designate which ALU operation is being done. Two status LEDs will also give information on the arithmetic output. One LED states if the result is negative, and one LED states if the result is an error (in case of divide by 0).

## Video Demonstration Link
https://youtu.be/d7PW9Jl4Mcs
