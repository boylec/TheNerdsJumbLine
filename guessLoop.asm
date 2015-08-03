	.data
StartGuessPrompt:	.asciiz "\nEnter in a valid word, at least 3 characters long using the given letters: "
ControlsPrompt:		.asciiz "\n1 - Rearrange Letters\n2 - Stop Guessing"
AvailLetters:		.asciiz "\nLetters:"
WordIncorrectPrompt:	.asciiz "\nWord not valid. Try again!"
WordCorrectPrompt:	.asciiz "\nCorrect! Earned "
WordCorrectPoints:	.asciiz " points! Try another!"
YourScoreIs:		.asciiz "\nYour current score: "
NewLine:		.asciiz "\n"
Score:			.word 	0
GuessedWord:		.space 50
	.text
	
	#Loop for when users are making guesses
	GuessLoop:
	#availableLettersArray is currently storing the letters that the user uses to guess with.
	#getStr($registorToStoreIn,$maxLengthOfStr) is available as macro function
	#$t4 is numberOfCharacters of availableLettersArray
	
	printStr(YourScoreIs)
	lw $t0, Score
	printInt($t0)
	printStr(StartGuessPrompt)
	printStr(ControlsPrompt)
	printStr(AvailLetters)
	printStr(randomLetterArray)
	printStr(NewLine)
	
	la $s1, GuessedWord		# Make $s1 the address of GuessedWord
	getStr ($s1, 9)			#At this point GuessedWord stores the guessed word (that is why the address of it is stored in $s1)
	lb $t0, 0($s1)
	beq $t0, 49, RearrangeChosen
	beq $t0, 50, StopGuess
	j ProcessGuess
	
	ProcessGuess:
	strLength($t7,$s1)		#store length of GuessedWord in to $t9
	
	
	#Force lower case characters to upper case
	# This works by checkin the range for lower case, forcing to upper, and exiting if MAX position is reached
	add $t1, $s1, $t7		#Set $t1 to MAX input postion in array, this keeps track for "exitCondition" below
	loopInputToLower:
		lb $t0, ($s1)
		blt $t0, 97, letIsUpperCase  	#if input ascii is less than 97 "a" then it is Upper Case
		nextInputLetter: 
			addi $s1, $s1, 1		#If failed, go to next letter	
			beq  $s1, $t1, exitCondition		#If input is at last postion exit loop.
			j loopInputToLower		
		letIsUpperCase: 
			addi $t0, $t0, 32	# force to upper case
			sb $t0 ($s1)		# store into Input Array
			addi $s1, $s1, 1	# increment Input array position
			beq  $s1, $t1, exitCondition		#If input is at last postion exit loop.
			j loopInputToLower
		exitCondition: 
			la $a0, GuessedWord	# make $s2 original address Guessed Word
	CheckGuess:				#At this point we have array storing the upper case letters that were guessed.
		strLength($a1, $a0)
		jal CompareToList 	#a0 = holds address of input, $a1 = holds length of input, $s1 stores return bool, word is good or bad
		bgt $s1, 0, WordCorrect		#if s1 is greater than 0 that means the word guess is correct
	WordIncorrect:
		printStr(WordIncorrectPrompt)
		li $v0, 31
		li $a0, 69
		li $a2, 100
		li $a3, 64
		syscall
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
		li $v0, 31
		li $a0, 72
		li $a2, 100
		li $a3, 64
		syscall
		j GuessLoop

	RearrangeChosen:
	jal DoPermute
	j GuessLoop
	
	StopGuess:
#	add $v0, $zero, $zero
#	add $v1, $zero, $zero
#	add $a0, $zero, $zero
#	add $a1, $zero, $zero
#	add $a2, $zero, $zero	
#	add $a3, $zero, $zero
#	add $t0, $zero, $zero
#	add $t1, $zero, $zero	
#	add $t2, $zero, $zero
#	add $t3, $zero, $zero
#	add $t4, $zero, $zero	
#	add $t5, $zero, $zero
#	add $t6, $zero, $zero
#	add $t7, $zero, $zero	
#	add $t8, $zero, $zero
#	add $t9, $zero, $zero
#	add $s0, $zero, $zero	
##	add $s2, $zero, $zero
#	add $s3, $zero, $zero	
#	add $s4, $zero, $zero
#	add $s5, $zero, $zero
#	add $s6, $zero, $zero	
#	add $s7, $zero, $zero
#	add $ra, $zero, $zero
j DoneWithProgram
