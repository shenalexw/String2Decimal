# String Primitives and Macros 💾 

## Table of Contents
- [Abstract](#Abstract)
- [How To Use](#how-to-use)
- [References](#references)
- [Author(s)](#author-info)


## Abstract
CS271 Computer Architecture & Assembly Language - Portfolio Project

### Program Description
Write and test a MASM program to perform the following tasks (check the Requirements section for specifics on program modularization):
- Implement and test two macros for string processing. These macros may use Irvine’s ReadString to get input from the user, and WriteString procedures to display output.
    - mGetString:  Display a prompt (input parameter, by reference), then get the user’s keyboard input into a memory location (output parameter, by reference). You may also need to provide a count (input parameter, by value) for the length of input string you can accommodate and a provide a number of bytes read (output parameter, by reference) by the macro.
    - mDisplayString:  Print the string which is stored in a specified memory location (input parameter, by reference).
- Implement and test two procedures for signed integers which use string primitive instructions
    - ReadVal: 
        - Invoke the mGetString macro (see parameter requirements above) to get user input in the form of a string of digits.
        - Convert (using string primitives) the string of ascii digits to its numeric value representation (SDWORD), validating the user’s input is a valid number (no letters, symbols, etc).
        - Store this one value in a memory variable (output parameter, by reference). 
    - WriteVal: 
        - Convert a numeric SDWORD value (input parameter, by value) to a string of ascii digits
        - Invoke the mDisplayString macro to print the ascii representation of the SDWORD value to the output.
- Write a test program (in main) which uses the ReadVal and WriteVal procedures above to:
    - Get 10 valid integers from the user. Your ReadVal will be called within the loop in main. Do not put your counted loop within ReadVal.
    - Stores these numeric values in an array.
    - Display the integers, their sum, and their average by using your WriteVal procedure.
- Your ReadVal will be called within the loop in main. Do not put your counted loop within ReadVal.

## How To Use

### Installation

Use Microsoft Visual Studio Enterprise to open without debbugging.

## References

- [x86 Assembly Language - User Input and Custom Functions](https://www.youtube.com/watch?v=9A2B2lpBzbg)

## Author Info
#### Alexander Shen - Developer
- [LinkedIn](https://www.linkedin.com/in/shenalexw/)
- [Portfolio Website](https://shenalexw.github.io/)
