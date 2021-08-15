# CS-271-Portfolio-Project
String Primitives and Macros

CS271 Portfolio Project
This was my final project for CS271 - Computer Architecture and Assembly Language

Overview
The main objective of this project was to practice writing lowlevel I/O procedures and Marcos in MASM x86 Assembly Language.

The program demonstrates this by asking the user to enter 10 signed integers, validating the character input and storing as signed decimals integers in an array, reading back out the integers as characters, and then finally calculating and displaying the sum and average.

Features
getString Macro
Setups the system stack to save keyboard input using the Irvine ReadString procedure

displayString Macro
Setups the system stack to display character output using the Irving WriteString procedure

readVal Procedure
Reads keyboard character input, validates and converts to a signed decimal integer

writeVal Procedure
Reads a signed decimal integer and converts to a string of characters
