#Utility 
.data
youTyped: .asciiz "\nYou typed "
stringRead: .asciiz ""
newLine: .asciiz "\n"
.space 10
.align 2
Char1:	.word
.space 10
.align 2
Char2: 	.word
.space 10
.align 2
Char3:	.word
.space 10
.align 2
Char4: 	.word
.space 10
.align 2
Char5:	.word
.space 10
.align 2
Char6:	.word
.space 10
.align 2
Char7:	.word


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
move $a0, %regStoringInt
li $v0, 1
syscall
printStr(newLine)
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
addi $sp, $sp, -8
sw $t9, 0($sp)
sw $t8, 4($sp)
move $t9, %regStoringStringAddress
li %regToStoreLength, 0 # initialize the count to zero
strLenLoop:
lb $t8, 0($t9) # load the next character into t1
blt $t8, 48, exitStrLen # check for the LF character signify end of string that was entered.
addi $t9, $t9, 1 # increment the string pointer
addi %regToStoreLength, %regToStoreLength, 1 # increment the count
j strLenLoop # return to the top of the loop
exitStrLen:
lw $t9, 0($sp)
lw $t8, 4($sp)
addi $sp, $sp, 8
.end_macro

.macro printScoreWorth(%regStoringAddressOfString)
strLength($t0,%regStoringAddressOfString)
move $a0, $t0
li $v0, 1
syscall
.end_macro

.macro PrintList(%ListAddr, %ListWordCount)
printList:	#$a0 = listAddr, $a1 = %listWordCount # (list address, number of words saved in the list), uses t7,t1,t6
	move $t7, %ListWordCount
	move $t1, %ListAddr
	printListLoop1:
	printStr(blankByte)
	beqz $t7, printListExit
	subi $t7, $t7,1
	addi $t6, $zero, 7	# set the character counter
	printListLoop2:
	beqz $t6, printListLoop1
	subi $t6, $t6,1
	lb $t2, ($t1)
	printChar($t2)
	addi $t1, $t1, 1
	j printListLoop2
	printListExit:
	nop
.end_macro 


