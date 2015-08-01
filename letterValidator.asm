#Letter Validator
.data
fnf:	.ascii  "The file was not found: "
file2:	.asciiz	"2.txt" # 67 words 134 characters
file3:	.asciiz	"3.txt" # 637 words 1913 characters
file4:	.asciiz	"4.txt" # 2458 words 9839 characters
file5:	.asciiz	"5.txt" # 4019 words 20095 characters
file52:	.asciiz	"52.txt" #  674 words 3371 characters
file6:	.asciiz	"6.txt" # 3887 words 23322 characters
file62: .asciiz "62.txt" # 3533 words 21198 characters
file7:	.asciiz	"7.txt" # 3144 words 22008 characters
file72:	.asciiz	"72.txt" # 3277 words 22939 characters
file73:	.asciiz	"73.txt" # 3707 words 25949 characters
newLine: .asciiz "\n"
cont:	.ascii  ""
buffer: .space 84960
buffer2: .space 84960
searchWord: .space 10
backSlash: .asciiz "\\"
  
.text
main:
jal getWord
j search2
jal done

# Get word
getWord:
	li $v0, 8
	li $a1, 9
	la $a0, searchWord
	syscall
	
	#gets the length of string into $s0
	li $t0,0
	la $t1, searchWord

	lengthLoop:
	lb $t2,($t1)
	beq $t2,$0,lengthLoopExit
	add $t0,$t0,1
	add $t1,$t1,1
	j lengthLoop
	
	lengthLoopExit:
	subi $s0 $t0 1
	addi $t0 $zero 0
	addi $t1 $zero 0
	addi $t2 $zero 0
	
	jr $ra
	
# Open File
open2:
	li	$v0, 13		# Open File Syscall
	la	$a0, file2	# Load File Name
	li	$a1, 0		# Read-only Flag, 0 = read only, 1 = write only, 9 = append
	li	$a2, 0		# (ignored), determines mode
	syscall
	move	$s6, $v0	# Save File Descriptor (Descriptor is negative if file's not found)
	blt	$v0, 0, err	# Goto Error
	addi $s2 $zero 2 #defines length of words in dictionary
	jr $ra
 
# Read Data
read2:
	li	$v0, 14		# Read File Syscall
	move	$a0, $s6	# Load File Descriptor
	la	$a1, buffer	# Load Buffer Address
	li	$a2, 4	# Buffer Size, the number of chars that will be read from file
	syscall
 	jr $ra
 	
# Search through data
search2:
	jal open2
	addi $t0 $zero 67
	searchTwoLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read2
	
	checkEachLetterLoop2:
	subi $s3 $s3 1
	jal check2
	beqz $s1 checkEachLetterLoopExit2
	beqz $s3 checkEachLetterLoopExit2
	j checkEachLetterLoop2
	checkEachLetterLoopExit2:
	
	beq $s1 1 addToList2#prints word if valid
	j addToListExit2
	addToList2:
	jal print
	addToListExit2:
	
	addi $s1 $zero 0 #reset register that determines validity
	beqz $t0 search3 #go to next file after searching this file
	j searchTwoLoop
	
# Open File
open3:
	li	$v0, 13		# Open File Syscall
	la	$a0, file3	# Load File Name
	li	$a1, 0		# Read-only Flag, 0 = read only, 1 = write only, 9 = append
	li	$a2, 0		# (ignored), determines mode
	syscall
	move	$s6, $v0	# Save File Descriptor (Descriptor is negative if file's not found)
	blt	$v0, 0, err	# Goto Error
	addi $s2 $zero 3 #defines length of words in dictionary
	jr $ra
 
# Read Data
read3:
	li	$v0, 14		# Read File Syscall
	move	$a0, $s6	# Load File Descriptor
	la	$a1, buffer	# Load Buffer Address
	li	$a2, 5	# Buffer Size, the number of chars that will be read from file
	syscall
 	jr $ra
 	
# Search through data
search3:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	jal open3
	addi $t0 $zero 635
	searchThreeLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read3
	
	checkEachLetterLoop3:
	subi $s3 $s3 1
	jal check2
	beqz $s1 checkEachLetterLoopExit3
	beqz $s3 checkEachLetterLoopExit3
	j checkEachLetterLoop3
	checkEachLetterLoopExit3:
	
	beq $s1 1 addToList3#prints word if valid
	j addToListExit3
	addToList3:
	jal print
	addToListExit3:
	
	addi $s1 $zero 0 #reset register that determines validity
	beqz $t0 search4 #go to next file after searching this file
	j searchThreeLoop
	
# Open File
open4:
	li	$v0, 13		# Open File Syscall
	la	$a0, file4	# Load File Name
	li	$a1, 0		# Read-only Flag, 0 = read only, 1 = write only, 9 = append
	li	$a2, 0		# (ignored), determines mode
	syscall
	move	$s6, $v0	# Save File Descriptor (Descriptor is negative if file's not found)
	blt	$v0, 0, err	# Goto Error
	addi $s2 $zero 4 #defines length of words in dictionary
	jr $ra
 
# Read Data
read4:
	li	$v0, 14		# Read File Syscall
	move	$a0, $s6	# Load File Descriptor
	la	$a1, buffer	# Load Buffer Address
	li	$a2, 6	# Buffer Size, the number of chars that will be read from file
	syscall
 	jr $ra
 	
# Search through data
search4:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	jal open4
	addi $t0 $zero 2458
	searchFourLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read4
	
	checkEachLetterLoop4:
	subi $s3 $s3 1
	jal check2
	beqz $s1 checkEachLetterLoopExit4
	beqz $s3 checkEachLetterLoopExit4
	j checkEachLetterLoop4
	checkEachLetterLoopExit4:
	
	beq $s1 1 addToList4#prints word if valid
	j addToListExit4
	addToList4:
	jal print
	addToListExit4:
	
	addi $s1 $zero 0 #reset register that determines validity
	beqz $t0 search5 #go to next file after searching this file
	j searchFourLoop
		
# Open File
open5:
	li	$v0, 13		# Open File Syscall
	la	$a0, file5	# Load File Name
	li	$a1, 0		# Read-only Flag, 0 = read only, 1 = write only, 9 = append
	li	$a2, 0		# (ignored), determines mode
	syscall
	move	$s6, $v0	# Save File Descriptor (Descriptor is negative if file's not found)
	blt	$v0, 0, err	# Goto Error
	addi $s2 $zero 5 #defines length of words in dictionary
	jr $ra

# Open File
open52:
	li	$v0, 13		# Open File Syscall
	la	$a0, file52	# Load File Name
	li	$a1, 0		# Read-only Flag, 0 = read only, 1 = write only, 9 = append
	li	$a2, 0		# (ignored), determines mode
	syscall
	move	$s6, $v0	# Save File Descriptor (Descriptor is negative if file's not found)
	blt	$v0, 0, err	# Goto Error
	addi $s2 $zero 5 #defines length of words in dictionary
	jr $ra
  
# Read Data
read5:
	li	$v0, 14		# Read File Syscall
	move	$a0, $s6	# Load File Descriptor
	la	$a1, buffer	# Load Buffer Address
	li	$a2, 7	# Buffer Size, the number of chars that will be read from file
	syscall
 	jr $ra
 	
# Search through data
search5:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	jal open5
	addi $t0 $zero 4019
	searchFiveLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read5
	
	checkEachLetterLoop5:
	subi $s3 $s3 1
	jal check2
	beqz $s1 checkEachLetterLoopExit5
	beqz $s3 checkEachLetterLoopExit5
	j checkEachLetterLoop5
	checkEachLetterLoopExit5:
	
	beq $s1 1 addToList5#prints word if valid
	j addToListExit5
	addToList5:
	jal print
	addToListExit5:
	
	addi $s1 $zero 0 #reset register that determines validity
	beqz $t0 search52 #go to next file after searching this file
	j searchFiveLoop		

search52:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	jal open52
	addi $t0 $zero 674
	searchFiveTwoLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read5
	
	checkEachLetterLoop52:
	subi $s3 $s3 1
	jal check2
	beqz $s1 checkEachLetterLoopExit52
	beqz $s3 checkEachLetterLoopExit52
	j checkEachLetterLoop52
	checkEachLetterLoopExit52:
	
	beq $s1 1 addToList52#prints word if valid
	j addToListExit52
	addToList52:
	jal print
	addToListExit52:
	
	addi $s1 $zero 0 #reset register that determines validity
	beqz $t0 search6 #go to next file after searching this file
	j searchFiveTwoLoop

# Open File
open6:
	li	$v0, 13		# Open File Syscall
	la	$a0, file6	# Load File Name
	li	$a1, 0		# Read-only Flag, 0 = read only, 1 = write only, 9 = append
	li	$a2, 0		# (ignored), determines mode
	syscall
	move	$s6, $v0	# Save File Descriptor (Descriptor is negative if file's not found)
	blt	$v0, 0, err	# Goto Error
	addi $s2 $zero 6 #defines length of words in dictionary
	jr $ra

# Open File
open62:
	li	$v0, 13		# Open File Syscall
	la	$a0, file62	# Load File Name
	li	$a1, 0		# Read-only Flag, 0 = read only, 1 = write only, 9 = append
	li	$a2, 0		# (ignored), determines mode
	syscall
	move	$s6, $v0	# Save File Descriptor (Descriptor is negative if file's not found)
	blt	$v0, 0, err	# Goto Error
	addi $s2 $zero 6 #defines length of words in dictionary
	jr $ra
  
# Read Data
read6:
	li	$v0, 14		# Read File Syscall
	move	$a0, $s6	# Load File Descriptor
	la	$a1, buffer	# Load Buffer Address
	li	$a2, 8	# Buffer Size, the number of chars that will be read from file
	syscall
 	jr $ra
 	
# Search through data
search6:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	jal open6
	addi $t0 $zero 3887
	searchSixLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read6
	
	checkEachLetterLoop6:
	subi $s3 $s3 1
	jal check2
	beqz $s1 checkEachLetterLoopExit6
	beqz $s3 checkEachLetterLoopExit6
	j checkEachLetterLoop6
	checkEachLetterLoopExit6:
	
	beq $s1 1 addToList6#prints word if valid
	j addToListExit6
	addToList6:
	jal print
	addToListExit6:
	
	addi $s1 $zero 0 #reset register that determines validity
	beqz $t0 search62 #go to next file after searching this file
	j searchSixLoop	

search62:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	jal open62
	addi $t0 $zero 3533
	searchSixTwoLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read6
	
	checkEachLetterLoop62:
	subi $s3 $s3 1
	jal check2
	beqz $s1 checkEachLetterLoopExit62
	beqz $s3 checkEachLetterLoopExit62
	j checkEachLetterLoop62
	checkEachLetterLoopExit62:
	
	beq $s1 1 addToList62#prints word if valid
	j addToListExit62
	addToList62:
	jal print
	addToListExit62:
	
	addi $s1 $zero 0 #reset register that determines validity
	beqz $t0 search7 #go to next file after searching this file
	j searchSixTwoLoop

# Open File
open7:
	li	$v0, 13		# Open File Syscall
	la	$a0, file7	# Load File Name
	li	$a1, 0		# Read-only Flag, 0 = read only, 1 = write only, 9 = append
	li	$a2, 0		# (ignored), determines mode
	syscall
	move	$s6, $v0	# Save File Descriptor (Descriptor is negative if file's not found)
	blt	$v0, 0, err	# Goto Error
	addi $s2 $zero 7 #defines length of words in dictionary
	jr $ra

# Open File
open72:
	li	$v0, 13		# Open File Syscall
	la	$a0, file72	# Load File Name
	li	$a1, 0		# Read-only Flag, 0 = read only, 1 = write only, 9 = append
	li	$a2, 0		# (ignored), determines mode
	syscall
	move	$s6, $v0	# Save File Descriptor (Descriptor is negative if file's not found)
	blt	$v0, 0, err	# Goto Error
	addi $s2 $zero 7 #defines length of words in dictionary
	jr $ra
 
# Open File
open73:
	li	$v0, 13		# Open File Syscall
	la	$a0, file73	# Load File Name
	li	$a1, 0		# Read-only Flag, 0 = read only, 1 = write only, 9 = append
	li	$a2, 0		# (ignored), determines mode
	syscall
	move	$s6, $v0	# Save File Descriptor (Descriptor is negative if file's not found)
	blt	$v0, 0, err	# Goto Error
	addi $s2 $zero 7 #defines length of words in dictionary
	jr $ra
	
# Read Data
read7:
	li	$v0, 14		# Read File Syscall
	move	$a0, $s6	# Load File Descriptor
	la	$a1, buffer	# Load Buffer Address
	li	$a2, 9	# Buffer Size, the number of chars that will be read from file
	syscall
 	jr $ra
 	
# Search through data
search7:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	jal open7
	addi $t0 $zero 3144
	searchSevenLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read7
	
	checkEachLetterLoop7:
	subi $s3 $s3 1
	jal check2
	beqz $s1 checkEachLetterLoopExit7
	beqz $s3 checkEachLetterLoopExit7
	j checkEachLetterLoop7
	checkEachLetterLoopExit7:
	
	beq $s1 1 addToList7#prints word if valid
	j addToListExit7
	addToList7:
	jal print
	addToListExit7:
	
	addi $s1 $zero 0 #reset register that determines validity
	beqz $t0 search72 #go to next file after searching this file
	j searchSevenLoop		

search72:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	jal open72
	addi $t0 $zero 3277
	searchSevenTwoLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read7
	
	checkEachLetterLoop72:
	subi $s3 $s3 1
	jal check2
	beqz $s1 checkEachLetterLoopExit72
	beqz $s3 checkEachLetterLoopExit72
	j checkEachLetterLoop72
	checkEachLetterLoopExit72:
	
	beq $s1 1 addToList72#prints word if valid
	j addToListExit72
	addToList72:
	jal print
	addToListExit72:
	
	addi $s1 $zero 0 #reset register that determines validity
	beqz $t0 search73 #go to next file after searching this file
	j searchSevenTwoLoop

search73:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	jal open73
	addi $t0 $zero 3707
	searchSevenThreeLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read7
	
	checkEachLetterLoop73:
	subi $s3 $s3 1
	jal check2
	beqz $s1 checkEachLetterLoopExit73
	beqz $s3 checkEachLetterLoopExit73
	j checkEachLetterLoop73
	checkEachLetterLoopExit73:
	
	beq $s1 1 addToList73#prints word if valid
	j addToListExit73
	addToList73:
	jal print
	addToListExit73:
	
	addi $s1 $zero 0 #reset register that determines validity
	beqz $t0 close #go to next file after searching this file
	j searchSevenThreeLoop
										
# Print Data
print:
	li	$v0, 4		# Print String Syscall
	la	$a0, buffer #cont	# Load Contents String
	syscall
	jr $ra

#Check if word is found by comparing the current read word with the searchword stores result in $s1
check:
	 addi $t4 $zero 0#initialize $t4 and $t5 to 0
	 addi $t5 $zero 0
	 addi $t6 $s0 0#$t6 is length of word entered by user and number of times to loop
	 compareLoop:
	 subi $t6 $t6 1
	 lb $t1 buffer($t4)
	 lb $t2 searchWord($t5)
	 seq $t3 $t1 $t2
	 beqz $t3 compareLoopExit
	 beqz $t6 compareLoopExit
	 addi $t4 $t4 1
	 addi $t5 $t5 1
	 j compareLoop
	 
	 compareLoopExit:
	 addi $s1 $t3 0#store result
	 
	 addi $t1 $zero 0
	 addi $t2 $zero 0
	 addi $t3 $zero 0
	 addi $t4 $zero 0
	 addi $t5 $zero 0
	 addi $t6 $zero 0
	 jr $ra

 #Check if a matching letter exists by comparing the current read word with a letter in the searchword of index $s3
 #stores 1 in $s1 if found stores 0 in $s1 if not found
check2:
	 addi $t4 $zero 0#initialize $t4  to 0
	 addi $t7 $s2 0#t7 is length of word in the current dictionary file
	 lb $t2 searchWord($s3)
	 
	 compareLoop2:
	 subi $t7 $t7 1
	 lb $t1 buffer($t4)
	 seq $t3 $t1 $t2 #compares bytes of a letter in buffer word and bytes of a letter in search word
	 beq $t3 1 compareLoopExit2 #stop comparing letters if at least 1 matching letter is found
	 beqz $t7 compareLoopExit2 #stop comparing letters if the number of comparisons exceeds the number of letters in buffer word
	 addi $t4 $t4 1
	 j compareLoop2
	 
	 compareLoopExit2:
	 addi $s1 $t3 0#store result
	 
	 addi $t1 $zero 0
	 addi $t2 $zero 0
	 addi $t3 $zero 0
	 addi $t4 $zero 0
	 addi $t5 $zero 0
	 addi $t6 $zero 0
	 jr $ra
   
# Close File
close:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	j done		
 
# Error
err:
	li	$v0, 4		# Print String Syscall
	la	$a0, fnf	# Load Error String
	syscall
	j done
 
# Done
done:
	li	$v0, 10		# Exit Syscall
	syscall
