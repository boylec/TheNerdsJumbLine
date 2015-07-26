#Word validator(incomplete)
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
cont:	.ascii  ""
buffer: .space 84960
buffer2: .space 84960
searchWord: .space 10
backSlash: .asciiz "\\"
  
.text
main:
jal getWord
beq $s0 2 search2
beq $s0 3 search3
beq $s0 4 search4
beq $s0 5 search5
beq $s0 6 search6
beq $s0 7 search7
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
	jal read2
	jal check
	#jal print
	beq $s1 1 close
	beq $t0 0 close
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
	jal open3
	addi $t0 $zero 637
	searchThreeLoop:
	subi $t0 $t0 1
	jal read3
	jal check
	#jal print
	beq $s1 1 close
	beq $t0 0 close
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
	jal open4
	addi $t0 $zero 2458
	searchFourLoop:
	subi $t0 $t0 1
	jal read4
	jal check
	#jal print
	beq $s1 1 close
	beq $t0 0 close
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
	jal open5
	addi $t0 $zero 4019
	searchFiveLoop:
	subi $t0 $t0 1
	jal read5
	jal check
	#jal print
	beq $s1 1 close
	beq $t0 0 search52
	j searchFiveLoop		

search52:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	jal open52
	addi $t0 $zero 674
	searchFiveTwoLoop:
	subi $t0 $t0 1
	jal read5
	jal check
	#jal print
	beq $s1 1 close
	beq $t0 0 close
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
	jal open6
	addi $t0 $zero 3887
	searchSixLoop:
	subi $t0 $t0 1
	jal read6
	jal check
	#jal print
	beq $s1 1 close
	beq $t0 0 search62
	j searchSixLoop		

search62:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	jal open62
	addi $t0 $zero 3533
	searchSixTwoLoop:
	subi $t0 $t0 1
	jal read6
	jal check
	#jal print
	beq $s1 1 close
	beq $t0 0 close
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
	jal open7
	addi $t0 $zero 3144
	searchSevenLoop:
	subi $t0 $t0 1
	jal read7
	jal check
	#jal print
	beq $s1 1 close
	beq $t0 0 search72
	j searchSevenLoop		

search72:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	jal open72
	addi $t0 $zero 3277
	searchSevenTwoLoop:
	subi $t0 $t0 1
	jal read7
	jal check
	#jal print
	beq $s1 1 close
	beq $t0 0 search73
	j searchSevenTwoLoop

search73:
	li	$v0, 16		# Close File Syscall
	move	$a0, $s6	# Load File Descriptor
	syscall
	jal open73
	addi $t0 $zero 3707
	searchSevenThreeLoop:
	subi $t0 $t0 1
	jal read7
	jal check
	#jal print
	beq $s1 1 close
	beq $t0 0 close
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
	li $v0 1
	move $a0 $s1
	syscall
	li	$v0, 10		# Exit Syscall
	syscall
