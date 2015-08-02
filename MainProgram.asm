			.data
numberOfCharacters: 	.word	0
welcomePrompt:		.asciiz "\n================================\n Welcome to The Nerds Jumbline! \n================================\n"
promptChar: 		.asciiz  "Choose the number of characters to play with (5,6, or 7): "
alphabet: 		.asciiz "abcdefghijklmnopqrstuvwxyz"
.align  3
randomLetterArray:                  .space 7
theChar:		.word   0
space:			.asciiz "\n"
vowel:			.asciiz "aeiou"
			.include "UtilityMacros.asm"
			.text
   
MainProgramStart:
	printStr(welcomePrompt)
	printStr(promptChar)
	
	getInt($t4)
	
	bgt $t4, 7, MainProgramStart	#error check if user inputs number greater than 7
	blt $t4, 5, MainProgramStart	#error check if user inputs number less than 5
	 
	sw   $t4, numberOfCharacters	# stores the integer in the memory location numberOfcharacters
	
	add $t7, $t4, $zero 		# counter
	
	la $s0, alphabet 		# pointer to alphabet
	
	jal GenerateRandomLetters
	j GuessLoop
	
###################################################################
# print out a random sort of characters and store them into an array
##################################################################
	GenerateRandomLetters:
	la $s0, alphabet
	lw $t7, numberOfCharacters
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal ClearRandomLetterArray
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	seedRand()
	
	LetterLoop:
	la $s0, alphabet
	li $a0, 1	
	li $a1, 26		# generates random number in $a0, with the counter 26 being the upper bound (it is exclusive)
	li $v0, 42		# random int range, $a0 contains pseudorandom int value
	syscall			

	add $t1, $s0, $a0 	# add string pointer by random number in $a0, store this new address in $t1
	
	beq $t7, 2, vowelAppend # branch to vowelAppend once the second to last character will be generated
	
	j charStore		# jump to charStore
	
	vowelAppend:		# at least one character in the array will be a vowel 
	beq $t7, 1, charStore
	la $s1, vowel
	li $a0, 1	
	li $a1, 5		# generates random number in $a0, with the counter 5 being the upper bound (it is exclusive)
	li $v0, 42		# random int range, $a0 contains pseudorandom int value
	syscall		
		
	add $t1, $s1, $a0
	
        charStore:
	lbu  $t2, ($t1)		# isolates that bytesized char, puts it into $t2
	sw   $t2, theChar
	
	lw $a0, theChar
	
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	jal AppendCharToRandomArray	# jump to arrayStorage
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	addi $sp, $sp, 16
	
	addi $t7, $t7, -1 	 # decrement counter
	
	bgt $t7, 0, LetterLoop
	la $t3, randomLetterArray
	populateLegitimateLists($t3,$s7)
	jr $ra
##########################################################
# Function to do a permutation of the randomLetterArray
##########################################################
	DoPermute:
	seedRand()
	la $t0, randomLetterArray
	
	lw $t9, numberOfCharacters

	add $t3, $t0, $0
	sub $t9, $t9, 1
	add $t3, $t9, $0	#$t3 points to last element in array
	add $t9, $t9, 1
################################################
# Code to rearrange the charcters 
################################################	
	Permuteloop:
	li   $a0, 0
	move $a1, $t9		# generates random number in $a1, with the numberOfcharacters  being the upper bound
	li   $v0, 42		# random int range, $a0 contains pseudorandom int value
	syscall
	
	la  $t4, randomLetterArray		# load address of array into register $t4
	add $t1, $t4, $a0	# set register $t1 to point to random element in the array
	lb  $t5, 0($t1)		# load a character from random index in the array into register $t5
	lb  $t6, 0($t0)		# load a character from sequential index in the array into register $t3
	sb  $t5, 0($t0)		# store the character that was randomly pointed to into the sequential index
	sb  $t6, 0($t1)		# store the character that was sequentially pointed to into the random index
	addi $t0, $t0, 1		# point to next index in the array
	ble  $t0, $t3, Permuteloop	# once the array points the last index stop looping
	jr $ra
	
################################################
#storing characters in array
################################################	
	AppendCharToRandomArray:
	la $t0, randomLetterArray
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	strLength($t1, $t0)
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	add $t0, $t0, $t1
	sb $a0, 0($t0)
	jr $ra
	
	ClearRandomLetterArray:
	la $t0, randomLetterArray
	resetCharLoop:
	lbu $t2, ($t0)
	beqz $t2, doneWithReset
	sw $zero, ($t0)
	addi $t0, $t0, 1
	j resetCharLoop
	doneWithReset:
	jr $ra
	
	
	.include "GuessLoop.asm"

