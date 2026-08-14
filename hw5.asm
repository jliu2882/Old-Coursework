############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:

create_term: # Create a polynomial term if the coefficient and exponent allow, and gives us the address of the term
#a0 contains the coefficient for our term, which we will check if it is non-zero
#a1 contains the exponent for our term, which we will check if it is non-negative
#v0 will contain the address of a single polynomial term or -1 if there was an error
	beqz	$a0, cannotCreate					# If the coefficient is 0, we don't have a term
	bltz	$a1, cannotCreate					# If the exponent is negative, we don't want to add it
	move	$t0, $a0						# Move our argument to another register since sbrk needs a0
	li	$a0, 12							# Allocate 12 bytes for our new term
	li	$v0, 9							# Load syscall to allocate memory//sbrk
	syscall								# Allocate the space
	sw	$t0, 0($v0)						# Store the coefficient in the allocated space
	sw	$a1, 4($v0)						# Store the exponent in the allocated space
	sw	$0 , 8($v0)						# Initialize the final 4 bytes to point to NULL//0
	jr $ra
	cannotCreate:
		addi	$v0, $0 , -1					# We want to return -1 if the term cannot be created
		jr	$ra

init_polynomial: # Initiliaze our polynomial with the term in a1 and store the term into the address at a0
#a0 contains a pointer p to an address for the head node
#a1 contains a pair in an array representing the term for our polynomial
#v0 will contain 1 if we succeeded in creating the polynomial, and -1 if we failed
	addi	$sp, $sp, -8						# Allocate space on the stack to store $ra and saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Store $s0 on stack(will save the pointer p)
	move	$s0, $a0						# Save the pointer
	lw	$a0, 0($a1)						# Load the coefficient for the term
	lw	$a1, 4($a1)						# Load the exponent for the term
	jal	create_term						# Create a term, and get the address in $v0
	bltz	$v0, cannotInit						# We could not make a term
	sw	$v0, 0($s0)						# Store the address of our term into the pointer
	addi	$v0, $0 , 1						# We should return 1 on success
	j	initiated						# We created the polynomial
	cannotInit:
		addi	$v0, $0 , -1					# We should return -1 on fails
	initiated:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		addi	$sp, $sp, 8					# Deallocate stack space
		jr $ra

add_N_terms_to_polynomial: # Add up to N terms in a way that keeps terms ordered by their exponent
#a0 contains a pointer p to a polynomial
#a1 contains an array of pairs that will always end up (0,-1)
#a2 contains the number of terms added to the polynomial, represented by as an integer N
#v0 will contain the number of terms added
	addi	$sp, $sp, -24						# Allocate space on the stack to store $ra and saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Store $s0 on stack(will save $a0)
	sw	$s1, 8($sp)						# Store $s1 on stack(will save $a1)
	sw	$s2, 12($sp)						# Store $s2 on stack(will save $a2)
	sw	$s3, 16($sp)						# Store $s3 on stack(will save $v0)
	sw	$s4, 20($sp)						# Store $s4 on stack(will save the position in the polynomial current term belongs in)
	move	$s0, $a0						# Store the pointer p
	move	$s1, $a1						# Store the array of pairs
	move	$s2, $a2						# Store the number of terms we want to add
	move	$s3, $0							# We initially updated no terms
	addTermLoop:
		blez	$s2, addedTerms					# If we have considered all the terms, we should stop doing more
		addi	$s2, $s2, -1					# Consider the next term, so we decrease this now
		lw	$t0, 0($s1)					# Read the coefficient of the current pair
		bnez	$t0, notEndLoop					# If it wasn't a 0, it couldn't have been the 0,-1 end of term array
		lw	$a1, 4($s1)					# Read the exponent of the current pair
		addi	$t1, $0 , -1					# We want to see if we have a -1
		bne	$a1, $t1, notEndLoop				# If it wasn't a -1, it couldnt' have been the 0,-1 end of term array
		j	addedTerms					# We have added the terms in the term array and can't continue(received a 0,-1)
		notEndLoop:
			move	$a0, $s0				# Load the start pointer to see if the exponent exists
			lw	$a1, 4($s1)				# Read the exponent of the current pair
			jal	check_exponent				# See if the exponent exists already
			blez	$v1, addNextSkip			# The exponent exists already or is invalid(if we branch)
			move	$s4, $v0				# Save the position we should put the term in
			lw	$a0, 0($s1)				# Load coefficient
			lw	$a1, 4($s1)				# Load exponent
			jal	create_term				# Create the term
			bltz	$v0, addNextSkip			# We could not create the term
			move	$a0, $s0				# Load the pointer p
			move	$a1, $v0				# Load the term we want to add
			move	$a2, $s4				# Load the position where we want to add
			jal	add_term				# Add the term into the polynomial since we've confirmed it doesn't exist yet
			addi	$s3, $s3, 1				# We added one term succesfully
			addNextSkip:
				addi	$s1, $s1, 8			# Read the next pair
				j	addTermLoop			# Loop until we consider enough terms
	addedTerms:
		move	$v0, $s3					# load the number of terms we added
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		lw	$s4, 20($sp)					# Restores $s4 from stack
		addi	$sp, $sp, 24					# Deallocate stack space
		jr $ra

update_N_terms_in_polynomial: # Update up to N terms and changes the coefficient if applicable
#a0 contains a pointer p to a polynomial
#a1 contains an array of pairs that will always end up (0,-1)
#a2 contains the number of terms to update for the polynomial, represented by as an integer N
#v0 will contain the number of terms updated
	addi	$sp, $sp, -28						# Allocate space on the stack to store $ra and saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Store $s0 on stack(will save $a0)
	sw	$s1, 8($sp)						# Store $s1 on stack(will save $a1)
	sw	$s2, 12($sp)						# Store $s2 on stack(will save $a2)
	sw	$s3, 16($sp)						# Store $s3 on stack(will save $v0)
	sw	$s4, 20($sp)						# Store $s4 on stack(will save the position in the polynomial current term belongs in)
	sw	$s5, 24($sp)						# Store $s5 on stack(will save the offset to the stack pointer)
	move	$s0, $a0						# Store the pointer p
	move	$s1, $a1						# Store the array of pairs
	move	$s2, $a2						# Store the number of terms we want to update
	move	$s3, $0							# We initially updated no terms
	addi	$sp, $sp, -4						# Allocate an empty space to know where the updated terms end
	sw	$0 , 0($sp)						# Make sure it's empty so we know that this is the end of updated terms
	addi	$s5, $0	, 4						# As we subtract from sp, we increase s5
	updateTermLoop:
		blez	$s2, updatedTerms				# If we have considered all the terms, we should stop doing more
		addi	$s2, $s2, -1					# Consider the next term, so we decrease this now
		lw	$t0, 0($s1)					# Read the coefficient of the current pair
		bnez	$t0, notEndThisLoop				# If it wasn't a 0, it couldn't have been the 0,-1 end of term array
		lw	$a1, 4($s1)					# Read the exponent of the current pair
		addi	$t1, $0 , -1					# We want to see if we have a -1
		bne	$a1, $t1, notEndThisLoop			# If it wasn't a -1, it couldnt' have been the 0,-1 end of term array
		j	updatedTerms					# We have added the terms in the term array and can't continue(received a 0,-1)
		notEndThisLoop:
			move	$a0, $s0				# Load the start pointer to see if the exponent exists
			lw	$a1, 4($s1)				# Read the exponent of the current pair
			jal	check_exponent				# See if the exponent exists already
			bnez	$v1, updateNextSkip			# The exponent doesn't exist yet or was invalid(if we branch)
			move	$s4, $v0				# Save the position we should put the term in
			move	$a0, $s0				# Load the pointer p
			lw	$a1, 0($s1)				# Load coefficient
			move	$a2, $s4				# Load the position where we want to update
			jal	update_term				# Update the term into the polynomial since we've confirmed it doesn't exist yet
			lw	$t0, 0($s1)				# Get coefficient
			move	$t1, $sp				# Store stack pointer in t1 so we can change it freely
			updatedCheck:
				lw	$t2, 0($t1)			# Load the current term in the updated terms
				beq	$t0, $t2, updateNextSkip	# If our term was in the array already, we don't update anything
				beqz	$t2, addNewUpdated		# If we reach the end of the updated terms, we should add this to the list
				j	updatedCheck			# We will keep looping until we reach the end of updated terms or find a match
			addNewUpdated:
				addi	$sp, $sp, -4			# Make room for a new term
				addi	$s5, $s5, 4			# We allocated 4 more bytes
				sw	$t0, 0($sp)			# Store the new exponent into the updated terms
				addi	$s3, $s4, 1			# We updated one new term
			updateNextSkip:
				addi	$s1, $s1, 8			# Read the next pair
				j	updateTermLoop			# Loop until we consider enough terms
	updatedTerms:
		move	$v0, $s3					# load the number of terms we added
		add	$sp, $sp, $s5					# Restore it by the offset
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		lw	$s4, 20($sp)					# Restores $s4 from stack
		lw	$s5, 24($sp)					# Restores $s5 from stack
		addi	$sp, $sp, 28					# Deallocate stack space
		jr $ra

get_Nth_term: # Return the Nth highest exponent in the polynomial
#a0 contains a pointer p to a polynomial
#a1 contains an integer N to determine which term we get(with 1 being the first term etc..)
#v0 will contain the exponent of the term, -1 if it was not found
#v1 will contain the coefficient of the term, 0 if it was not found
	lw	$a0, 0($a0)						# Go to the head polynomial
	beqz	$a0, fail						# We couldn't get the next term because there was none
	blez	$a1, fail						# You can't get negative position
	addi	$a1, $a1, -1						# Change it from 1-index to 0-index
	getNextLoop:
		beqz	$a1, getElement					# We have reached the index we want to add the element
		addi	$a1, $a1, -1					# Move forward/decrese index to reach our position
		lw	$a0, 8($a0)					# Replace the position with the one next in the polynomial
		beqz	$a0, fail					# We couldn't get the next term because there was none
		j	getNextLoop					# The input will be valid, so we keep going until our index is 0
	getElement:
		lw	$v1, 0($a0)					# Load the coefficient
		lw	$v0, 4($a0)					# Load the exponent
		jr	$ra
	fail:
		addi	$v1, $0	, -1					# Load -1 into return value
		addi	$v0, $0 , -1					# Load -1 into return value
		jr	$ra

remove_Nth_term: # Removes the Nth highest exponent term
#a0 contains a pointer p to a polynomial
#a1 contains an integer N to determine which term we delete(with 1 being the first term etc..)
#v0 will contain the expoenent of the term, -1 if it was not found
#v1 will contain the coefficient of the term, 0 if it was not found
	lw	$a0, 0($a0)						# Go to the head polynomial
	beqz	$a0, fail						# We couldn't get the next term because there was none
	blez	$a1, fail2						# You can't get negative position
	addi	$a1, $a1, -1						# Change it to a 0-index
	beqz	$a1, removeFirst					# This is a special case where we want to remove p; so we'll "replace" it with the second
	addi	$a1, $a1, -1						# Subtract 1 sice we want to insert before that position, 0 is excluded from above
	removeLoop:
		beqz	$a1, positionFound2				# We have reached the index we want to add the element
		addi	$a1, $a1, -1					# Move forward/decrese index to reach our position
		lw	$a0, 8($a0)					# Replace the position with the one next in the polynomial
		beqz	$a0, fail2					# We couldn't get the next term because there was none
		j	removeLoop					# The input will be valid, so we keep going until our index is 0
	removeFirst:
		lw	$t0, 8($a0)					# Get the address of the node after the deleted node(p)
		lw	$t1, 0($t0)					# Get its coefficient
		lw	$t2, 4($t0)					# Get its exponent
		lw	$t3, 8($t0)					# Get its pointer
		sw	$t1, 0($a0)					# Set that to be the header
		sw	$t2, 4($a0)					# We are basically deleting the second node
		sw	$t3, 8($a0)					# After copying it over, so we really are deleting the first
		j	removed
	positionFound2:
		lw	$t0, 8($a0)					# Get the address of the node to be deleted
		lw	$t0, 8($t0)					# Get the node after the deleted node
		sw	$t0, 8($a0)					# Skip over the deleted node by moving from the previous to the next
	removed:
		jr	$ra
	fail2:
		addi	$v1, $0	, -1					# Load -1 into return value
		addi	$v0, $0 , -1					# Load -1 into return value
		jr	$ra

add_poly: # Adds two polynomials together
#a0 contains a pointer p to the first polynomial
#a1 contains a pointer q to the second polynomial
#a2 contains a pointer r to the resulting polynomial
#v0 will contain 0 or 1 depending on if we succesfully added the term or not(1 if yes)
	addi	$sp, $sp, -20						# Allocate space on the stack to store $ra and saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Store $s0 on stack(will save $a0)
	sw	$s1, 8($sp)						# Store $s1 on stack(will save $a1)
	sw	$s2, 12($sp)						# Store $s2 on stack(will save $a2)
	sw	$s3, 16($sp)						# Store $s3 on stack(will save the offset to the stack pointer)
	move	$s0, $a0						# Store the pointer p
	move	$s1, $a1						# Store the pointer q
	move	$s2, $a2						# Store the pointer r; keep as pointer
	lw	$s0, 0($s0)						# Get p, we don't need the actual pointer
	lw	$s1, 0($s1)						# Get q, same reasoning
	li	$a0, 12							# Allocate 12 bytes for r
	li	$v0, 9							# Load syscall to allocate memory//sbrk
	syscall								# Allocate the space
	sw	$v0, 0($s2)						# Store the new address in our pointer r
	sw	$0 , 0($v0)						# Set the pointer in r to be a null node
	sw	$0 , 4($v0)						# Set the pointer in r to be a null node
	sw	$0 , 8($v0)						# Set the pointer in r to be a null node
	addi	$sp, $sp, -8						# Create an array in stack but initialize to end with 0,-1
	addi	$t0, $0 , -1						# We need a -1
	sw	$0 , 0($sp)						# Add the 0
	sw	$t0, 4($sp)						# Add the -1
	addi	$s3, $0 , 8						# Memory allocated initialized at 8
	iterateP:
		beqz	$s0, iterateQ					# If the polynomial p points to null, then we reached the end
		addi	$sp, $sp, -8					# Add another term
		addi	$s3, $s3, 8					# We allocated 8 more bytes
		lw	$t0, 0($s0)					# Get the coefficient of the term
		sw	$t0, 0($sp)					# Store it into the term array
		lw	$t0, 4($s0)					# Get the exponent of the term
		sw	$t0, 4($sp)					# Store it into the term array
		lw	$s0, 8($s0)					# Go to the next term
		j	iterateP					# If it was null, we will catch it at the start
	iterateQ:
		beqz	$s1, combineTerms				# If the polynomial p points to null, then we reached the end
		addi	$sp, $sp, -8					# Add another term
		addi	$s3, $s3, 8					# We allocated 8 more bytes
		lw	$t0, 0($s1)					# Get the coefficient of the term
		sw	$t0, 0($sp)					# Store it into the term array
		lw	$t0, 4($s1)					# Get the exponent of the term
		sw	$t0, 4($sp)					# Store it into the term array
		lw	$s1, 8($s1)					# Go to the next term
		j	iterateQ					# If it was null, we will catch it at the start
	combineTerms:
		move	$a0, $s2					# Load the pointer r
		move	$a1, $sp					# The term array is in stack pointer
		jal	add_update_N_terms				# Add/Update the terms(hehe specialized helper function) the return value is done here :)
		add	$sp, $sp, $s3					# Restore it by the offset
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		addi	$sp, $sp, 20					# Deallocate stack space
		jr	$ra

mult_poly: # Multiply two polynomials together
#a0 contains a pointer p to the first polynomial
#a1 contains a pointer q to the second polynomial
#a2 contains a pointer r to the resulting polynomial
#v0 will contain 0 or 1 depending on if we succesfully added the term or not(1 if yes)
	addi	$sp, $sp, -28						# Allocate space on the stack to store $ra and saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Store $s0 on stack(will save $a0)
	sw	$s1, 8($sp)						# Store $s1 on stack(will save $a1)
	sw	$s2, 12($sp)						# Store $s2 on stack(will save $a2)
	sw	$s3, 16($sp)						# Store $s3 on stack(will save the offset to the stack pointer)
	sw	$s4, 20($sp)						# Store $s4 on stack(will save $a1 again...)
	sw	$s5, 24($sp)						# Store $s5 on stack(will save $a0 again...)
	move	$s0, $a0						# Store the pointer p
	move	$s5, $a0						# Store the pointer p
	move	$s1, $a1						# Store the pointer q
	move	$s4, $a1						# Store the pointer q
	move	$s2, $a2						# Store the pointer r
	lw	$s0, 0($s0)						# Get p, we don't need the actual pointer
	lw	$s1, 0($s1)						# Get q, same reasoning
	li	$a0, 12							# Allocate 12 bytes for r
	li	$v0, 9							# Load syscall to allocate memory//sbrk
	syscall								# Allocate the space
	sw	$v0, 0($s2)						# Store the new address in our pointer r
	sw	$0 , 0($v0)						# Set the pointer in r to be a null node
	sw	$0 , 4($v0)						# Set the pointer in r to be a null node
	sw	$0 , 8($v0)						# Set the pointer in r to be a null node
	addi	$sp, $sp, -8						# Create an array in stack but initialize to end with 0,-1
	addi	$t0, $0 , -1						# We need a -1
	sw	$0 , 0($sp)						# Add the 0
	sw	$t0, 4($sp)						# Add the -1
	addi	$s3, $0 , 8						# Memory allocated initialized at 8
	beqz	$s0, nullTerm						# too lazy to write comments just here to fix
	lw	$t0, 0($s0)						# Get the coefficient(we already got the first term)
	lw	$t1, 4($s0)						# Get the exponent
	beqz	$t0, nullTerm						# There are no terms currently or invalid terms in p
	bltz	$t1, nullTerm						# The exponent was invalid, so there must be no terms in p
	beqz	$s1, nullTerm						# too lazy to write comments just here to fix
	lw	$t0, 0($s1)						# Get the coefficient(we already got the first term)
	lw	$t1, 4($s1)						# Get the exponent(note we know that p has terms)
	beqz	$t0, nullTerm						# There are no terms currently or invalid terms in q
	bltz	$t1, nullTerm						# The exponent was invalid, so there must be no terms in q
	j	iterateP2
	nullTerm:		
		move	$a0, $s5					# To comply with the rules, if we get a null, we return the other
		move	$a1, $s4					# If we get one null, we return 1 after putting the other in r(0+q,etc..)
		move	$a2, $s2					# If we get two null, we return null//0
		jal	add_poly					# TLDR add_poly gives us our proper return values already
		j	done
	iterateP2:
		beqz	$s0, combineTerms2				# If the polynomial p points to null, then we reached the end
		lw	$t0, 0($s0)					# Get the coefficient of the term
		lw	$t1, 4($s0)					# Get the exponent of the term
		lw	$s1, 0($s4)					# Reset the pointer q to multiply with the new term
		iterateQ2:
			beqz	$s1, iterateQDone			# If the polynomial p points to null, then we reached the end
			lw	$t2, 0($s1)				# Get the coefficient of the term
			lw	$t3, 4($s1)				# Get the exponent of the term
			mult	$t0, $t2				# Multiplying terms => multiply the coefficient
			mflo	$t2					# We are to assume that the product fits
			add	$t3, $t1, $t3				# Multiplying terms => add the number up
			addi	$sp, $sp, -8				# Add another term
			addi	$s3, $s3, 8				# We allocated 8 more bytes
			sw	$t2, 0($sp)				# Store it into the term array
			sw	$t3, 4($sp)				# Store it into the term array
			lw	$s1, 8($s1)				# Go to the next term in q
			j	iterateQ2				# If it was null, we will catch it at the start
		iterateQDone:
			lw	$s0, 8($s0)				# Go to the next term in p
			j	iterateP2				# If it was null, we will catch it at the start
	combineTerms2:
		move	$a0, $s2					# Load the pointer r
		move	$a1, $sp					# The term array is in stack pointer
		jal	add_update_N_terms				# Add/Update the terms(hehe specialized helper function) the return value is done here :)
	done:
		add	$sp, $sp, $s3					# Restore it by the offset
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		lw	$s4, 20($sp)					# Restores $s4 from stack
		lw	$s5, 24($sp)					# Restores $s5 from stack
		addi	$sp, $sp, 28					# Deallocate stack space
		jr	$ra

################# HELPER FUNCTION #################

check_exponent: # Checks to see if an exponent can be added to a polynomial
#a0 contains a pointer p to a polynomial
#a1 contains an exponent value
#v0 will contain where the exponent would fit
#v1 will contain a boolean of if the exponent can be added(1 if yes, 0 if no, -1 if invalid)
	bltz	$a1, invalidExponent					# Exponent is invalid
	move	$t0, $0							# Start our position counter at 0 terms in
	lw	$a0, 0($a0)						# Point to the first term
	beqz	$a0, notExists						# We couldn't get the next term because there was none
	checkLoop:
		lw	$t1, 4($a0)					# Get the exponent of the current term we are examining
		beq	$t1, $a1, exists				# The coefficient was found
		blt	$t1, $a1, notExists				# All greater terms were not the exponent
		addi	$t0, $t0, 1					# We read another term without finding a spot
		lw	$t1, 8($a0)					# Get the pointer to the next, and check that it isn't NULL
		beqz	$t1, notExists					# This means that our term is the smallest and should be added at the end
		lw	$a0, 8($a0)					# Replace the term we are looking at with the next term
		j	checkLoop					# Keep going until we find a way out
	exists:
		move	$v0, $t0					# Just because, we will return how many terms deep it was found
		move	$v1, $0						# The term already exists
		jr	$ra
	notExists:
		move	$v0, $t0					# We will return how many terms deep it was found
		addi	$v1, $0 , 1					# The term didn't exist, and this is the first spot where a smaller term was found
		jr	$ra
	invalidExponent:
		addi	$v0, $0 , -1					# Error
		addi	$v0, $0 , -1					# Error
		jr	$ra

add_term: # Add a term to a polynomial; ALL INPUT MUST BE VALID BEFORE CALLING
#a0 contains the pointer p
#a1 contains the address of the term we are adding
#a2 contains the position where we want to add the element(0-index)
	move	$t0, $a0						# Just in case of empty case
	lw	$a0, 0($a0)						# Go to the head polynomial
	beqz	$a0, addEmpty						# We couldn't get the next term because there was none; also don't mind the branch label lol
	beqz	$a2, addFirst						# This is a special case where we want to replace p; so we'll "swap" them
	addi	$a2, $a2, -1						# Subtract 1 sice we want to change the pointer before that position, 0 is excluded from above
	addOneLoop:
		beqz	$a2, positionFound				# We have reached the index we want to add the element
		addi	$a2, $a2, -1					# Move forward/decrese index to reach our position
		lw	$a0, 8($a0)					# Replace the position with the one next in the polynomial
		beqz	$a0, added					# We couldn't get the next term because there was none; also don't mind the branch label lol
		j	addOneLoop					# The input will be valid, so we keep going until our index is 0
	addFirst:
		lw	$t0, 0($a0)					# Store the coefficient of the p
		lw	$t1, 0($a1)					# Get the coefficient of the term we want to add
		sw	$t1, 0($a0)					# Set the coefficient of p to the new term
		sw	$t0, 0($a1)					# Set the coefficient of the new term to p
		lw	$t0, 4($a0)					# Store the coefficient of the p
		lw	$t1, 4($a1)					# Get the exponent of the term we want to add
		sw	$t1, 4($a0)					# Set the exponent of p to the new term
		sw	$t0, 4($a1)					# Set the exponent of the new term to p
		lw	$t0, 8($a0)					# Get the address for the next term
		sw	$t0, 8($a1)					# Move into the new address(which was the old first term)
		sw	$a1, 8($a0)					# The addresss for the new term is the address for the old first term
		j	added						# Could have just changed the pointer at p...
	positionFound:
		lw	$t0, 8($a0)					# Get the next address and save it
		sw	$a1, 8($a0)					# Stick our term into the next position instead of whatever was next
		sw	$t0, 8($a1)					# Point our inserted term to the term it replaced
		j	added
	addEmpty:
		sw	$a1, 0($t0)					# We point the header to the term now
	added:
		jr	$ra

update_term: # Update a term to a polynomial; ALL INPUT MUST BE VALID BEFORE CALLING
#a0 contains the pointer p
#a1 contains the coefficient to change into
#a2 contains the position where we want to update the element(0-index)
	lw	$a0, 0($a0)						# Go to the head polynomial
	beqz	$a0, updated						# We couldn't get the next term because there was none; also don't mind the branch label lol
	updateOneLoop:
		beqz	$a2, updateElement				# We have reached the index we want to add the element
		addi	$a2, $a2, -1					# Move forward/decrese index to reach our position
		lw	$a0, 8($a0)					# Replace the position with the one next in the polynomial
		beqz	$a0, updated					# We couldn't get the next term because there was none; also don't mind the branch label lol	
		j	updateOneLoop					# The input will be valid, so we keep going until our index is 0
	updateElement:
		sw	$a1, 0($a0)					# Change coefficient of the term into the updated coefficient
	updated:
		jr	$ra

add_update_N_terms: # This is the lazy way to add a bunch of terms :)
#a0 contains the pointer to the resulting polynomial, should be blank
#a1 contains the terms array ending in a 0,-1
#v0 will contains a 1 if we successfully added it; 0 if we fail
	addi	$sp, $sp, -16						# Allocate space on the stack to store $ra and saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Store $s0 on stack(will save $a0)
	sw	$s1, 8($sp)						# Store $s1 on stack(will save $a1)
	sw	$s2, 12($sp)						# Store $s2 on stack(will save random stuff here and there)
	move	$s0, $a0						# I did say I would do it
	move	$s1, $a1						# I did it
	addUpdateLoop:
		lw	$t0, 0($s1)					# Get the coefficient term
		bnez	$t0, continue					# If we don't get a 0, this can't be the 0,-1
		lw	$t1, 4($s1)					# Get the exponent term
		addi	$t2, $0 , -1					# We want to check for -1
		beq	$t1, $t2, checkPolynomial			# If we get a -1, we know that we are at the end
		continue:
			move	$a0, $s0				# $s0 is locked to be the pointer r
			lw	$a1, 4($s1)				# $s2 is the current position we are looking at
			jal	check_exponent				# See if we can add the exponent, or do we have to update
			bltz	$v1, goNext				# If we got a bad exponent, just start the loop over
			bgtz	$v1, addOne				# If we could add it, we should add it :)
			move	$a0, $s0				# We want to update a term in the polynomial r
			addi	$a1, $v0, 1				# Change the 0-index into 1-index
			move	$s2, $a1				# Save it for later use
			jal	get_Nth_term				# Get the address of the term to update
			lw	$t0, 0($s1)				# Get the coefficient of the term we want to add/update with
			add	$t0, $t0, $v1				# Add that with the coefficient of the term that was there before
			beqz	$t0, cancels				# If we got a 0, we should just delete the element
			sw	$t0, 0($s1)				# Update the coefficient, so our update function changes it appropiately
			move	$a0, $s0				# Add to the polynomial r
			move	$a1, $s1				# Add the terms array
			addi	$a2, $0 , 1				# But only the first term
			jal	update_N_terms_in_polynomial		# Update the term
			j	goNext
			cancels:
				move	$a0, $s0			# Removing the term from polynomial r
				move	$a1, $s2			# Remove the term with the 1-index we saved earlier
				jal	remove_Nth_term			# Remove the term that cancels out
				j	goNext
			addOne:
				move	$a0, $s0			# Add to the polynomial r
				move	$a1, $s1			# Add the terms array
				addi	$a2, $0 , 1			# But only the first term
				jal	add_N_terms_to_polynomial	# Add the term
			goNext:
				addi	$s1, $s1, 8			# Check the next terms in the array
				j	addUpdateLoop
	checkPolynomial:
		move	$a0, $s0					# Load r to clean
		jal	clean_polynomial				# In case of weird straggling pointers
		lw	$t0, 0($s0)					# Load the first term of the polynomial
		lw	$t1, 0($t0)					# Get the coefficient
		lw	$t2, 4($t0)					# Get the exponent
		beqz	$t1, returnZero					# There are no terms currently or invalid terms
		bltz	$t2, returnZero					# The exponent was invalid, so there must be no terms
		addi	$v0, $0 , 1					# Since there is at least 1 term, we return 1
		j	addedUpdated
		returnZero:
			move	$v0, $0					# There are no terms for whatever reason, so we return 0
	addedUpdated:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		addi	$sp, $sp, 16					# Deallocate stack space
		jr $ra

clean_polynomial: #Catch cases where polynomial has a pointer to nowhere, we will remove that pointer
#a0 contains the pointer to the polynomial
	lw	$a0, 0($a0)						# Check the first term
	lw	$a0, 8($a0)						# Get the pointer
	beqz	$a0, escape						# If we point to nothing, it should be fine
	cleanLoop:
		move	$t0, $a0					# Save the previous term
		lw	$a0, 8($a0)					# Go to the next address
		beqz	$a0, escape					# If we pointed to a null, we are done
		lw	$t1, 0($a0)					# Get coefficient
		lw	$t2, 4($a0)					# Get exponent
		lw	$t3, 8($a0)					# Get the next address
		bnez	$t1, cleanLoop					# If it isn't 0,0,0 we just keep looping
		bnez	$t2, cleanLoop					# So yeah
		bnez	$t3, cleanLoop					# Although this might be redundant
		sw	$0 , 8($t0)					# Change the pointer of the previous to go to NULL
	escape:
		jr	$ra
