
			.data
numberOfcharacters: 	.word	0
promptChar: 		.asciiz  "Choose the number of characters to play with (5,6, or 7): "
alphabet: 		.asciiz "abcdefghijklmnopqrstuvwxyz"
.align  3
array:                  .asciiz  "             "
theChar:		.word   0
space:			.asciiz "\n"
PermutePrompt:		.asciiz "Enter 1 to rearrange the letters or 2 to continue: "
			.include "UtilityMacros.asm"
			.text
   
main:
	printStr(promptChar)
	
	getInt($t4)
	
	bgt $t4, 7, main	#error check if user inputs number greater than 7
	blt $t4, 5, main	#error check if user inputs number less than 5
	 
	sw   $t4, numberOfcharacters	# stores the integer in the memory location numberOfcharacters
	
	add $t7, $t4, $zero 		# counter
	
	la $s0, alphabet 		# pointer to alphabet

	seedRand()			#utility macro to seed random number generator... uses lower 32-bit of time in milliseconds

	la  $s2, array			


	
###################################################################
# print out a random sort of characters and store them into an array
##################################################################
	loop:
	beq $t7, $0, askForPermute	# if counter == 0 go to askForPermute
	 			
	li $a0, 1	
	li $a1, 26		# generates random number in $a1, with the counter 26 being the upper bound
	li $v0, 42		# random int range, $a0 contains pseudorandom int value
	syscall			

	add $t1, $s0, $a0 	# add string pointer by random number in $a0, store this new address in $t1

	lbu  $t2, ($t1)		# isolates that bytesized char, puts it into $t2
	sw   $t2, theChar
	
	lw $a0, theChar
	jal arrayStorage	# jump to arrayStorage

	li    $v0, 11		 # system call code for Print String 
	move  $a0, $t2 		 # load address char into $a0 
	syscall      		
	
	addi $t7, $t7, -1 	 # decrement counter

	j loop 			 # loop return


##########################################################
# prompt user if they want to rearrange the characters
##########################################################
	askForPermute:			 #ask user if they want to rearrange the characters
	printStr(space)	
	
	printStr(PermutePrompt)
	
	getInt($t6)
	
	bne  $t6, 1, guessLoop		# branch to main if user did not enter 1
	la   $s2, array
	
	lw $t9, numberOfcharacters
	sub $t9, $t9, 1
	add $s3, $t9, $s2	#$s3 points to last element in array

################################################
# Code to rearrange the charcters 
################################################	
	Permuteloop:
	li   $a0, 1	
	move $a1, $t9		# generates random number in $a1, with the numberOfcharacters  being the upper bound
	li   $v0, 42		# random int range, $a0 contains pseudorandom int value
	syscall		
	
	la  $s4, array		# load address of array into register $s4
	add $s7, $s4, $a0	# set register $s7 to point to random element in the array
	
	lb  $t5, 0($s7)		# load a character from random index in the array into register $t5
	lb  $t3, 0($s2)		# load a character from sequential index in the array into register $t3
	sb  $t5, 0($s2)		# store the character that was randomly pointed to into the sequential index
	sb  $t3, 0($s7)		# store the character that was sequentially pointed to into the random index

	addi $s2, $s2, 1		# point to next index in the array
	
	ble  $s2, $s3, Permuteloop	# once the array points the last index stop looping
	
	la $s2, array			# set register back to beginning of array index before outputting the scrambled array
	add $s3, $t9, $s2		# #s3 points to last element in array
	
################################################
#prints out the permutated array
################################################	
	RearrangedOutput:
	lbu  $t8, 0($s2)
        li   $v0, 11
        move $a0, $t8
        syscall
        
        addi $s2, $s2, 1
        ble  $s2, $s3, RearrangedOutput
        
      
	j askForPermute
	
################################################
#storing characters in array
################################################	
	arrayStorage:
	sb $t2, ($s2)
        addi $s2, $s2, 1
   
	jr $ra
	
	.include "guessLoop.asm"

