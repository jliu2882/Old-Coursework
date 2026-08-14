############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

############################## Do not .include any files! #############################

.text

# Changed the parameters for stack_peek, stack_pop, and is_stack_empty. I pass tp instead of tp-4, but the function is still consistent with the test cases

eval: # Takes a null-terminated expression AExp in a0, and prints either the result or an error with no returns
	# There are no variables to be saved from the callee(hw2.asm) except $ra, but we should respect the case where the saved registers contains values
	# Strangely, "sw $a0, num_args" changes $sp to 0x7fffeff4, but the rest of the code should not be affected by two less "elements" on the stack
	# The way I implemented eval doesn't follow the description in the specifications exactly, but gets the same result by abusing the commutative property
	# Improvements we could build onto eval: "2(3+2)" works as "2*(3+2)" by pushing '*' and '(' if the previous element is a digit(already stored in $s6)
	# There are some lines of code I did not comment out that are redundant, but are there to future-proof any changes to functions like stack_pop
	addi	$sp, $sp, -32					# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)					# Saves $ra on stack
	sw	$s0, 4($sp)					# Saves $s0 on stack (Saving AExp)
	sw	$s1, 8($sp)					# Saves $s1 on stack (Saving val_stack)
	sw	$s2, 12($sp)					# Saves $s2 on stack (Saving op_stack)
	sw	$s3, 16($sp)					# Saves $s3 on stack (Saving tp for val_stack)
	sw	$s4, 20($sp)					# Saves $s4 on stack (Saving tp for op_stack)
	sw	$s5, 24($sp)					# Saves $s5 on stack (Will be saving current character in AExp)
	sw	$s6, 28($sp)					# Saves $s6 on stack (Will be saving type of previous character pushed)
	la	$s1, val_stack					# Creates value stack at s0
	la	$s2, op_stack					# Creates operator stack at s1
	addi	$s2, $s2, 2000					# Fixes address of operator stack so it doesn't coincide with value stack
	move	$s0, $a0					# Moves the AExp into a saved variable
	addi	$s3, $0 , 0					# Creates a variable for the top of the val_stack
	addi	$s4, $0 , 0					# Creates a variable for the top of the op_stack
	addi	$s6, $0 , 1					# Initialize s6 as some value other than 0 or -1
	loop:
		lbu	$a0, 0($s0)				# Loads first character of AExp
		beq	$a0, $0 , done				# If that character is null, AExp is done
		move	$s5, $a0				# Saves the current character, in case the function changes it
		addi	$s0, $s0, 1				# Moves to next character; no reason to save AExp
		jal	is_digit				# Returns 1 in v0 if the current character is a digit
		bne	$v0, $0 , digit				# If we get a digit, we should push it on val_stack
		addi	$s6, $0	, 1				# For future reference, we did not push in a digit
		move	$a0, $s5				# Loads in the current character back into the first argument
		jal	valid_ops				# Returns 1 in v0 if the current character is an operator
		bne	$v0, $0 , operator			# If we get an operator, we hould push it onto op_stack
		addi	$t0, $0 , 40				# Loads in the ASCII code for '('
		beq	$s5, $t0, open				# If the current character is '(', we should push it onto op_stack
		addi	$t0, $0 , 41				# Loads in the ASCII code for ')'
		beq	$s5, $t0, close				# If the current character is ')', we should pop op_stack until we reach a ')'
		la	$a0, BadToken				# If the current character isn't a digit, operator, or parenthesis, it's invalid
		j	error					# On errors, we should terminate the program
		digit:
			beqz	$s6, digit2			# If the previous element we pushed was a digit, we should push there again
			addi	$a0, $s5, -48			# Uses the ASCII code to push the numerical value into val_stack
			move	$a1, $s3			# Loads the top of the val_stack
			move	$a2, $s1			# Loads the base address of val_stack
			jal	stack_push			# Push the digit in
			move	$s3, $v0			# Save the top of val_stack
			move	$s6, $0				# For future reference, we pushed in a digit
			j	loop
		digit2:
			move	$a0, $s3			# Loads the top of val_stack
			move	$a1, $s1			# Loads the base address of val_stack
			jal	stack_pop			# Pops the top element of val_stack
			move	$s3, $v0			# Updates the top of val_stack
			addi	$t0, $0 , 10			# Multiply the last digit by 10(Base 10)
			mult	$v1, $t0			# This gives us an empty position for our current digit
			mflo	$a0				# Gets the result of the multiplication
			add	$a0, $a0, $s5			# Adds the current element to the new digit
			addi	$a0, $a0, -48			# Corrects for the element being in ASCII
		       #move	$a0, $a0			# Loads in the element to be pushed
			move	$a1, $s3			# Loads in the top of val_stack
			move	$a2, $s1			# Loads the base address of val_stack			
			jal	stack_push			# Pushes the new digit on the stack
			move	$s3, $v0			# Updates the top of val_stack
			j loop
		operator:
			move	$a0, $s4			# Loads top of op_stack
			jal	is_stack_empty			# Checks if the stack is empty
			bnez	$v0, push_operator		# If the stack is empty, we don't need to check previous operators			
		        move	$a0, $s4			# Loads top of op_stack
			move	$a1, $s2			# Loads the base address of op_stack
			jal	stack_peek			# Peeks at the top element in op_stack
			addi	$t0, $0 , 40			# Loads the ASCII value for '('
			beq	$v0, $t0, push_operator		# If the current top operator is a '(', we should ignore the new operator
			move	$a0, $v0			# Loads the operator to check its precedence
			jal	op_precedence			# Checks the precedence of the top operator
			bnez	$v0, pop_operator		# If the current top operator is a '*' or '/', we should pop it
			move	$a0, $s5			# Loads the operator of the current character
			jal	op_precedence			# Checks the precedence of the current character
			beqz	$v0, pop_operator		# If the new operator is a '+' or '-', we should pop it
			j	push_operator			# Otherwise, we should just push the operator on the stack
			pop_operator:
				move	$a0, $s1			# Loads the base address of val_stack
				move	$a1, $s2			# Loads the base address of op_stack
				move	$a2, $s3			# Loads the top of val_stack
				move	$a3, $s4			# Loads the top of op_stack
				jal	pop_op_stack			# Pops off an operator and two operands and perform the operation
				move	$s3, $v0			# Update the top of val_stack
				move	$s4, $v1			# Update the top of op_stack
				j	operator			# Checks the current operator against the next highest operator
			push_operator:
				move	$a0, $s5			# Loads the element we want to push into op_stack
				move	$a1, $s4			# Loads the top of the op_stack
				move	$a2, $s2			# Loads the base address of op_stack
				jal	stack_push			# Push the digit in
				move	$s4, $v0			# Save the top of op_stack
				j	loop
		open:
			addi	$s6, $0	, -1			# For future reference, we pushed in a '('
			move	$a0, $s5			# Loads the element we want to push into op_stack
			move	$a1, $s4			# Loads the top of the op_stack
			move	$a2, $s2			# Loads the base address of op_stack
			jal	stack_push			# Push the digit in
			move	$s4, $v0			# Save the top of op_stack
			j	loop
		close:
			addi	$t0, $0 , -1			# Loads our symbol for '('
			beq	$s6, $t0, bad_parenthesis	# If the previous character was a ')', we have '()', which is invalid
			close_loop:
				move	$a0, $s4		# Loads the top of the op_stack
				jal	is_stack_empty		# Checks if op_stack is empty
				bnez	$v0, bad_parenthesis	# If op_stack is empty, we have a ')' without a '('
				move	$a0, $s4		# Loads top of op_stack
				move	$a1, $s2		# Loads the base address of op_stack
				jal	stack_peek		# Peeks at the top element in op_stack
				addi	$t0, $0 , 40		# Loads ASCII code for '('
				bne	$v0, $t0, no_match	# If we didn't see '(', we should pop and perform the operator
				move	$a0, $s4		# Loads top of op_stack
				move	$a1, $s2		# Loads the base address of op_stack
				jal	stack_pop		# Pops off the top '('
				move	$s4, $v0		# Updates the new top of op_stack
				j	loop
				no_match:
					move	$a0, $s1	# Loads the base address of val_stack
					move	$a1, $s2	# Loads the base address of op_stack
					move	$a2, $s3	# Loads the top of val_stack
					move	$a3, $s4	# Loads the top of op_stack
					jal	pop_op_stack	# Pops off an operator and two operands and perform the operation
					move	$s3, $v0	# Update the top of val_stack
					move	$s4, $v1	# Update the top of op_stack
					j	close_loop	# Created a new label under "beq $s6, $t0, bad_parens" to reduce lines of code		
			bad_parenthesis:
				la	$a0, ParseError		# If we push a ')' when the operator stack is empty, we don't have '('
				j	error			# Terminates the program
	done:
		move	$a0, $s4				# Loads the top of the op_stack	
		jal	is_stack_empty				# Checks if op_stack is empty
		bnez	$v0, continue				# If op_stack is empty, we can skip the next bit
		move	$a0, $s1				# Loads val_stack
		move	$a1, $s2				# Loads op_stack
		move	$a2, $s3				# Loads top of val_stack
		move	$a3, $s4				# Loads top of op_stack
		jal	pop_op_stack				# Pop an operator and two values and performs the operations
		move	$s3, $v0				# Update the top of val_stack
		move	$s4, $v1				# Update the top of op_stack
		j	done					# Keep pushing operators until the operator stack is empty
		continue:
			move	$a0, $s3			# Loads the top of val_stack
			move	$a1, $s1			# Loads the base address of val_stack
			jal	stack_peek			# Peeks at the top element of val_stack
			move	$a0, $v0			# There will only be 1 value in val_stack due to the way our algorithm is coded
			li	$v0, 1				# Our final result is an integer, so we use syscall 1
			syscall					# Prints the final result
			lw	$ra, 0($sp)			# Restores $ra from stack
			lw	$s0, 4($sp)			# Restores $s0 from stack
			lw	$s1, 8($sp)			# Restores $s1 from stack
			lw	$s2, 12($sp)			# Restores $s2 from stack
			lw	$s3, 16($sp)			# Restores $s3 from stack
			lw	$s4, 20($sp)			# Restores $s4 from stack
			lw	$s5, 24($sp)			# Restores $s5 from stack
			lw	$s6, 28($sp)			# Restores $s6 from stack
			addi	$sp, $sp, 32			# Deallocate stack space
			jr	$ra

is_digit: # returns 1 in v0 if the value in a0 is a digit; 0 otherwise. ASCII code values from 48-57 (0-9)
	addi	$v0, $0 , 0					# assumes a0 isn't a digit unless proven wrong
	addi	$t0, $0 , 47					# loads ASCII for '0'
	bge	$t0 ,$a0, not_digit				# if the ASCII for a0 is under 48, it must not be a digit
	addi	$t0, $0 , 58					# loads ASCII for '9'
	bge	$a0 ,$t0, not_digit				# similarly, if it is greater than 57, it could not be a digit
	addi	$v0, $0 , 1					# we have proven that the ASCII for a0 must lie from 48-57
	not_digit: # label invalid if you made it here without branching :)
		jr	$ra

stack_push: # returns the new top of stack in v0 after we push a0 into the stack whose top is a1 with base addresses a2
	addi	$t0, $0 , 2000					# technically, 1997 works, since elements are multiple of 4, but 2000 is a nicer number
	bge	$a1, $t0, push_full				# if we have 500+ elements * 4 bytes, the stack is full
	add	$t0, $a2, $a1					# t0 now contains address where the stack is first empty (assuming proper a1 input)
	sw	$a0, 0($t0)					# push a0 where the stack was first empty (no way to store word using registers as offset)
	addi	$v0, $a1, 4					# the top of the stack moves by the size of the element
	jr 	$ra
	push_full:
		la	$a0, ApplyOpError			# stack is full, but could be proper form; so operation could not be applied
		j	error					# terminates the program

stack_peek: # returns the element at the top of the stack in v0 given the top of the stack a0 and the stack base address a1
	addi	$a0, $a0, -4					# move tp to get the top element
	bltz	$a0, peek_empty					# if the top of stack is below 0(tp-4<0), the stack is empty and we can't peek
	add	$t0, $a1, $a0					# move pointer to current element to pop
	lw	$v0, 0($t0)					# get the element at a1 into return v0
	jr 	$ra
	peek_empty:
		la	$a0, ParseError				# stack is empty implies that there is an imbalance of operators and operands
		j	error					# terminates the program

stack_pop: # returns the new top of stack in v0 and element popped in v1 after we pop the element at a0 in array of base address a1
	addi	$a0, $a0, -4					# move tp to get the top element
	bltz	$a0, pop_empty					# if the top of stack is 0 or below(therefore a0 is negative), the stack is empty
	add	$t0, $a1, $a0					# move pointer to current element to pop
	lw	$v1, 0($t0)					# get the element we "popped" into v1 ("pop" since we can overwrite it)
	move 	$v0, $a0 					# test cases show that 0 in a0 gives 0 in v0, and with tp=4, we are "given" 0
	jr 	$ra
	pop_empty:
		la	$a0, ParseError				# stack is empty implies that there is an imbalance of operators and operands
		j	error					# terminates the program

is_stack_empty: # returns 1 in v0 if the stack is empty; 0 otherwise. the top of the stack is given in a0
	addi	$a0, $a0, -4					# top of the stack is 4 above the top element
	addi	$v0, $0 , 1					# assumes stack is empty by default
	bltz	$a0, stack_empty				# if the top element is negative//tp is 0, the stack is empty
	addi	$v0, $0 , 0					# if it wasn't empty, return 0
	stack_empty:
		jr $ra

valid_ops: # returns 1 in v0 if the value in a0 is a valid operator; 0 otherwise. ASCII CODE values at 42, 43, 45, 47 (*+-/)
	addi	$v0, $0 , 1					# assumes a0 is valid unless proven wrong
	addi	$t0, $0 , 42					# loads ASCII for '*'
	beq	$t0, $a0, valid_operator			# if the ASCII is '*', it must be valid
	addi	$t0, $0 , 43					# loads ASCII for '+'
	beq	$t0, $a0, valid_operator			# if the ASCII is '+', it must be valid
	addi	$t0, $0 , 45					# loads ASCII for '-'
	beq	$t0, $a0, valid_operator			# if the ASCII is '-', it must be valid
	addi	$t0, $0 , 47					# loads ASCII for '/'
	beq	$t0, $a0, valid_operator			# if the ASCII is '/', it must be valid
	addi	$v0, $0 , 0					# we have proven that the ASCII is not valid
	valid_operator: # label invalid if you made it here without branching >:(
		jr	$ra

op_precedence: # returns the precedence of the operator in a0 of values 0 and 1 in v0
	addi	$v0, $0 , 1					# assumes a0 has the highest op precedence
	addi	$t0, $0 , 42					# loads ASCII for '*'
	beq	$t0, $a0, peMDas				# if the ASCII is '*', it will have greater precedence
	addi	$t0, $0 , 47					# loads ASCII for '/'
	beq	$t0, $a0, peMDas				# if the ASCII is '/', it must have greater precedence
	addi	$t0, $0 , 43					# loads ASCII for '+'
	beq	$t0, $a0, pemdAS				# if the ASCII is '+', it must be valid
	addi	$t0, $0 , 45					# loads ASCII for '-'
	beq	$t0, $a0, pemdAS				# if the ASCII is '-', it must be valid
	la	$a0, ParseError					# if the operator is '(' and we aren't searching for it from a ')', we should get an error
	j	error						# exit the program * note that other operators would never be passed from op_stack
	pemdAS:#hehe Addition/Subtraction part of PEMDAS(precedence 0)
		addi	$v0, $v0, -1				# if the operator is +-, the precedence should be less than the precedence for */
	peMDas:#hehe Multiplication/Division part of PEMDAS(precedence 1)
		jr	$ra

apply_bop: # returns integer result of a0 (op in a1) a2 in v0
	addi	$t0, $0 , 43					# loads ASCII for '+'
	beq	$t0, $a1, addition				# if the ASCII is '+', we add a0 a2
	addi	$t0, $0 , 45					# loads ASCII for '-'
	beq	$t0, $a1, subtraction				# if the ASCII is '-', we subtract a0 a2
	addi	$t0, $0 , 42					# loads ASCII for '*'
	beq	$t0, $a1, multiplication			# if the ASCII is '*', it must be valid
	addi	$t0, $0 , 47					# loads ASCII for '/'
	beq	$t0, $a1, division				# if the ASCII is '/', it must be valid
	addition:
		add	$v0, $a0, $a2				# add a0 and a2
		j	operation_performed
	subtraction:
		sub	$v0, $a0, $a2				# subtract a0 by a2
		j	operation_performed
	multiplication:
		mult	$a0, $a2				# multiply a0 with a2
		mflo	$v0					# we are told to ignore upper 32-bits of the product
		j	operation_performed
	division:
		beqz	$a2, division_error			# if we are attemping to divide by zero, we should return an error
		div	$a0, $a2				# divide a0 by a2
		mflo	$v0					# we have to fix the cases where we have a remainder; MIPS gives us the integer division rather than floor division
		mfhi	$t1					# first, we must determine if there is a remainder
		beqz	$t1, operation_performed		# there was not, so there is no need for correction
		xor	$t0, $a0, $a2				# if either a0 or a2 (not both) are negative, we need to "fix" the integer division
		srl	$t0, $t0, 31				# keeps only the sign bit, to tell if a0 XOR a2 was negative
		sub	$v0, $v0, $t0				# if the quotient is positive, we are subtracting 0, otherwise we subtract 1 to "adjust" integer division rounding
		j	operation_performed 			# not needed but :) // nvm, needed now so :)
		division_error:
			la $a0, ApplyOpError			# if we have to try to divide by zero, it should fail
			j error					# terminates the program
	operation_performed:
		jr	$ra

#HELPER FUNCTIONS

error: # given a0 is the error message, it will print it and terminate the program
	li	$v0, 4						# loads system print in v0
	syscall							# prints the error message
	li	$v0, 10						# loads system end in v0
	syscall							# ends program

pop_op_stack: # given val_stack/op_stack in a0/a1, the tp for val/op in a2/a3; pop an operator, two values, do the math, and push it; returns the new tops in v0(val)/v1(op)
	addi	$sp, $sp, -28					# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)					# Saves $ra on stack
	sw	$s0, 4($sp)					# Saves $s0 on stack (Saving val_stack base address)
	sw	$s1, 8($sp)					# Saves $s1 on stack (Saving op_stack base address // will save operator)
	sw	$s2, 12($sp)					# Saves $s2 on stack (Saving tp for val_stack)
	sw	$s3, 16($sp)					# Saves $s3 on stack (Saving tp for op_stack)
	sw	$s4, 20($sp)					# Saves $s4 on stack (Saving first operand)
	sw	$s5, 24($sp)					# Saves $s5 on stack (Saving second operand)
	move	$s0, $a0					# Saves the arguments for pop_op_stack to call other functions
	move	$s1, $a1					# Saves the arguments for pop_op_stack to call other functions
	move	$s2, $a2					# Saves the arguments for pop_op_stack to call other functions
	move	$s3, $a3					# Saves the arguments for pop_op_stack to call other functions
	move	$a0, $s2					# Loads the top of the value stack as the argument for the first call
	move	$a1, $s0					# Loads the base addresses of the val_stack
	jal	stack_pop					# Pops the top operand as the 2nd operand
	move	$s5, $v1					# Saves the operand for later use
        move	$a0, $v0					# Loads the top of the value stack as the argument for the next call
	move	$a1, $s0					# Loads the base address of the val_stack
	jal	stack_pop					# Pops the top operand as the 1st operand
	move	$s4, $v1					# Saves the operand for later use
	move	$s2, $v0					# Update the top of the val_stack
	move	$a0, $s3					# Loads the top of the operator stack as the argument
	move	$a1, $s1					# Loads the base address of the op_stack
	jal	stack_pop					# Pops the top operator as the operator for apply_bop
	move	$s1, $v1					# Saves the operator for later use [op_stack base address not needed anymore]
	move	$s3, $v0					# Update the top of the op_stack
	move	$a0, $s4					# Loads the first operand(lower on val_stack)
	move	$a1, $s1					# Loads the operator
	move	$a2, $s5					# Loads the second operand(higher on val_stack)
	jal	apply_bop					# Applies the operation with the two operands
	move	$a0, $v0					# Loads the result into the argument for pushing
	move	$a1, $s2					# Loads the updated top of val_stack for pushing
	move	$a2, $s0					# Loads the base address of val_stack for pushing
	jal	stack_push					# Pushes the result into val_stack
       #move    $v0, $v0					# Loads the new top of the stack for val_stack
        move	$v1, $s3					# Loads the new top of the stack for op_stack
	lw	$ra, 0($sp)					# Restores $ra from stack
	lw	$s0, 4($sp)					# Restores $s0 from stack
	lw	$s1, 8($sp)					# Restores $s1 from stack
	lw	$s2, 12($sp)					# Restores $s2 from stack
	lw	$s3, 16($sp)					# Restores $s3 from stack
	lw	$s4, 20($sp)					# Restores $s4 from stack
	lw	$s5, 24($sp)					# Restores $s5 from stack
	addi	$sp, $sp, 28					# Deallocate stack space
	jr	$ra
