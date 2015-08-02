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


.macro CopyWord(%wordAddrReg, %wordLengthReg)	
# this function copies a word into curWord. If the word is less than 7 letters, extend it to 7 bytes with " "
	jal curWordInitialize
	
	add $t5, $zero, $zero		# $t5 curWord pointer
	add $t6, $zero, %wordLengthReg	# $t6 is length of word entered by user and number of times to loop
copyWordLoop:
	beqz $t6, listInsert
	subi $t6, $t6, 1
	lb $t1, 0(%wordAddrReg)
	sb $t1, curWord($t5)
	addi %wordAddrReg, %wordAddrReg, 1
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
.end_macro 

		
.macro ListInsertMain(%inputBufferReg, %wordLengthReg) # used for legitimate list generator (address of the word to be insert, length of the word)
	CopyWord(%inputBufferReg, %wordLengthReg)
	lw $s7, listMainPtr			# load list_global pointer. only this func can change list_global pointer.
	
updateCounter:
	lw $t0, legitimateSum
	addi $t0, $t0, 1
	sw $t0, legitimateSum
	move $t1, %wordLengthReg
	beq $t1 3 alter3
	beq $t1 4 alter4
	beq $t1 5 alter5
	beq $t1 6 alter6
	beq $t1 7 alter7
	alter2:
	lw $t0, legitimate2
	addi $t0, $t0, 1
	sw $t0, legitimate2
	j listInsert
	alter3:
	lw $t0, legitimate3
	addi $t0, $t0, 1
	sw $t0, legitimate3
	j listInsert
	alter4:
	lw $t0, legitimate4
	addi $t0, $t0, 1
	sw $t0, legitimate4
	j listInsert
	alter5:
	lw $t0, legitimate5
	addi $t0, $t0, 1
	sw $t0, legitimate5
	j listInsert
	alter6:
	lw $t0, legitimate6
	addi $t0, $t0, 1
	sw $t0, legitimate6
	j listInsert
	alter7:
	lw $t0, legitimate7
	addi $t0, $t0, 1
	sw $t0, legitimate7
	j listInsert
	
listInsert: 
	add $t5, $zero, $zero	# $t5 curWord pointer
	add $t4, $zero, $s7	# $t4 list_temporary pointer
	add $t6, $zero, 7	# loop counter. Each word to store is 7 byte long

	insertLoop:
	beqz $t6, insertExit
	subi $t6, $t6, 1
	lb $t1, curWord($t5)
	sb $t1, listMain($t4)
	addi $t4, $t4, 1
	addi $t5, $t5, 1
	j insertLoop
	insertExit:
	add $s7, $s7, 7		# alter list_global pointer
	sw $s7, listMainPtr
.end_macro 

.macro ListInsertCorrect(%inputBuffer, %wordLengthReg) # for correct-guessed words list
	CopyWord(%inputBuffer, %wordLengthReg)
	lw $s7, listCorrectPtr
updateCounter:
	beq %wordLengthReg 2 alter2
	beq %wordLengthReg 3 alter3
	beq %wordLengthReg 4 alter4
	beq %wordLengthReg 5 alter5
	beq %wordLengthReg 6 alter6
	beq %wordLengthReg 7 alter7
	alter2:
	lw $t0, legitimate2
	subi $t0, $t0, 1
	sw $t0, legitimate2
	j listInsert
	alter3:
	lw $t0, legitimate3
	subi $t0, $t0, 1
	sw $t0, legitimate3
	j listInsert
	alter4:
	lw $t0, legitimate4
	subi $t0, $t0, 1
	sw $t0, legitimate4
	j listInsert
	alter5:
	lw $t0, legitimate5
	subi $t0, $t0, 1
	sw $t0, legitimate5
	j listInsert
	alter6:
	lw $t0, legitimate6
	subi $t0, $t0, 1
	sw $t0, legitimate6
	j listInsert
	alter7:
	lw $t0, legitimate7
	subi $t0, $t0, 1
	sw $t0, legitimate7
	j listInsert
	
listInsert: 
	add $t5, $zero, $zero	# $t5 curWord pointer
	add $t4, $zero, $s7	# $t4 list temporary pointer
	add $t6, $zero, 7	# loop counter. Each word to store is 7 byte long

	insertLoop:
	beqz $t6, insertExit
	subi $t6, $t6, 1
	lb $t1, curWord($t5)
	sb $t1, listCorrect($t4)
	addi $t4, $t4, 1
	addi $t5, $t5, 1
	j insertLoop
	insertExit:
	add $s7, $s7, 7		# alter list global pointer
	sw $s7, listCorrectPtr
.end_macro 

.macro ListInsertWrong(%inputBuffer, %wordLengthReg) # for incorrect-guessed words list
	CopyWord(%inputBuffer, %wordLengthReg)
	lw $s7, listWrongPtr
	
listInsert: 
	add $t5, $zero, $zero	# $t5 curWord pointer
	add $t4, $zero, $s7	# $t4 list temporary pointer
	add $t6, $zero, 7	# loop counter. Each word to store is 7 byte long

	insertLoop:
	beqz $t6, insertExit
	subi $t6, $t6, 1
	lb $t1, curWord($t5)
	sb $t1, listWrong($t4)
	addi $t4, $t4, 1
	addi $t5, $t5, 1
	j insertLoop
	insertExit:
	add $s7, $s7, 7		# alter list_global pointer
	sw $s7, listWrongPtr
.end_macro 


.macro CompareToList(%inputBufferReg, %wordLengthReg, %regToStoreRightOrWrong)	# compare user input to list, and insert user guessing into cordinate lists
	CopyWord(%inputBufferReg, %wordLengthReg)
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
	lb $t1, list($t4)
	lb $t2, curWord($t5)
	bne $t1, $t2, checkNext
	addi $t4, $t4, 1
	addi $t5, $t5, 1
	j compareLoop2
	
	guessCorrect:
	ListInsertCorrect(%inputBufferReg, %wordLengthReg)
	li %regToStoreRightOrWrong, 1
	j endCompare
	notFound:
	ListInsertWrong(%inputBufferReg, %wordLengthReg)
	li %regToStoreRightOrWrong, 0
	j endCompare
	checkNext:
	addi $t3, $t3,7
	move $t4, $t3
	j compareLoop1
	
	endCompare:
	nop
.end_macro 

	
.macro printList(%listAddr, %listWordCount) # (list address, number of words saved in the list)
	move $t7, %listWordCount
	move $t1, %listAddr
printList:
	printListLoop1:
	endl()
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
.end_macro 

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



	
	
	



	
	
	
	
	


	
