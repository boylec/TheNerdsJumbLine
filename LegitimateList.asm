.data
listMain:	.space 2000
listCorrect:	.space 2000
listWrong:	.space 10000
listMainPtr:	.word 0		# global "pointer" for listMain
listCorrectPtr:	.word 0		# global "pointer" for listCorrect
listWrongPtr:	.word 0		# global "pointer" for listWrong
counterCorrect:	.word 0		# word count for listCorrect
counterWrong:	.word 0		# word count for listWrong
curWord:	.space 7	# buffer
blankByte:	.ascii " "
legitimateSum:	.word 0		# total number of legitimates from a group of random letters
legitimate2:	.word 0		# number of legitmates remain (not guessed) that are 2 letters long
legitimate3:	.word 0		# number of legitmates remain (not guessed) that are 3 letters long
legitimate4:	.word 0		# number of legitmates remain (not guessed) that are 4 letters long
legitimate5:	.word 0		# number of legitmates remain (not guessed) that are 5 letters long
legitimate6:	.word 0		# number of legitmates remain (not guessed) that are 6 letters long
legitimate7:	.word 0		# number of legitmates remain (not guessed) that are 7 letters long
#		.include "wordValidator.asm"
#		.include "UtilityMacros.asm"
#		.include "guessLoop.asm"


.text

##############################################################
# All arguments of the macros are registers
# Functions ListInsertMain(x,y), ComparToList(x,y), PrintList(x,y) are for external calls, others you guys need not to worry about
# Values above are necessary for these functions. And they maybe useful to you so I stored them in memory. Load them when needed.
# The frequently used argument "%wordLength" is supposed to be some result of Ken's functions.
# If legitimateSum == 0, then no legal words can be found from the random group.
##############################################################


CopyWord:	#a0=%wordAddrReg, $a1=%wordLengthReg, uses t5, t6, t1, ra
# this function copies a word into curWord. If the word is less than 7 letters, extend it to 7 bytes with " "
	addi $sp, $sp -4
	sw $ra, 0($sp)
	jal curWordInitialize
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	add $t5, $zero, $zero		# $t5 curWord pointer
	add $t6, $zero, $a1	# $t6 is length of word entered by user and number of times to loop
copyWordLoop:
	beqz $t6, endCopyWord
	subi $t6, $t6, 1
	lb $t1, 0($a0)
	sb $t1, curWord($t5)
	addi $a0, $a0, 1
	addi $t5, $t5, 1
	j copyWordLoop
	
curWordInitialize:
# this function sets curWord to "        ".
	add $t5, $zero, $zero	# $t5 curWord pointer
	addi $t0, $zero, 7	# $t0 loop counter
	lb $t1 blankByte
	loop:
	beqz $t0, endInitialize
	subi $t0, $t0, 1
	sb $t1, curWord($t5)
	addi $t5, $t5, 1
	j loop
endInitialize:
	jr $ra
endCopyWord:
jr $ra

		
ListInsertMain:		#a0 = %inputBufferReg, a1 = %wordLengthReg # used for legitimate list generator (address of the word to be insert, length of the word), uses t0-t7, s7, ra
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $t1, 4($sp)
	sw $t5, 8($sp)
	sw $t6, 12($sp)
	sw $a0, 16($sp)
	jal CopyWord	 #a0=%wordAddrReg, $a1=%wordLengthReg, uses t5, t6, t1, ra
	lw $ra, 0($sp)
	lw $t1, 4($sp)
	lw $t5, 8($sp)
	lw $t6, 12($sp)
	lw $a0, 16($sp)
	addi $sp, $sp, 20
	
	lw $s7, listMainPtr			# load list_global pointer. only this func can change list_global pointer.
	
UpdateCounterForListInsertMain:
	lw $t0, legitimateSum
	addi $t0, $t0, 1
	sw $t0, legitimateSum
	move $t1, $a1		#$a1 is word length
	beq $t1 2 alter2ForListInsertMain
	beq $t1 3 alter3ForListInsertMain
	beq $t1 4 alter4ForListInsertMain
	beq $t1 5 alter5ForListInsertMain
	beq $t1 6 alter6ForListInsertMain
	beq $t1 7 alter7ForListInsertMain
	alter2ForListInsertMain:
	lw $t0, legitimate2
	addi $t0, $t0, 1
	sw $t0, legitimate2
	j listInsertForListInsertMain
	alter3ForListInsertMain:
	lw $t0, legitimate3
	addi $t0, $t0, 1
	sw $t0, legitimate3
	j listInsertForListInsertMain
	alter4ForListInsertMain:
	lw $t0, legitimate4
	addi $t0, $t0, 1
	sw $t0, legitimate4
	j listInsertForListInsertMain
	alter5ForListInsertMain:
	lw $t0, legitimate5
	addi $t0, $t0, 1
	sw $t0, legitimate5
	j listInsertForListInsertMain
	alter6ForListInsertMain:
	lw $t0, legitimate6
	addi $t0, $t0, 1
	sw $t0, legitimate6
	j listInsertForListInsertMain
	alter7ForListInsertMain:
	lw $t0, legitimate7
	addi $t0, $t0, 1
	sw $t0, legitimate7
	j listInsertForListInsertMain
	
listInsertForListInsertMain: 
	add $t5, $zero, $zero	# $t5 curWord pointer
	add $t4, $zero, $s7	# $t4 list_temporary pointer
	add $t6, $zero, 7	# loop counter. Each word to store is 7 byte long

	insertLoopForListInsertMain:
	beqz $t6, insertExitForListInsertMain
	subi $t6, $t6, 1
	lb $t1, curWord($t5)
	sb $t1, listMain($t4)
	addi $t4, $t4, 1
	addi $t5, $t5, 1
	j insertLoopForListInsertMain
	insertExitForListInsertMain:
	add $s7, $s7, 7		# alter list_global pointer
	sw $s7, listMainPtr
	jr $ra

ListInsertCorrect:	#a0 = %inputBufferRegister, $a1 = %wordLengthReg # for correct-guessed words list
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $t1, 4($sp)
	sw $t5, 8($sp)
	sw $t6, 12($sp)
	sw $a0, 16($sp)
	jal CopyWord	 #a0=%wordAddrReg, $a1=%wordLengthReg, uses t5, t6, t1, ra
	lw $ra, 0($sp)
	lw $t1, 4($sp)
	lw $t5, 8($sp)
	lw $t6, 12($sp)
	lw $a0, 16($sp)
	addi $sp, $sp, 20
	
	lw $s7, listCorrectPtr
	
UpdateCounterForListInsertCorrect:
	beq $a1 2 alter2ForListInsertCorrect
	beq $a1 3 alter3ForListInsertCorrect
	beq $a1 4 alter4ForListInsertCorrect
	beq $a1 5 alter5ForListInsertCorrect
	beq $a1 6 alter6ForListInsertCorrect
	beq $a1 7 alter7ForListInsertCorrect
	alter2ForListInsertCorrect:
	lw $t0, legitimate2
	subi $t0, $t0, 1
	sw $t0, legitimate2
	j listInsertForListInsertCorrect
	alter3ForListInsertCorrect:
	lw $t0, legitimate3
	subi $t0, $t0, 1
	sw $t0, legitimate3
	j listInsertForListInsertCorrect
	alter4ForListInsertCorrect:
	lw $t0, legitimate4
	subi $t0, $t0, 1
	sw $t0, legitimate4
	j listInsertForListInsertCorrect
	alter5ForListInsertCorrect:
	lw $t0, legitimate5
	subi $t0, $t0, 1
	sw $t0, legitimate5
	j listInsertForListInsertCorrect
	alter6ForListInsertCorrect:
	lw $t0, legitimate6
	subi $t0, $t0, 1
	sw $t0, legitimate6
	j listInsertForListInsertCorrect
	alter7ForListInsertCorrect:
	lw $t0, legitimate7
	subi $t0, $t0, 1
	sw $t0, legitimate7
	j listInsertForListInsertCorrect
	
listInsertForListInsertCorrect: 
	add $t5, $zero, $zero	# $t5 curWord pointer
	add $t4, $zero, $s7	# $t4 list temporary pointer
	add $t6, $zero, 7	# loop counter. Each word to store is 7 byte long

	insertLoopForListInsertCorrect:
	beqz $t6, insertExitForListInsertCorrect
	subi $t6, $t6, 1
	lb $t1, curWord($t5)
	sb $t1, listCorrect($t4)
	addi $t4, $t4, 1
	addi $t5, $t5, 1
	j insertLoopForListInsertCorrect
	insertExitForListInsertCorrect:
	add $s7, $s7, 7		# alter list global pointer
	sw $s7, listCorrectPtr
	jr $ra 

ListInsertWrong:	#$a0 = %inputBuffer $a1 = %wordLengthReg # for incorrect-guessed words list
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $t1, 4($sp)
	sw $t5, 8($sp)
	sw $t6, 12($sp)
	sw $a0, 16($sp)
	jal CopyWord	 #a0=%wordAddrReg, $a1=%wordLengthReg, uses t5, t6, t1, ra
	lw $ra, 0($sp)
	lw $t1, 4($sp)
	lw $t5, 8($sp)
	lw $t6, 12($sp)
	lw $a0, 16($sp)
	addi $sp, $sp, 20
	
	lw $s7, listWrongPtr
	
listInsertForListInsertWrong: 
	add $t5, $zero, $zero	# $t5 curWord pointer
	add $t4, $zero, $s7	# $t4 list temporary pointer
	add $t6, $zero, 7	# loop counter. Each word to store is 7 byte long

	insertLoopForListInsertWrong:
	beqz $t6, insertExitForListInsertWrong
	subi $t6, $t6, 1
	lb $t1, curWord($t5)
	sb $t1, listWrong($t4)
	addi $t4, $t4, 1
	addi $t5, $t5, 1
	j insertLoopForListInsertWrong
	insertExitForListInsertWrong:
	add $s7, $s7, 7		# alter list_global pointer
	sw $s7, listWrongPtr
	jr $ra


	CompareToList:	#a0 = %inputBufferReg, $a1 = %wordLengthReg, $s1 = %regToStoreRightOrWrong	# compare user input to list, and insert user guessing into cordinate lists
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $t1, 4($sp)
	sw $t5, 8($sp)
	sw $t6, 12($sp)
	sw $a0, 16($sp)
	jal CopyWord	 #a0=%wordAddrReg, $a1=%wordLengthReg, uses t5, t6, t1, ra
	lw $ra, 0($sp)
	lw $t1, 4($sp)
	lw $t5, 8($sp)
	lw $t6, 12($sp)
	lw $a0, 16($sp)
	addi $sp, $sp, 20
	
	add $t5, $zero, $zero	# $t5 curWord pointer
	add $t4, $zero, $zero	# $t4 list temporary pointer
	add $t3, $zero, $zero	# $t3 list word pointer
	lw $t7, legitimateSum	# word counter
	compareLoop1:
	beqz $t7, notFound
	subi $t7, $t7, 1
	addi $t6, $zero, 7	# character counter. Each word is 7 byte long
	compareLoop2:
	beqz $t6, guessCorrect
	subi $t6, $t6, 1
	lb $t1, listMain($t4)
	lb $t2, curWord($t5)
	bne $t1, $t2, checkNext
	addi $t4, $t4, 1
	addi $t5, $t5, 1
	j compareLoop2
	
	guessCorrect:
	jal ListInsertCorrect
	li $s1, 1
	j endCompare
	notFound:
	jal ListInsertWrong
	li $s1, 0
	j endCompare
	checkNext:
	addi $t3, $t3,7
	move $t4, $t3
	j compareLoop1
	
	endCompare:
	nop
	jr $ra 

	
	printList:	#$a0 = listAddr, $a1 = %listWordCount # (list address, number of words saved in the list), uses t7,t1,t6
	move $t7, $a1
	move $t1, $a0
	printListLoop1:
	beqz $t7, printListExit
	subi $t7, $t7,1
	addi $t6, $zero, 7	# set the character counter
	printListLoop2:
	beqz $t6, printListLoop1
	subi $t6, $t6,1
	printChar($t1)
	addi $t1, $t1, 1
	j printListLoop2
	printListExit:
	nop
	jr $ra 

.macro ClearList()	
# this function does not really clear the list. it merely set the counters back to zero. 
# call it every time the user changes the random group and begin another guessing.
	sw $zero, legitimateSum
	sw $zero, legitimate2
	sw $zero, legitimate3
	sw $zero, legitimate4
	sw $zero, legitimate5
	sw $zero, legitimate6
	sw $zero, legitimate7
.end_macro



	
	
	



	
	
	
	
	


	
