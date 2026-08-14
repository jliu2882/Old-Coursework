.data
ErrMsg: .asciiz "Invalid Argument"
WrongArgMsg: .asciiz "You must provide exactly two arguments"
EvenMsg: .asciiz "Even"
OddMsg: .asciiz "Odd"

arg1_addr : .word 0
arg2_addr : .word 0
num_args : .word 0

valid_firsts: .asciiz "OSTIECXM"
valid_seconds: .asciiz "0123456789ABCDEF"
case_m_print: .asciiz "1."

.text:
.globl main
main:
	sw $a0, num_args

	lw $t0, 0($a1)
	sw $t0, arg1_addr
	lw $s1, arg1_addr

	lw $t1, 4($a1)
	sw $t1, arg2_addr
	lw $s2, arg2_addr

	j start_coding_here

# do not change any line of code above this section
# you can add code to the .data section
start_coding_here:
	jal	check_arguments
	jal	check_first
	jal	check_second
	
	caseO:
		addi	$t0, $0, 79			# loads ASCII for 'O'
		bne	$t1, $t0, caseS			# if the character doesn't match, go to the next case
		srl	$a0, $t2, 26			# shifts t2 so we look at the first 6 bits aka or the "O"pcode
		addi	$v0, $0, 36			# preparing to print out the opcode, unsigned
		syscall
		j	program_end
	caseS:
		addi	$t0, $0, 83			# loads ASCII for 'S'
		bne	$t1, $t0, caseT			# if the character doesn't match, go to the next case
		sll	$t2, $t2, 6			# knock out the opcode section
		srl	$a0, $t2, 27			# shift t2 to look at the new first 5 bits aka the r"S" field
		addi	$v0, $0, 36			# preparing to print out the rs register, unsigned
		syscall
		j	program_end
	caseT:
		addi	$t0, $0, 84			# loads ASCII for 'T'
		bne	$t1, $t0, caseI			# if the character doesn't match, go to the next case
		sll	$t2, $t2, 11			# knock out the opcode/rs section
		srl	$a0, $t2, 27			# shift t2 to look at the new first 5 bits aka the r"T" field
		addi	$v0, $0, 36			# preparing to print out the rt register, unsigned
		syscall
		j	program_end
	caseI:
		addi	$t0, $0, 73			# loads ASCII for 'I'
		bne	$t1, $t0, caseE			# if the character doesn't match, go to the next case
		sll	$t2, $t2, 16			# knock out the opcode/rs/rt section
		sra	$a0, $t2, 16			# shift t2 to look at the new first 16 bits, the "I"mmediate field //signed shifting to keep +ve -ve
		addi	$v0, $0, 1			# preparing to print out the immediate
		syscall
		j	program_end
	caseE:
		addi	$t0, $0, 69			# loads ASCII for 'E'
		bne	$t1, $t0, caseC			# if the character doesn't match, go to the next case
		sll	$t2, $t2, 31			# knock out 31 bits, so if we are even; remaining bit is 0 other remaining bit is 1
		beq	$t2, $0, even			# if the remaining bit is a 0, all bits will be 0 and therefore even
		j odd					# otherwise it must be odd
		j	program_end
	caseC:
		addi	$t0, $0, 67			# loads ASCII for 'C'
		bne	$t1, $t0, caseX			# if the character doesn't match, go to the next case
		addi	$a0, $0, 0			# clears register a0 to count the 1's
		addi	$t0, $0, 0			# sets our index var to 0
		addi	$t1, $0, 32			# we want to stop after 32 iteration(32 bits = 1 instruction)
		loop2:#no more better name >:(
			andi	$t3, $t2, 1		# removes all digits except for the lsb
			add	$a0, $a0, $t3		# add the previous result(0/1) to our counter
			srl	$t2, $t2, 1		# shifts our result left so we can check the 2nd lsb
			addi	$t0, $t0, 1		# increment our index counter
			bne	$t0, $t1, loop2		# test if we have fulfilled our condition
		addi	$v0, $0, 1			# preparting to print the number of 1's found
		syscall
		j 	program_end
	caseX:
		addi	$t0, $0, 88			# loads ASCII for 'X'
		bne	$t1, $t0, caseM			# if the character doesn't match, go to the next case
		sll	$t2, $t2, 1			# knock out the sign bit
		srl	$a0, $t2, 24			# shift t2 to look at the new first 8 bit aka the exponent
		addi	$a0, $a0, -127			# account for the bias
		addi	$v0, $0, 1			# preparing to print out the exponent
		syscall
		j	program_end
	caseM:
		addi	$t0, $0, 77			# loads ASCII for 'M'
		bne	$t1, $t0, program_end		# if the character doesn't match, go to the end // never true
		addi	$v0, $0, 4			# prepares the print the "whole number" part of the mantissa
		la	$a0, case_m_print		# loads the "1." part of the mantissa
		syscall
		addi	$v0, $0, 35			# prepares to print the rest of the mantissa, loop free :D
		sll	$a0, $t2, 9			# knock out the sign and exponent bits, and fills the rest with 0's
		syscall
		j	program_end
	
	
	j	program_end				# end // here to separate the "main" from the "functions" // should never run
	
	
	check_arguments: # check if the number of arguments are correct
		addi	$t2, $0, 2			# check_arguments // load number of arguments
		bne	$a0, $t2, wrongArg		# check number of arguments; a0 was cleaned in starter code
		jr	$ra
	check_first: # check if the first character is valid
		lbu	$t0, 0($s1)			# check_first // load first character in first argument
		la	$t2, valid_firsts		# loads the acceptable characters
		j	check_helper
	check_second: # checks if the second argument is valid
		# Potential way to optimize instruction count: use slt to check ASCII. check if between 48-70 but not 58-64 [ UNTESTED ] <<
		lbu	$t0, 0($s2)			# check_second // gets first character of second argument
		addi	$t3, $0, 48			# loads ASCII for '0'
		bne	$t0, $t3 ,errArg		# if the first character is a 0, continue
		lbu	$t0, 1($s2)			# gets second character of second argument
		addi	$t3, $0, 120			# loads ASCII for 'x'
		bne	$t0, $t3 ,errArg		# if the second character is a x, continue
		la	$t2, valid_seconds		# loads the acceptable characters
		move	$t3, $s2			# copies s2 into t3, so we can modify it freely
		addi	$t4, $s2, 8			# 3rd character + index 8 = 11, we should not continue loop
		move	$t5, $ra			# saves our return address, so we can call functions
		loop:				
			lbu	$t0, 2($t3)		# loads the current third character into t0
			jal	check_helper		# check if current character is valid
			jal	convert_hex		# not part of this function, but builds the binary representation			~~
			addi	$t3, $t3, 1		# on success, increment counter to read next
			la	$t2, valid_seconds	# reloads valid characters into t2
			bne	$t3, $t4, loop		# if we are on the 11th character, end loop
		lbu	$t1, 0($s1)			# not part of this function, but loads in first character to compare later		~~
		move	$t2, $s0			# not part of this function, but allows us to manipulate the hex value and keep it too	~~
		jr	$t5
	check_helper: # checks char at t0 with acceptable characters in t2
		lbu	$t1, 0($t2)			# check_helper // loads the next acceptable character
		beq	$t0, $t1, match			# and checks if it matches our input
		addi	$t2, $t2, 1			# increment counter to read next character
		beq	$t0, $0 , errArg		# argument characters reached a null character
		beq	$t1, $0 , errArg		# acceptable characters reached a null character
		j	check_helper			# loop until we find a match or a null
		match:
			jr $ra
	convert_hex: # shoves the byte in t0 into s0
		# Still believe that there is some sort of one-liner to convert it, but I could not for the life of me figure it out; Also ended up using slt so wasted work lol
		sll	$s0, $s0, 4			# convert_hex // shift binary by 4 to make room for new digits
		li	$t2, 60				# picked an arbitrary number between the '9' and 'A' ASCII code
		bge	$t0, $t2 ,character_found	# if our character is found to be greater than ASCII code 60 or higher, we found a character
		li	$s2, 48 			# 48 will "correct" the '0'-'9' ASCII code into values 0-9
		j	finishing
		character_found:
			li	$s2, 55			# 55 will "correct" the 'A'-'F' ASCII code into values 10-15
		finishing:
			sub	$t1, $t0, $s2		# get the value of the current bit
			or	$s0, $s0, $t1		# concatentate it with the previous results
			jr	$ra
	
	
	wrongArg: # uh oh number of arguments found were off
		addi	$v0, $0, 4			# tells user they have wrong amount of arguments
		la	$a0, WrongArgMsg
		syscall
		j	program_end
	errArg: # uh oh first character of the first argument is wrong
		addi	$v0, $0, 4			# tells user the arguments are formatted wrong
		la	$a0, ErrMsg
		syscall
		j	program_end
	even: # wow you're input was even
		addi	$v0, $0, 4			# tells user the second argument was even
		la	$a0, EvenMsg
		syscall
		j	program_end
	odd: # wow you're input was odd
		addi	$v0, $0, 4			# tells user the second argument was odd
		la	$a0, OddMsg
		syscall
		j	program_end
	
	
	program_end: # end the program
		li	$v0, 10
		syscall