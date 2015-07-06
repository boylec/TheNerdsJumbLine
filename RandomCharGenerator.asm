
			.data
numberOfcharacters: 	.word	0
promptChar: 		.asciiz  "   Choose the number of characters to play with (5,6, or 7): "
alphabet: 		.asciiz "abcdefghijklmnopqrstuvwxyz"

			.text
main:
	li  $v0, 4   			 # system call code for Print String 
	la  $a0, promptChar  		 # load address of prompt into $a0 
	syscall      			 # print the prompt message 
	
	
	li  $v0, 5    			# system call code for Read Integer n
	syscall    			# reads the value into $v0
	move $t4, $v0			# stores the integer in the memory location named characters
	
	
	add $t7, $t4, $zero 		# counter

	
	la $s0, alphabet 		# pointer to alphabet



	li	$v0, 30		# get time in milliseconds 
	syscall
	move	$t0, $a0	# save the lower 32-bits of time

				# seed the random generator 
	li	$a0, 1		# random generator id (will be used later)
	move 	$a1, $t0	# seed from time
	li	$v0, 40		# seed random number generator syscall
	syscall


	loop:
	beq $t7, $0, loop2 	# if counter == 0 go to loop2 
	 			
	
	li $a0, 1	
	li $a1, 26		# generates random number in $a1, with the counter 26 being the upper bound
	li $v0, 42		# random int range, $a0 contains pseudorandom int value
	syscall			


	add $t1, $s0, $a0 	# add string pointer by random number in $a0, store this new address in $t1

	
	lbu $t2, ($t1)		# isolates that bytesized char, puts it into $t2

	li  $v0, 11		 # system call code for Print String 
	move  $a0, $t2 		 # load address char into $a0 
	syscall      		 # print the prompt message 
	
	
	addi $t7, $t7, -1 	# decrement counter

	
	j loop 			# loop return


	loop2:
	j main
	
	