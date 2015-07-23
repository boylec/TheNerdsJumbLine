	.data
StartGuessPrompt:	.asciiz "Enter in a valid word, at least 3 characters long using the given letters: "
WordIncorrectPrompt:	.asciiz "Word not valid. Try again!\n"
WordCorrectPrompt:	.asciiz "Correct! Earned "
WordCorrectPoints:	.asciiz " points! Try another! \n"
GuessedWord:		.asciiz ""
.space 			50
	
	.text
	
	#Loop for when users are making guesses
	GuessLoop:
	#availableLettersArray is currently storing the letters that the user uses to guess with.
	#getStr($registorToStoreIn,$maxLengthOfStr) is available as macro function
	#$t4 is numberOfCharacters of availableLettersArray
	
	printStr(StartGuessPrompt)
	lw $t9, numberOfcharacters	# This works by checkin the range for lower case, forcing to upper, and exiting if MAX position is reached
	la $s1, GuessedWord		# Make $s1 the address of GuessedWord
	getStr ($s1, 30)			#At this point GuessedWord stores the guessed word (that is why the address of it is stored in $s1)
	
	#Force lower case characters to upper case
	# This works by checkin the range for lower case, forcing to upper, and exiting if MAX position is reached
	add $t1, $s1, $t9		#Set $t1 to MAX input postion in array, this keeps track for "exitCondition" below
	loopInputToUpper:
		lb $t0, ($s1)
		bge $t0, 97, letIsLowerCase  	#if input ascii is greater or equal to 97 "a" then it is a lower case
		nextInputLetter: 
			addi $s1, $s1, 1		#If failed, go to next letter	
			beq  $s1, $t1, exitCondition		#If input is at last postion exit loop.
			j loopInputToUpper		
		letIsLowerCase: 
			addi $t0, $t0, -32	# force to upper case
			sb $t0 ($s1)		# store into Input Array
			addi $s1, $s1, 1	# increment Input array position
			beq  $s1, $t1, exitCondition		#If input is at last postion exit loop.
			j loopInputToUpper
		exitCondition: 
			la $s1, GuessedWord	# make $s0 original address of Input Array
	CheckGuess:				#At this point we have array storing the upper case letters that were guessed.
		li $t1, 0			#Simulate guess is correct
		bgt $t1, 0, WordCorrect		#if t1 is greater than 0 that means the word guess is correct
	WordIncorrect:
		printStr(WordIncorrectPrompt)
		j GuessLoop
	WordCorrect:
		la $t2, GuessedWord
		printStr(WordCorrectPrompt)
		printScoreWorth($t2)
		printStr(WordCorrectPoints)
		lw $t0, Score
		strLength($t1,$t2)
		add $t0,$t0, $t1
		sw $t0, Score
		j GuessLoop