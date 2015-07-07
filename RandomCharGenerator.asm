			.data
			.include "UtilityMacros.asm"
numberOfcharacters: 	.word	0
promptChar: 		.asciiz  "   Choose the number of characters to play with (5,6, or 7): "
alphabet: 		.asciiz "abcdefghijklmnopqrstuvwxyz"

			.text
main:
	printStr(promptChar)
	
	getInt($t4)
	
	add $t7, $t4, $zero 		# counter
	
	la $s0, alphabet 		# pointer to alphabet

	seedRand()		#utility macro to seed random number generator... uses lower 32-bit of time in milliseconds

	loop:
	beq $t7, $0, loop2 	# if counter == 0 go to loop2 
	 				
	getRand(1,26,$a0)	#get a random number between 1 and 26 inclusive, store it in $a0	

	add $t1, $s0, $a0 	# add string pointer by random number in $a0, store this new address in $t1
	
	lbu $t2, ($t1)		# isolates that bytesized char, puts it into $t2

	li  $v0, 11		 # system call code for Print String 
	move  $a0, $t2 		 # load address char into $a0 
	syscall      		 # print the prompt message 
		
	addi $t7, $t7, -1 	# decrement counter

	j loop 			# loop return

	loop2:
	j main
