	.data
StartGuessPrompt:	.asciiz "\nEnter in a valid word, at least 2 characters long using the given letters: "
StartGuessPrompt2:	.asciiz "\nEnter in a valid word, at least 2 characters long using the given letters: "
ControlsPrompt:		.asciiz "\n1 - Rearrange Letters\n2 - Stop Guessing"
AvailLetters:		.asciiz "\nLetters:"
WordIncorrectPrompt:	.asciiz "\nWord not valid. Try again!"
WordCorrectPrompt:	.asciiz "\nCorrect! Earned "
WordCorrectPoints:	.asciiz " points! Try another!"
YourScoreIs:		.asciiz "\nYour current score: "
YourFinalScore:		.asciiz "\nYour final score: "
DoneGuessingString:	.asciiz "\nWords that were possible:\n"
WordsYouGuessedString:	.asciiz "\nWords you guessed:\n"
WordsYouGuessedIncorrectString: .asciiz "\nWords that you guessed incorrectly:"
GotAllWordsString:	.asciiz "\nYou guessed every word good job!"
NewLine:		.asciiz "\n"
Score:			.word 	0
GuessedWord:		.space 50
letters2:		.asciiz "\nWords with 2 letters remaining:"
letters3:		.asciiz "\nWords with 3 letters remaining:"
letters4:		.asciiz "\nWords with 4 letters remaining:"
letters5:		.asciiz "\nWords with 5 letters remaining:"
letters6:		.asciiz "\nWords with 6 letters remaining:"
letters7:		.asciiz "\nWords with 7 letters remaining:"
total:			.asciiz "\nTotal words:"
correctRecord:		.asciiz "\nWords guessed right:"
wrongRecord:		.asciiz "\nWords guessed wrong:"
	.text
	
	#Loop for when users are making guesses
GuessLoop:
	#availableLettersArray is currently storing the letters that the user uses to guess with.
	#getStr($registorToStoreIn,$maxLengthOfStr) is available as macro function
	#$t4 is numberOfCharacters of availableLettersArray
	
	printStr(YourScoreIs)
	lw $t0, Score
	printInt($t0)
	
	lw $t8, legitimate2
	printStr(letters2)
	printInt($t8)
	lw $t8, legitimate3
	printStr(letters3)
	printInt($t8)
	lw $t8, legitimate4
	printStr(letters4)
	printInt($t8)
	lw $t8, legitimate5
	printStr(letters5)
	printInt($t8)
	lw $t8, legitimate6
	printStr(letters6)
	printInt($t8)
	lw $t8, legitimate7
	printStr(letters7)
	printInt($t8)
	lw $t8, legitimateSum
	printStr(total)
	printInt($t8)
	# for debugging
	#la $t9, listMain
	#PrintList($t9, $t8)
	
	printStr(correctRecord)
	la $t9, listCorrect
	lw $t8, counterCorrect
	PrintList($t9, $t8)
	printStr(wrongRecord)
	la $t9, listWrong
	lw $t8, counterWrong
	PrintList($t9, $t8)
	
	printStr(StartGuessPrompt2)
	printStr(ControlsPrompt)
	printStr(AvailLetters)
	printStr(randomLetterArray)
	printStr(NewLine)
	
	
	
	la $s1, GuessedWord		# Make $s1 the address of GuessedWord
	getStr ($s1, 9)			#At this point GuessedWord stores the guessed word (that is why the address of it is stored in $s1)
	lb $t0, 0($s1)
	beq $t0, 49, RearrangeChosen
	beq $t0, 50, StopGuess
	printStr(GuessedWord)
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
		li $a1, 500
		li $a2, 63
		li $a3, 120
		syscall
		j GuessLoop
	WordCorrect:
		
		li $v0, 31
		li $a0, 72
		li $a1, 500
		li $a2, 63
		li $a3, 120
		syscall
		lw $t0, counterCorrect
		lw $t1, legitimateSum
		beq $t0, $t1, AllWordsGuessed
		j GuessLoop

	RearrangeChosen:
	jal DoPermute
	j GuessLoop
	
	AllWordsGuessed:
	printStr(GotAllWordsString)
	j StopGuess
	
	StopGuess:
	lw $t8, legitimateSum
	printStr(total)
	printInt($t8)
	printStr(DoneGuessingString)
	la $t9, listMain
	PrintList($t9, $t8)
	
	printStr(correctRecord)
	la $t9, listCorrect
	lw $t8, counterCorrect
	PrintList($t9, $t8)
	printStr(wrongRecord)
	la $t9, listWrong
	lw $t8, counterWrong
	PrintList($t9, $t8)
	
	
	lw $t0, Score
	printStr(YourFinalScore)
	printInt($t0)
	printStr(nextLineString)
	
	jal ClearList
	add $v0, $zero, $zero
	add $v1, $zero, $zero
	add $a0, $zero, $zero
	add $a1, $zero, $zero
	add $a2, $zero, $zero	
	add $a3, $zero, $zero
	add $t0, $zero, $zero
	add $t1, $zero, $zero	
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	add $t4, $zero, $zero	
	add $t5, $zero, $zero
	add $t6, $zero, $zero
	add $t7, $zero, $zero	
	add $t8, $zero, $zero
	add $t9, $zero, $zero
	add $s0, $zero, $zero	
	add $s2, $zero, $zero
	add $s3, $zero, $zero	
	add $s4, $zero, $zero
	add $s5, $zero, $zero
	add $s6, $zero, $zero	
	add $s7, $zero, $zero
	add $ra, $zero, $zero
j DoneWithProgram
