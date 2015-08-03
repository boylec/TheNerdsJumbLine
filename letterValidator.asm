#Letter Validator
.data
searching2String:	.asciiz "\nSearching 2 letter file"
searching3String:	.asciiz "\nSearching 3 letter file"
searching4String:	.asciiz "\nSearching 4 letter file"
searching5String:	.asciiz "\nSearching 5 letter file"
searching6String:	.asciiz "\nSearching 6 letter file"
searching7String:	.asciiz "\nSearching 7 letter file"
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
cont:	.ascii  ""
buffer: .space 84960
buffer2: .space 84960
backSlash: .asciiz "\\"

 
.text
doLetterValidator:
la $s0, randomLetterArray
strLength($s0,$s0)	#store length of letter array in $s0
j search2				#start searching throught the 2 length file
j done

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
	jal open2		#open the 2 length file
	addi $t0 $zero 67	#67 words to check in this file is $t0
	printStr(searching2String)
	searchTwoLoop:		#start loop
	printInt($t0)
	subi $t0 $t0 1		#when t0 gets to 0 we are done
	addi $s3 $s0 0		#set $s3 to $s0... $s0 is the length of the random letter array
	jal read2
	
	addi $sp, $sp -24		#a0, a1, a2, t0, t1, ra
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $ra, 20($sp)
	jal CanStringBeMade		#Check if string can be made, store result in $s1
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp 24		#a0, a1, a2, t0, t1, ra
	
	beq $s1 1 addToList2#prints word if valid
	j addToListExit2
	addToList2:
	li $t1, 2
	#t0, t1, s1, s0, s3, t2, s6, s2
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s6, 28($sp)
	la $a0, buffer
	strLength($a1,$a0)
	jal ListInsertMain
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s6, 28($sp)
	addi $sp, $sp, 32
	
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
	printStr(searching3String)
	searchThreeLoop:
	printInt($t0)
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read3
	
	addi $sp, $sp -24		#a0, a1, a2, t0, t1, ra
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $ra, 20($sp)
	jal CanStringBeMade		#Check if string can be made, store result in $s1
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp 24		#a0, a1, a2, t0, t1, ra
	
	beq $s1 1 addToList3#prints word if valid
	j addToListExit3
	addToList3:
	li $t1, 3
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s6, 28($sp)
	la $a0, buffer
	strLength($a1,$a0)
	jal ListInsertMain
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s6, 28($sp)
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
	printStr(searching4String)
	searchFourLoop:
	printInt($t0)
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read4
	
		addi $sp, $sp -24		#a0, a1, a2, t0, t1, ra
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $ra, 20($sp)
	jal CanStringBeMade		#Check if string can be made, store result in $s1
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp 24		#a0, a1, a2, t0, t1, ra
	
	beq $s1 1 addToList4#prints word if valid
	j addToListExit4
	addToList4:
	li $t1, 4
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s6, 28($sp)
	la $a0, buffer
	strLength($a1,$a0)
	jal ListInsertMain
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s6, 28($sp)
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
		printStr(searching5String)
	searchFiveLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read5
	
		addi $sp, $sp -24		#a0, a1, a2, t0, t1, ra
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $ra, 20($sp)
	jal CanStringBeMade		#Check if string can be made, store result in $s1
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp 24		#a0, a1, a2, t0, t1, ra
	
	beq $s1 1 addToList5#prints word if valid
	j addToListExit5
	addToList5:
	li $t1, 5
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s6, 28($sp)
	la $a0, buffer
	strLength($a1,$a0)
	jal ListInsertMain
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s6, 28($sp)
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
		printStr(searching5String)
	searchFiveTwoLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read5
	
		addi $sp, $sp -24		#a0, a1, a2, t0, t1, ra
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $ra, 20($sp)
	jal CanStringBeMade		#Check if string can be made, store result in $s1
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp 24		#a0, a1, a2, t0, t1, ra
	
	beq $s1 1 addToList52#prints word if valid
	j addToListExit52
	addToList52:
	li $t1, 5
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s6, 28($sp)
	la $a0, buffer
	strLength($a1,$a0)
	jal ListInsertMain
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s6, 28($sp)
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
		printStr(searching6String)
	searchSixLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read6
	
		addi $sp, $sp -24		#a0, a1, a2, t0, t1, ra
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $ra, 20($sp)
	jal CanStringBeMade		#Check if string can be made, store result in $s1
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp 24		#a0, a1, a2, t0, t1, ra
	
	beq $s1 1 addToList6#prints word if valid
	j addToListExit6
	addToList6:
	li $t1, 6
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s6, 28($sp)
	la $a0, buffer
	strLength($a1,$a0)
	jal ListInsertMain
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s6, 28($sp)
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
		printStr(searching6String)
	searchSixTwoLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read6
	
		addi $sp, $sp -24		#a0, a1, a2, t0, t1, ra
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $ra, 20($sp)
	jal CanStringBeMade		#Check if string can be made, store result in $s1
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp 24		#a0, a1, a2, t0, t1, ra
	
	beq $s1 1 addToList62#prints word if valid
	j addToListExit62
	addToList62:
	li $t1, 6
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s6, 28($sp)
	la $a0, buffer
	strLength($a1,$a0)
	jal ListInsertMain
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s6, 28($sp)
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
		printStr(searching7String)
	searchSevenLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read7
	
		addi $sp, $sp -24		#a0, a1, a2, t0, t1, ra
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $ra, 20($sp)
	jal CanStringBeMade		#Check if string can be made, store result in $s1
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp 24		#a0, a1, a2, t0, t1, ra
	
	beq $s1 1 addToList7#prints word if valid
	j addToListExit7
	addToList7:
	li $t1, 7
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s6, 28($sp)
	la $a0, buffer
	strLength($a1,$a0)
	jal ListInsertMain
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s6, 28($sp)
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
		printStr(searching7String)
	searchSevenTwoLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read7
	
		addi $sp, $sp -24		#a0, a1, a2, t0, t1, ra
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $ra, 20($sp)
	jal CanStringBeMade		#Check if string can be made, store result in $s1
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp 24		#a0, a1, a2, t0, t1, ra
	
	beq $s1 1 addToList72#prints word if valid
	j addToListExit72
	addToList72:
	li $t1, 7
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s6, 28($sp)
	la $a0, buffer
	strLength($a1,$a0)
	jal ListInsertMain
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s6, 28($sp)
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
		printStr(searching7String)
	searchSevenThreeLoop:
	subi $t0 $t0 1
	addi $s3 $s0 0
	jal read7
	
	addi $sp, $sp -24		#a0, a1, a2, t0, t1, ra
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $ra, 20($sp)
	jal CanStringBeMade		#Check if string can be made, store result in $s1
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp 24		#a0, a1, a2, t0, t1, ra
	
	beq $s1 1 addToList73#prints word if valid
	j addToListExit73
	addToList73:
	li $t1, 7
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s6, 28($sp)
	la $a0, buffer
	strLength($a1,$a0)
	jal ListInsertMain
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s6, 28($sp)
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
	 lb $t2 randomLetterArray($t5)
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
#######################################################################################################################################################
#Sets $s1 to 1 if string is valid, if not sets $s1 to 0

CanStringBeMade: 		#a0 = %randomArrayAddress, #a1 = %dictWordAddress, #a2 = %regToStoreResult), uses $t0, and $t1 as well
addi $sp, $sp, -16
sw $ra, 0($sp)
sw $a0, 4($sp)
sw $a1, 8($sp)
sw $a2, 12($sp)
jal PopulateCharsWithRandomArray
lw $ra, 0($sp)
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
addi $sp, $sp, 16

la $t0, randomLetterArray
la $t1, buffer

strLength($t0, $t0)
strLength($t1, $t1)
subi $t1, $t1, 1
DoLoop:

addi $sp, $sp, -24
sw $ra, 0($sp)
sw $a0, 4($sp)
sw $a1, 8($sp)
sw $a2, 12($sp)
sw $t0, 16($sp)
sw $t1, 20($sp)
lb $a0, buffer($t1)
jal CheckCharArraysForLetter	#store if char exists in t5, a0 is the letter
lw $ra, 0($sp)
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
lw $t0, 16($sp)
lw $t1, 20($sp)
addi $sp, $sp, 24

beqz $t5, WordBad		#if the char didn't exist then the word isn't good
beq $t1, 0, WordGood		#if we got through all letters in the dictionary word and they all existed, then the word is good
subi $t1, $t1, 1		#the char was good so move the offset down 1 and check the next character whe the loop restarts
j DoLoop

WordBad:
li $s1, 0
j returnCanStringBeMade

WordGood:
li $s1, 1
j returnCanStringBeMade

returnCanStringBeMade:
jr $ra
#######################################################################################################################################################
# Checks if supplied character is in the letter array (Char1, Char2, Char3..., Char6, Char7), $t5 stores result, #a0 = char to compare against char arrays
CheckCharArraysForLetter:	
li $t3, 0
lb $t2, Char1
la $t4, Char1
seq $t3, $t2, $a0
beq $t3, 1, letterMatches
lb $t2, Char2
la $t4, Char2
seq $t3, $t2, $a0
beq $t3, 1, letterMatches
lb $t2, Char3
la $t4, Char3
seq $t3, $t2, $a0
beq $t3, 1, letterMatches
lb $t2, Char4
la $t4, Char4
seq $t3, $t2, $a0
beq $t3, 1, letterMatches
lb $t2, Char5
la $t4, Char5
seq $t3, $t2, $a0
beq $t3, 1, letterMatches
lb $t2, Char6
la $t4, Char6
seq $t3, $t2, $a0
beq $t3, 1, letterMatches
lb $t2, Char7
la $t4, Char7
seq $t3, $t2, $a0
beq $t3, 1, letterMatches
noMatch:
li $t5, 0
j returnCheckCharArray
letterMatches:
li $t5, 1
li $t3, 0
sw $t3, ($t4)
returnCheckCharArray:
jr $ra

############################################################################################################################################################
# Populates Char1 -Char7 memory locations with the characters in the randomLetterArray
# returns nothing.
PopulateCharsWithRandomArray:
la $t1, randomLetterArray
strLength($t0,$t1)

add $t3, $zero, $zero
GetAllCharsLoop:
beq $t3, 0 GetChar1
beq $t3, 1 GetChar2
beq $t3, 2 GetChar3
beq $t3, 3 GetChar4
beq $t3, 4 GetChar5
beq $t3, 5 GetChar6
beq $t3, 6 GetChar7
afterGetChar:
add $t3, $t3, 1
beq $t3, $t0, EndOfGetAllCharsLoop
j GetAllCharsLoop
GetChar1:
lb $t4, randomLetterArray($t3)
sb $t4, Char1
j afterGetChar
GetChar2:
lb $t4, randomLetterArray($t3)
sb $t4, Char2
j afterGetChar
GetChar3:
lb $t4, randomLetterArray($t3)
sb $t4, Char3
j afterGetChar
GetChar4:
lb $t4, randomLetterArray($t3)
sb $t4, Char4
j afterGetChar
GetChar5:
lb $t4, randomLetterArray($t3)
sb $t4, Char5
j afterGetChar
GetChar6:
lb $t4, randomLetterArray($t3)
sb $t4, Char6
j afterGetChar
GetChar7:
lb $t4, randomLetterArray($t3)
sb $t4, Char7
j afterGetChar
EndOfGetAllCharsLoop:
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
jr $ra