#Utility 
.data
youTyped: .asciiz "\nYou typed "
stringRead: .asciiz ""

#Print a string
.macro printStr(%address)
li $v0, 4
la $a0, %address
syscall
.end_macro

#Print an integer
.macro printInt(%integer)
subi $sp, $sp, 8
sw $v0, 0($sp)
sw $a0, 4($sp)

li $a0, %integer
li $v0, 1
syscall
.end_macro

#Print a character
.macro printChar(%register)
move $a0, %register
li $v0, 11
syscall
.end_macro 

#Get an integer input
.macro getInt(%registerToStore)
li $v0, 5
syscall
move %registerToStore, $v0
.end_macro

#Get a string input
.macro getStr(%registerToStore, %maxChars)
la $a0, %registerToStore
li $a1, %maxChars
li $v0, 8
syscall
.end_macro

#Newline
.macro endl
li $a0, 10
li $v0, 11
syscall
.end_macro

#For loop for macros
.macro for (%registerToIterate, %from, %to, %macro)
add %registerToIterate, $zero, %from
Loop:
%macro()
add %registerToIterate, %registerToIterate, 1
ble %registerToIterate, %to, Loop
.end_macro