#Utility 
.data
youTyped: .asciiz "\nYou typed "
stringRead: .asciiz ""
.include "LegitimateList.asm"

#Get random int in range
.macro getRand(%intMin, %intMax, %registerToStore)
	li $a0, 1	
	li $a1, 26		# generates random number in $a1, with the counter 26 being the upper bound
	li $v0, 42		# random int range, $a0 contains pseudorandom int value
	syscall
	move %registerToStore, $a0
.end_macro

.macro seedRand()
	li	$v0, 30		# get time in milliseconds 
	syscall
	move	$t0, $a0	# save the lower 32-bits of time
				# seed the random generator 
	li	$a0, 1		# random generator id (will be used later)
	move 	$a1, $t0	# seed from time
	li	$v0, 40		# seed random number generator syscall
	syscall
.end_macro

#Print a string
.macro printStr(%address)
li $v0, 4
la $a0, %address
syscall
.end_macro

#Print an integer
.macro printInt(%regStoringInt)
lw $a0, (%regStoringInt)
li $v0, 1
syscall
.end_macro

#Print a character
.macro printChar(%register)
move $a0, %register
li $v0, 11
syscall
.end_macro 

#Get an integer input
.macro getInt(%registerToStore)
li $v0, 5
syscall
move %registerToStore, $v0
.end_macro

#Get a string input
.macro getStr(%registerToStore, %maxChars)
la $a0, (%registerToStore)
li $a1, %maxChars
li $v0, 8
syscall
.end_macro

#Newline
.macro endl
li $a0, 10
li $v0, 11
syscall
.end_macro

#For loop for macros
.macro for (%registerToIterate, %from, %to, %macro)
add %registerToIterate, $zero, %from
Loop:
%macro()
add %registerToIterate, %registerToIterate, 1
ble %registerToIterate, %to, Loop
.end_macro

.macro strLength(%regToStoreLength, %regStoringStringAddress)
li %regToStoreLength, 0 # initialize the count to zero
la $a0, (%regStoringStringAddress)
strLenLoop:
lb $t8, 0($a0) # load the next character into t1
beq $t8, 10, exitStrLen # check for the LF character signify end of string that was entered.
beq $t8, 0, exitStrLen # check for the NULL character signify end of string that was entered.
addi $a0, $a0, 1 # increment the string pointer
addi %regToStoreLength, %regToStoreLength, 1 # increment the count
j strLenLoop # return to the top of the loop
exitStrLen:
.end_macro

.macro printScoreWorth(%regStoringAddressOfString)
strLength($t0,%regStoringAddressOfString)
move $a0, $t0
li $v0, 1
syscall
.end_macro

.macro checkWordWithDict(%registerToStoreResult, %regStoringAddressOfWord)
.include "wordValidator.asm"
.end_macro

.macro populateLegitimateLists(%randomLetterAddressReg,%numberOfAvailWordsReturnReg)
.include "letterValidator.asm"
.end_macro


