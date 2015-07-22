	.data
StartGuessPrompt:	.asciiz "Enter in a valid word, at least 3 characters long using the given letters: "
GuessedWord:		.asciiz ""
	
	.text
	
	#Loop for when users are making guesses
	GuessLoop:
	#availableLettersArray is currently storing the letters that the user uses to guess with.
	#getStr($registorToStoreIn,$maxLengthOfStr) is available as macro function
	#$t4 is numberOfCharacters of availableLettersArray
	
	printStr(StartGuessPrompt)
	lw $t9, numberOfcharacters	# This works by checkin the range for lower case, forcing to upper, and exiting if MAX position is reached
	getStr ($s0, 30)
	
	#Force lower case characters to upper case
	# This works by checkin the range for lower case, forcing to upper, and exiting if MAX position is reached
	add $t1, $s0, $t9		#Set $t1 to MAX input postion in array, this keeps track for "exitCondition" below
	loopInputToUpper:
		lb $t0, ($s0)
		bge $t0, 97, letIsLowerCase  	#if input ascii is greater or equal to 97 "a" then it is a lower case
		nextInputLetter: 
			addi $s0, $s0, 1		#If failed, go to next letter	
			beq  $s0, $t1, exitCondition		#If input is at last postion exit loop.
			j loopInputToUpper		
		letIsLowerCase: 
			addi $t0, $t0, -32	# force to upper case
			sb $t0 ($s0)		# store into Input Array
			addi $s0, $s0, 1	# increment Input array position
			beq  $s0, $t1, exitCondition		#If input is at last postion exit loop.
			j loopInputToUpper
		exitCondition: 
			la $s0, GuessLoop		# make $s0 original address of Input Array
