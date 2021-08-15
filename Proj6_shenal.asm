TITLE PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures     (Proj6_shenal.asm)

; Author: Alexander Shen
; Last Modified: 06/06/21
; OSU email address: shenal@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 06/06/21
; Description: This is a program testing the abilities of using macros along with string primitives
; The user will input 10 valid numbers into the program and in return they will recieve
; A list of numbers input, followed by their average and their sum.
; Although simple the program is done without using IRVINE'S procedures.
; The string is recieved from the user and will go through string primitives to become a number and placed into an array.
; the array will then be manipulated to return the results by turning the numbers back into strings.
; In order to take or display string, we use the macros mGetString and mDisplayString.

INCLUDE Irvine32.inc

; This limit is for reference and is not used in the program.
LIMIT = 2147483647

; The arraysize will change the number of times readval is called.
ARRAYSIZE = 10

; ---------------------------------------------------------------------------------
; Name: mGetString Macro
;
; Postconditions: EAX, ECX, and EDX changed.
;
; Recieves:
;	prompt = prompt message to retrieve a number from the user
;	buffer = string memory location to store the input string from the user
;	count = the number of characters the user inputted after ReadString
;
; Returns: The buffer will not contain the string from the user and the count will represent how large the number is.
; ---------------------------------------------------------------------------------
mGetString	MACRO buffer, max, count
	; Push EAX, ECX and EDX onto the memory stack.
	PUSH	EAX
	PUSH	ECX
	PUSH	EDX

	; Retrieve the string from the user
	MOV		EDX, buffer 
	MOV		ECX, max
	call	ReadString 
	MOV		count, EAX

	; POP EAX, ECX, AND EDX back into their memory.
	POP		EDX
	POP		ECX
	POP		EAX

ENDM

; ---------------------------------------------------------------------------------
; Name: mDisplayString Macro
;
; Postconditions: EDX changed.
;
; Recieves: 
;	buffer = string memory location that the program will write the string from.
;
; Returns: Displays the buffer string for the user.
; ---------------------------------------------------------------------------------
mDisplayString	MACRO buffer
	; Push EAX, ECX and EDX onto the memory stack.
	PUSH	EDX

	; Display the buffer for the user
	MOV		EDX, buffer
	Call	WriteString

	; POP EAX, ECX, AND EDX back into their memory.
	POP		EDX

ENDM

.data

intro_1			BYTE		"Designing low-level I/O procedures", 0
intro_2			BYTE		"Written by: Alexander Shen", 0
intro_3			BYTE		"Please provide 10 signed decimal integers.", 0
intro_4			BYTE		"Each number needs to be small enough to fit inside a 32 bit register.", 0
intro_5			BYTE		"After your inputs, I will display a list of the integers, their sum, and their average value.", 0
intro_6			BYTE		"Note that the input will only allow up to 11 character inputs.", 0
prompt_1		BYTE		"Please enter an signed number: ", 0
error_msg		BYTE		"ERROR: You did not enter a signed number or your number was too big. ", 0
list_msg		BYTE		"This is the list of numbers: ", 0
avg_msg			BYTE		"This is the average of the array: ", 0
sum_msg			BYTE		"This is the sum of the array: ", 0
goodbye			BYTE		"Thank you for playing!",0 
comma			BYTE		", ", 0
instring		BYTE		21 DUP (0)
outstring		BYTE		21 DUP (0)
numarray		SDWORD		ARRAYSIZE DUP(0)
sum				SDWORD		?
avg				SDWORD		?
tempnum			SDWORD		?
bytecount		SDWORD		?
arraycount		DWORD		?
restart			DWORD		0
reverse			BYTE		21 DUP (0)

.code
main PROC

	; Display all introductions 
	PUSH	OFFSET intro_6
	PUSH	OFFSET intro_1
	PUSH	OFFSET intro_2
	PUSH	OFFSET intro_3
	PUSH	OFFSET intro_4
	PUSH	OFFSET intro_5
	CALL	introduction

	; Set the counter for 10 numbers for the loop.
	MOV		ECX, ARRAYSIZE

_retrieve:
	; Push the counter into the stack and retrieve it after readval.
	PUSH	ECX

	; Retrieve a string from the user and validate if it is a valide number
	PUSH	OFFSET restart
	PUSH	OFFSET numarray
	PUSH	OFFSET arraycount
	PUSH	OFFSET tempnum
	PUSH	OFFSET error_msg
	PUSH	OFFSET prompt_1
	PUSH	OFFSET instring
	PUSH	SIZEOF instring
	PUSH	bytecount
	CALL	readval

	; Pop the counter back into ECX
	POP		ECX
	
	; If there was an error input then add 1 to the counter.
	CMP		restart, 1
	JE		_restart
	JMP		_continue

_restart:
	; If an error has occuredc then add 1 to the counter for the loop.
	INC		ECX

_continue:
	LOOP	_retrieve

	; Subprocedures below will help with displaying the desired contents of the array.

	; Display the list of numbers
	PUSH	OFFSET tempnum
	PUSH	OFFSET reverse
	PUSH	OFFSET outstring
	PUSH	OFFSET list_msg
	PUSH	OFFSET comma
	PUSH	OFFSET numarray
	PUSH	ARRAYSIZE
	CALL	displayList

	; Display the sum of the array
	PUSH	OFFSET reverse
	PUSH	OFFSET outstring
	PUSH	OFFSET sum_msg
	PUSH	OFFSET sum
	PUSH	OFFSET numarray
	PUSH	ARRAYSIZE
	CALL	displaysum

	; Display the average of the array.
	PUSH	OFFSET reverse
	PUSH	OFFSET outstring
	PUSH	ARRAYSIZE
	PUSH	OFFSET avg_msg
	PUSH	OFFSET sum
	PUSH	OFFSET avg
	CALL	displayavg

	;Extra Space
	CALL	Crlf
	CALL	Crlf
	
	; Say Goodbye
	PUSH	OFFSET goodbye
	CALL	seeya

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: Introduction
;
; Displays an introduction message containing the title and author of the program.
; Displayes the description of the duties of the program.
;
; Postconditions: EDX changed
;
; Recieves: 
;	[EBP + 28] - intro_6 = Limit to how many characters can be input.
;   [EBP + 24] = intro_1 = title of the program
;	[EBP + 20] = intro_2 = author of the program
;	[EBP + 16] = intro_3 = prompt the user to input 10 signed values
;	[EBP + 12] = intro_4 = let user know that the number must fit in a 32 bit register
;	[EBP + 8] = intro_5 = let the user know that they will display the numbers, the sum, and average.
;
; Returns: Displays introduction messages to the user.
; ---------------------------------------------------------------------------------
introduction PROC
	; PUSH EBP into the stack and Set EBP as ESP
	PUSH	EBP 
	MOV		EBP, ESP 

	; Display the title of the program
	mDisplayString	[EBP + 24]
	CALL	Crlf

	; Display the author of the program.
	mDisplayString	[EBP + 20]
	CAll	Crlf

	; Extra Space
	CAll	Crlf

	; Display what the user needs to input.
	mDisplayString	[EBP + 16]
	CAll	Crlf

	; Display the constraints the user has when inputting their numbers.
	mDisplayString	[EBP + 12]
	Call	Crlf

	; Display to the user that only 11 characters will be taken from the program.
	mDisplayString	[EBP + 28]
	CALL	Crlf

	; Display the actions of the program.
	mDisplayString	[EBP + 8]
	CAll	Crlf
	CALL	Crlf

	; Return back to the original address.
	POP		EBP 
	RET		24

introduction ENDP

; ---------------------------------------------------------------------------------
; Name: readval
;
; Retrieve a valid signed number from the user.
; If it is not a valid number display an error message for the user and try again.
; If the number is valid add the number to the next open spot in the array.
;
; Postconditions: EAX, EBX, ECX, EDX, EDI, ESI changed
;
; Recieves: 
;	[EBP + 40] = restart = if an error message was prompted then add one to the outside ecx counter.
;	[EBP + 36] = numarray = Array that holds all the numbers
;	[EBP + 32] = arraycount = provides the correct spacing to place the next number in the array.
;	[EBP + 28] = temp_num = temporary place holder for the num converted.
;   [EBP + 24] = error_msg = String to notify the user that an error has occured.
;	[EBP + 20] = prompt_1 = Display the prompt for the user to input a number.
;	[EBP + 16] = instring = buffer string to retrieve a number from the user.
;	[EBP + 12] = The size of the number that can be inputed from the user.
;	[EBP + 8] = bytecount = amount of character the user inputed.
;
; Returns: Retrieves the number from the user and updates the numarray with a SDWORD value.
; ---------------------------------------------------------------------------------
readval PROC
	CLD
	; PUSH EBP into the stack and Set EBP as ESP
	PUSH	EBP 
	MOV		EBP, ESP 

	; Restart the restart counter.
	MOV		EAX, [EBP + 40]
	MOV		EBX, 0
	MOV		[EAX], EBX

	; Display the prompt for the user to input a number.
	mDisplayString	[EBP + 20]

	; Call the macro to retrieve a stirng from the user.
	mGetString	[EBP + 16], [EBP + 12], [EBP + 8]

	; Establish all necessary registers.
	MOV		ECX, [EBP + 8]
	MOV		ESI, [EBP + 16]
	MOV		EBX, 0
	MOV		EDI, [EBP + 28]
	MOV		[EDI], EBX
	MOV		EDX, 0
	
	; If the characters entered from the user is greater than 11, then display an error.
	CMP		ECX, 11
	JG		_wrong
	JMP		_stay

_stay:
	; Check if the first character is a + or a -
	LODSB
	DEC		ECX
	CMP		AL, 43
	JE		_positive
	CMP		AL, 45
	JE		_negative

	; If there is no sign then treat the first character as a positive number.
	INC		ECX
	CMP		AL, 48
	JL		_wrong
	CMP		AL, 58
	JG		_wrong
	SUB		AL,48

	; Add the character as the first one, if the input is a single digit then add it to the array.
	ADD		[EDI], AL
	CMP		ECX, 1
	JE		_addarray
	loop	_positive


_negative:
	; Multiplies the current number by 10
	MOV		EDX, 0
	MOV		EAX, [EDI]
	MOV		EBX, 10					
	MUL		EBX	

	; If the multipication causes it to go over 32 bits, then raise an error. Else, continue
	CMP		EDX, 0
	JNZ		_wrong
	MOV		[EDI], EAX							
	
	; Clear EAX
	mov		EAX, 0

	; Use string primitives to go through the string and determine if the inputs are numbers.
	LODSB							
	CMP		AL, 48
	JL		_wrong
	CMP		AL, 58
	JG		_wrong

	; If they are numbers then subtract it by 48 and put it in the number generator.
	SUB		AL, 48
	MOVSX	EBX, AL
	MOV		EAX, [EDI]

	; If the addition causes the number to go over 32 bit registry, raise an error.
	ADD		EAX, EBX
	JC		_wrong
	MOV		[EDI], EAX
	loop	_negative	
	
	; Converts the number to a negative number
	MOV		EAX, [EDI]
	NEG		EAX
	MOV		[EDI], EAX
	JMP		_addarray

_positive:
	; Multiploes the current number by 10
	MOV		EDX, 0
	MOV		EAX, [EDI]
	MOV		EBX, 10					
	MUL		EBX					
	CMP		EDX, 0
	JNZ		_wrong
	MOV		[EDI], EAX	

	; Clear EAX
	mov		EAX, 0

	; Use string primitives to go through the string and determine if the inputs are numbers.
	LODSB							
	CMP		AL, 48
	JL		_wrong
	CMP		AL, 58
	JG		_wrong
	
	; If they are numbers then subtract it by 48 and put it in the number generator.
	SUB		AL, 48
	MOVSX	EBX, AL
	MOV		EAX, [EDI]

	; If the addition causes the number to go over 32 bit registry, raise an error.
	ADD		EAX, EBX
	JC		_wrong
	MOV		[EDI], EAX

	loop	_positive					
	JMP		_addarray

_addarray:
	; Have ESI be the new value that we are putting into the array and ESI as the array address we are putting the number in.
	MOV		ESI, [EDI]
	MOV		EDI, [EBP + 36]
	MOV		EAX, [EBP + 32]

	; Space the address of the array to the next open spot.
	MOV		EBX, [EAX]
	ADD		EDI, EBX
	ADD		EBX, 4

	; Add four for the next spot of the array and place the number into the open array.
	MOV		[EAX], EBX
	MOV		[EDI], ESI

	JMP		_leave

_wrong:
	; Display an error message letting the user know that they put in the wrong number
	mDisplayString	[EBP + 24]

	; Set the restart flag to 1.
	MOV		EAX, [EBP + 40]
	MOV		EBX, 1
	MOV		[EAX], EBX

	;Extra space
	CALL	Crlf

_leave:
	POP		EBP 
	RET		36

readval ENDP

; ---------------------------------------------------------------------------------
; Name: WriteVal
;
; Given a numeral value, covert it to a string with ASCII conversion.
; Reverse the string as the base result will be backways.
;
; Postcondition: EAX, EBX, ECX, EDX, EDI, ESI were changed
;
; Recieves: 
;	[EBP + 16] = reverse, which is what the actual string should be.
;	[EBP + 12] = outstring for the string
;	[EBP + 8] = value that should be turned into a string
;
; Returns: Will display a string for the user.
; ---------------------------------------------------------------------------------
writeval PROC
	CLD
	; PUSH EBP into the stack and Set EBP as ESP
	PUSH	EBP 
	MOV		EBP, ESP 
	
	; EAX will represent the number and EDI will be where the temp string will be written
	MOV		EAX, [EBP + 8]
	MOV		EAX, [EAX]
	MOV		EDI, [EBP + 12]

	; If the number is less than 0 then append the negative sign to the string
	CMP		EAX, 0
	JE		_zero
	JL		_negative
	JMP		_positive

_negative:
	; Set ESI to 1 to make it a negative number.
	MOV		ESI, 1

	; Put EAX back as the number we are going ot iterate through.
	MOV		EAX, [EBP + 8]
	MOV		EAX, [EAX]
	NEG		EAX

	; Initialize a counter for numbers to be input
	MOV		EBX, 1
	PUSH	EBX
	JMP		_writeloop

_positive:
	; Set ESI to 0 to make it a positive number
	MOV		ESI, 0

	; Put EAX back as the number we are going ot iterate through.
	MOV		EAX, [EBP + 8]
	MOV		EAX, [EAX]

	; Initialize a counter for numbers to be input
	MOV		EBX, 0
	PUSH	EBX

_writeloop:
	; increae the counter by 1
	POP		EBX
	ADD		EBX, 1
	PUSH	EBX

	; Divide the number that you want by 10 and the remainder is now in EDX.
	MOV		EBX, 10
	MOV		EDX, 0
	CDQ
	IDIV	EBX

	; Temporary move the EAX aside so that we can write the string into the tempword.
	MOV		EBX, EAX
	MOV		EAX, EDX
	ADD		EAX, 48
	STOSB

	; move the divided number back into EAX and repeat the loop.
	MOV		EAX, EBX

	; If the number we are dividing by is 0, leave.
	CMP		EAX, 0
	JE		_reverse
	JMP		_writeLoop

_zero:
	; Display a zero and leave the funciton.
	MOV		AL, 48
	STOSB

	mDisplayString [EBP + 12]
	JMP		_out
	
_reverse:
	; If it is negative then we need to append the negative sign afterwards.
	CMP		ESI, 1
	JE		_sign
	JMP		_nosign

_sign:
	; Place the negative sign at the end of the string.
	MOV		AL, 45
	STOSB

_nosign:
	; The following reverse string was referenced from the canvass module.
	POP		EBX
	MOV		ECX, EBX
	MOV		ESI, [EBP + 12]
	ADD		ESI, ECX
	DEC		ESI
	MOV		EDI, [EBP + 16]

_revloop:
	STD
	LODSB
	CLD
	STOSB
	LOOP	_revLoop

_donewrite:
	mDisplayString [EBP + 16]

;Clear both the temp and the reserve string
	MOV		AL, 0
	MOV		ECX, EBX
	MOV		EDI, [EBP + 16]
	REP		STOSB

;Clear both the temp and the reserve string
	MOV		AL, 0
	MOV		ECX, EBX
	MOV		EDI, [EBP + 12]
	REP		STOSB

	_out:

	POP		EBP 
	RET		12
writeval ENDP

; ---------------------------------------------------------------------------------
; Name: displayList
; 
; It will loop through the array and place the number of its current iteration into tempnum
; then tempnum will be pushed with the outstring and reverse in order to CALL writeval
;
; Postcondition: EAX, EBX, ECX, EDX, EDI were changed
;
; Recieves:
;	[EBP + 8] = ARRAYSIZE
;	[EBP + 12] = address of numArray
;	[EBP + 16] = Comma, spacing inbetween numbers
;	[EBP + 20] = display title of the list to show that it is the list of all numbers.
;	[EBP + 24] = outstring, temperary outstring for the writeval.
;	[EBP + 28] = reverse = reversed string to actually output to the user.
;	[EBP + 32] = tempnum = Placeholder for the number to be converted to a string is sent to WriteBal
;
; Returns: Displays the list of numbers from the array
; ---------------------------------------------------------------------------------
displayList	Proc
	; PUSH EBP into the stack and Set EBP as ESP
	PUSH	EBP 
	MOV		EBP, ESP 

	; Set the count ECX to the size of the array and EDI to the address of the array.
	MOV		ECX, [EBP + 8]
	MOV		EDI, [EBP + 12]
	MOV		EBX, [EBP + 32]

	; Display the title in the console.
	mDisplayString	[EBP + 20]

_dlloop:
	; Move the current value into tempnum.
	MOV		EAX, [EDI]
	MOV		[EBX], EAX
	
	; Push the registries for ECX, EDI, and EBX.
	PUSH	ECX
	PUSH	EDI
	PUSH	EBX
	
	; Push the necessary addresses to WriteVal
	PUSH	[EBP + 28]
	PUSH	[EBP + 24]
	PUSH	[EBP + 32]
	CALL	WriteVal

	; Restore registers
	POP		EBX
	POP		EDI
	POP		ECX

	; If we are at the end of the displaylist, then do not print a comma.
	CMP		ECX, 1
	JE		_noextracomma
	JMP		_extracomma
_extracomma:
	; Add space inbetween the numbers and increment ESI, If ESI is 20 then we need to skip the line.
	mDisplayString	[EBP + 16]
	ADD		EDI, 4
_noextracomma:
	LOOP	_dlloop

	; Add space 
	CALL	Crlf

	; Return back to the original address.
	POP		EBP 
	RET		28

displayList	ENDP


; ---------------------------------------------------------------------------------
; Name: displaysum
; 
; It will loop through the array and summate the elements into sum.
; then sum will be pushed with the outstring and reverse in order to CALL writeval
;
; Postcondition: EAX, EBX, ECX EDX, EDI, ESI were changed
;
; Recieves:
;	[EBP + 8] = ARRAYSIZE
;	[EBP + 12] = address of numArray
;	[EBP + 16] = sum of numbers
;	[EBP + 20] = display title of the list to show that it is the list of all numbers.
;	[EBP + 24] = outstring, temperary outstring for the writeval.
;	[EBP + 28] = reverse = reversed string to actually output to the user.
;
; Returns: A list of numbers will be displayed to the user.
; ---------------------------------------------------------------------------------
displaysum PROC
	; PUSH EBP into the stack and Set EBP as ESP
	PUSH	EBP 
	MOV		EBP, ESP 

	; Set the count ECX to the size of the array and EDI to the address of the array.
	MOV		ECX, [EBP + 8]
	MOV		EDI, [EBP + 12]
	MOV		ESI, [EBP + 16]

	; Display the title in the console.
	mDisplayString	[EBP + 20]

_dsloop:
	; Move the current value at address EDI into EAX.
	MOV		EAX, [EDI]
	MOV		EBX, [ESI]
	ADD		EAX, EBX

	; Continually adds the array elements.
	MOV		[ESI], EAX
	ADD		EDI, 4
	LOOP	_dsloop

	; Push the necessary addresses to WriteVal
	PUSH	[EBP + 28]
	PUSH	[EBP + 24]
	PUSH	[EBP + 16]
	CALL	WriteVal

	; Add space
	CALL	Crlf

	; Return back to the original address.
	POP		EBP 
	RET		24
displaysum ENDP

; ---------------------------------------------------------------------------------
; Name: displayavg
;
; Divide the sum by the size of the array to find the average of the list.
; then avg will be pushed with the outstring and reverse in order to CALL writeval
;
; Recieves: 
;	[EBP + 8] = avg = keeps track  of the average of the numbers.
;	[EBP + 12] = sum = keeps track of the sum of the numbers.
;	[EBP + 16] = Message to prompt the user this is the average of the list of numbers.
;	[EBP + 20] = Size of the Array
;	[EBP + 24] = outstring, temperary outstring for the writeval.
;	[EBP + 28] = reverse = reversed string to actually output to the user
;
; Returns: Displayes the average to the user using the writeval procedure
; ---------------------------------------------------------------------------------
displayavg PROC
	; PUSH EBP into the stack and Set EBP as ESP
	PUSH	EBP 
	MOV		EBP, ESP 
	
	; Display the type of information will be displayed for the user.
	mDisplayString	[EBP + 16]

	; Set up necessary registers for division.
	MOV		ECX, [EBP + 8]
	MOV		EDX, 0
	MOV		EAX, [EBP + 12]
	MOV		EBX, [EBP + 20]

	; Divide the sum by the array size and move the contents into the avg
	MOV		EAX, [EAX]
	CDQ
	IDIV	EBX

	; The number will always round down positive so if the number is negative then round to the lowest number.
	CMP		EAX, 0
	JL		_lower
	JMP		_same

_lower:
	DEC		EAX

_same:
	; Place the new average into avg.
	MOV		[ECX], EAX

	; Move the current value at address EDI into EAX.
	PUSH	[EBP + 28]
	PUSH	[EBP + 24]
	PUSH	[EBP + 8]
	CALL	WriteVal

	; Return back to the original address.
	POP		EBP 
	RET		24
displayavg ENDP

; ---------------------------------------------------------------------------------
; Name: seeya
;
; Recieves: 
;	[EBP + 8] = goodbye = goodbye message to the user.
;
; Returns: Display's goodbye message to the user
; ---------------------------------------------------------------------------------
seeya PROC
	; PUSH EBP into the stack and Set EBP as ESP
	PUSH	EBP 
	MOV		EBP, ESP 
	
	; Display the goodbye message
	mDisplayString	[EBP + 8]
	CALL	Crlf

	; Return back to the original address.
	POP		EBP 
	RET		4

seeya ENDP



END main
