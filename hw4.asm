############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:

str_len: # Get the length of the string without changing main memory (or the arguments in this implementation)
#a0 contains the base address of a string that will end with a null-terminator
#v0 will contain the number of characters in the string without the null-terminator
	move	$v0, $0							# Initialize the characters to 0
	getLenLoop:
		add	$t0, $a0, $v0					# Get the address of the character
		lb	$t0, 0($t0)					# Get the character at the address
		addi	$v0, $v0, 1					# We have successfully read a character
		bne	$t0, $0 , getLenLoop				# If it wasn't the null-terminator, we should keep reading
	addi	$v0, $v0, -1						# Was too lazy to re-write loop and this looks clean enough
	jr $ra

str_equals: # Compares the two strings without changing memory (arguments are not changed)
#a0 contains the base address of the first string
#a1 contains the base address of the second string
#v0 will contain the boolean of the equality(1 if equals, 0 otherwise)
	move	$t2, $a0						# I just kinda feel like saving arguments idk
	move	$t3, $a1						# what that comment said^
	strEquLoop:
		lb	$t0, 0($t2)					# Get the character of the first string
		lb	$t1, 0($t3)					# Get the character of the second string
		addi	$t2, $t2, 1					# Read the next character in the first string
		addi	$t3, $t3, 1					# Read the next character in the second string
		bne	$t0, $t1, strNotEqual				# If the characters weren't equal, we should stop looping
		beq	$t0, $0 , strEqual				# We know the characters are equal, and if they were both null, we finished reading both
		j	strEquLoop					# We didn't finish reading, and they are still equal so far
	strNotEqual:
		addi	$v0, $0 , 0					# The string wasn't equal so we should return 0
		jr	$ra
	strEqual:
		addi	$v0, $0 , 1					# The string was equal so we should return 1
	jr	$ra

str_cpy: # Copy the string to the destination while only modifying the destination string (arguments untouched)
#a0 contains the base address of the null-terminated string we want to copy
#a1 contains the base address of the destination string
#v0 will contain the number of characters we copied
	move	$v0, $0							# Initialize the characters to 0
	copyStrLoop:
		add	$t0, $a0, $v0					# Get the address of the character we want to read from
		add	$t1, $a1, $v0					# Get the address of the character we want to write to
		lb	$t0, 0($t0)					# Get the character at the address to read from
		sb	$t0, 0($t1)					# Store that character at the address to write to
		addi	$v0, $v0, 1					# We have successfully copied a character
		bne	$t0, $0 , copyStrLoop				# If it wasn't the null-terminator, we should keep copying
	addi	$v0, $v0, -1						# Was too lazy to re-write loop and this looks clean enough
	jr $ra

create_person: # Allocates space in Network for a new person and lets Network know that we've added a new node if possible (arguments not touched)
#a0 contains the base address of Network
#v0 will contain the address of the new node in Network or -1
	addi	$v0, $0 , -1						# Assume we cannot create a person
	lw	$t1, 16($a0)						# Current number of nodes is fixed to be here
	bltz	$t1, created						# Negative amount of edges and we tried to create an edge
	lw	$t2, 0($a0)						# Get the total number of nodes allowed(fixed to be here)
	bge	$t1, $t2, created					# If we have too many nodes(illegal) or are full, return -1
	lw	$t3, 8($a0)						# Size of each node(also fixed position)
	mult	$t1, $t3						# We want to find the offset by taking number of nodes times the size of each node
	mflo	$t0							# They are both capped at 4 bytes, so there shouldn't be overflow
	addi	$t0, $t0, 36						# Add 36 since the first node is located at this offset
	addi	$t1, $t1, 1						# Since we are creating a person, we should make space
	sw	$t1, 16($a0)						# We will allocate space for another node since we are not maxed
	add	$v0, $a0, $t0						# Add the offset to the base address of memory to fix output
	created:
		jr $ra

is_person_exists: # Determine if a person exists in a Network without changing main memory (I won't change the arguments either)
#a0 contains the base address of Network
#a1 contains the base address of a person node
#v0 will contain the boolean of if the person exist(1 if exist, 0 otherwise)
	addi	$sp, $sp, -4						# Allocate space on the stack to store $ra
	sw	$ra, 0($sp)						# Saves $ra on stack
	addi	$v0, $0 , 1						# Assumes person exists
	jal	is_valid_node						# Check if the person node is a valid person
	beqz	$v0, personNotExist					# The node is not a person node
	sub	$t0, $a1, $a0						# Get the offset from the original Network address
	addi	$t0, $t0, -36						# Get the offset from the first node in the Network
	bltz	$t0, personNotExist					# If the offset is negative, the person node isn't even within the nodes00
	lw	$t1, 8($a0)						# Get the size of each node
	div	$t0, $t1						# Get the index of the node in the nodes array
	mflo	$t0							# Get the quotient as the index (0-index)
	lw	$t1, 16($a0)						# Get the current number of node ("1-index")
	blt	$t0, $t1, personExists					# See if we fit within the current nodes that exist
	personNotExist:
		move	$v0, $0						# Person does not exist
	personExists:
		lw	$ra, 0($sp)					# Restores $ra from stack
		addi	$sp, $sp, 4					# Deallocate stack space
		jr $ra

is_person_name_exists: # Verify if a person with a given name exists within our Network without changing main memory(BUT ARGUMENTS WILL CHANGE)
#a0 contains the base address of Network
#a1 contains the base address of a name(stored as a null-terminated string)
#v0 will contain a boolean value of if a person with that name could be found(1 if yes, 0 otherwise)
#v1 will contain a reference to the person if it exists, otherwise it doesn't matter
	addi	$sp, $sp, -16						# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack(Store the base address for Network)
	sw	$s1, 8($sp)						# Saves $s1 on stack(Store the base address for the name)
	sw	$s2, 12($sp)						# Saves $s2 on stack(Store the index of the Person we are checking)
	move	$s0, $a0						# Save the base address for Network
	move	$s1, $a1						# Save the base address for the name
	lw	$s2, 16($a0)						# Get the number of nodes our network has(using a 1-index)
	checkName: # We can check it in reverse, since the properties must be unique otherwise, I would create a variable to store the end index
		blez	$s2, breakCheckLoop				# If there are zero nodes left, we should break the loop
		addi	$s2, $s2, -1					# Fix the index to be 0-index, and also fixes it for the loop
		move	$a0, $s0					# Load in Network for every time we loop
		move	$a1, $s2					# Load the current index for every loop
		jal	get_address_person				# Get the address of the last node's name
		move	$a0, $v0					# Load in first name for str_equals
		move	$a1, $s1					# Load the name we want to check for
		jal	str_equals					# Compares the two names
		bnez	$v0, nameFound					# We know it's not not equal, so we found a match
		j	checkName					# Unconditionally loop to the start
	breakCheckLoop:
		move	$v0, $0						# We couldn't find a match so v0 is 0
		j	nameChecked					# We couldn't find a match so v1 is whatever
	nameFound:
		addi	$v0, $0 , 1					# We found a match
		move	$v1, $a0					# Since str_equals doesn't change the arguments, a0 is still the address of the Person
	nameChecked:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		addi	$sp, $sp, 16					# Deallocate stack space
		jr	$ra

add_person_property: # Add a person property if and only if we are adding the name of a new person that will not overflow but argumenst are changed
#a0 contains the base address for Network
#a1 contains the base address for a Person node
#a2 contains a null-terminated string for the name of the property added
#a3 contains a null-terminated string for the value of the property added
#v0 will contain values to let us know what happened, listed below
#   1 if successful, 0 if property added is not NAME, -1 if person does not exist, -2 if the property value is too large, -3 if the name being added is not unique
	addi	$sp, $sp, -16						# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack(Store the base address for Network)
	sw	$s1, 8($sp)						# Saves $s1 on stack(Store the base address for the Person)
	sw	$s2, 12($sp)						# Saves $s2 on stack(Store the null-terminated string for the property value)
	move	$s0, $a0						# Save Network
	move	$s1, $a1						# Save Person
	move	$s2, $a3						# Save property value
	#lb $t0, 0($a2) li $t1, 'N' bne $t0, $t1, notNamePropertylb $t0, 1($a2) li $t1, 'A' bne $t0, $t1, notNameProperty lb $t0, 2($a2) li $t1, 'M' bne $t0, $t1, notNameProperty
	#lb $t0, 3($a2) li $t1, 'E' bne $t0, $t1, notNameProperty lb $t0, 4($a2) li $t1, 0 bne $t0, $t1, notNameProperty #should have used the name_prop in Network...
	move	$a0, $a2						# Load addresss for property name
	addi	$a1, $s0, 24						# Load the address of the Name property from Network
	jal	str_equals						# Compare the two strings
	beqz	$v0, notNameProperty					# If the result is a 0, the two strings weren't equal
	move	$a0, $s0						# Load Network
	move	$a1, $s1						# Load Person
	jal	is_person_exists					# See if the person was created; will catch invalid addresses
	beqz	$v0, personDoesNotExist					# If it was 1(aka exist), we would not be equal to zero
	move	$a0, $s2						# Load the property value
	jal	str_len							# Get the length of the string(Without the null terminator)
	lw	$t0, 8($s0)						# Get the size of each node we are permitting(Note: the last chaaracter is for the null terminator)
	bge	$v0, $t0, propertyValueTooLarge				# If the size isn't strictly less than the size of the node, the value is too large
	move	$a0, $s0						# Load Network
	move	$a1, $s2						# Load the name we want to check
	jal	is_person_name_exists					# See if the name existed before
	bnez	$v0, personNameExisted					# If the person name was found(return value of 1), we should return an error
	move	$a0, $s2						# Load the property value
	move	$a1, $s1						# Load the address of the node
	jal	str_cpy							# Copy the property value into the node
	addi	$v0, $0 , 1						# We successfully added the property
	j	personPropertyAdded					# We got the proper return values
	notNameProperty:
		move	$v0, $0						# The property wasn't 'NAME', so we should return 0
		j	personPropertyAdded				# We got the proper return values
	personDoesNotExist:
		addi	$v0, $0 , -1					# The person did not exist so we should return -1
		j	personPropertyAdded				# We got the proper return values
	propertyValueTooLarge:
		addi	$v0, $0 , -2					# The value was too large, so we should return -2
		j	personPropertyAdded				# We got the proper return values
	personNameExisted:
		addi	$v0, $0 , -3					# The person's name already existed, so we should return -3
	personPropertyAdded:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		addi	$sp, $sp, 16					# Deallocate stack space
		jr	$ra

get_person: # Get a person's address in Network if the person is found (COPIED FROM is_person_name_exists, ARGUMENTS STILL CHANGE)
#a0 contains the base address of Network
#a1 contains the base address of a name(stored as a null-terminated string)
#v0 will contain the address of the person if found and 0 otherwise
	addi	$sp, $sp, -16						# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack(Store the base address for Network)
	sw	$s1, 8($sp)						# Saves $s1 on stack(Store the base address for the name)
	sw	$s2, 12($sp)						# Saves $s2 on stack(Store the index of the Person we are checking)
	move	$s0, $a0						# Save the base address for Network
	move	$s1, $a1						# Save the base address for the name
	lw	$s2, 16($a0)						# Get the number of nodes our network has(using a 1-index)
	getName: # We can check it in reverse, since the properties must be unique otherwise, I would create a variable to store the end index
		blez	$s2, breakGetLoop				# If there are zero nodes left, we should break the loop
		addi	$s2, $s2, -1					# Fix the index to be 0-index, and also fixes it for the loop
		move	$a0, $s0					# Load in Network for every time we loop
		move	$a1, $s2					# Load the current index for every loop
		jal	get_address_person				# Get the address of the last node's name
		move	$a0, $v0					# Load in first name for str_equals
		move	$a1, $s1					# Load the name we want to check for
		jal	str_equals					# Compares the two names
		bnez	$v0, nameGotten					# We know it's not not equal, so we found a match
		j	getName						# Unconditionally loop to the start
	breakGetLoop:
		move	$v0, $0						# We couldn't find a match so v0 is 0
		j	personGotten					# We couldn't find a match so v0 is not address
	nameGotten:
		move	$v0, $a0					# Since str_equals doesn't change the arguments, a0 is still the address of the Person
	personGotten:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		addi	$sp, $sp, 16					# Deallocate stack space
		jr	$ra

is_relation_exists: # Checks to see if there exists a relationship between two people without changing main memory, but probably changes arguments
#a0 contains the base address of Network
#a1 contains the base address of Person 1
#a2 contains the base address of Person 2
#v0 will contain a boolean of if there is a relationship between P1 and P2(1 if there is; 0 otherwise)
	addi	$sp, $sp, -24						# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack(Store the base address for Network)
	sw	$s1, 8($sp)						# Saves $s1 on stack(Store the base address for Person 1)
	sw	$s2, 12($sp)						# Saves $s2 on stack(Store the base address for Person 2)
	sw	$s3, 16($sp)						# Saves $s3 on stack(Store the base address of the current edge)
	sw	$s4, 20($sp)						# Saves $s4 on stack(Store the loop index)
	move	$s0, $a0						# Save Network
	move	$s1, $a1						# Save Person 1
	move	$s2, $a2						# Save Person 2
	jal	is_person_exists					# Arguments line up nicely for checking Person 1
	beqz	$v0, edgesChecked					# If the node does not exist, there will be no need to check edges; removes invalid addresses
	move	$a0, $s0						# Load Network
	move	$a1, $s3						# Check is Person 2 exists
	beqz	$v0, edgesChecked					# If the node does not exist, there will be no need to check edge since there can be none with it
	lw	$t0, 0($s0)						# Load the max number of nodes allowed
	lw	$t1, 8($s0)						# Load the size of each node
	mult	$t0, $t1						# Multiply the two to get the space allocated for nodes
	mflo	$t0							# Get that result into register $t0
	add	$t0, $s0, $t0						# Add that to Network to 'skip' the nodes section
	addi	$a0, $t0, 36						# We also needed to skip the 36 fixed bits
	jal	get_next_multiple					# Since nodes are not always multiple of fours, and edges are word-aligned, the address should be a multiple of 4
	move	$s3, $v0						# Store that for the current edge
	lw	$s4, 20($s0)						# Get the number of edges in Network
	checkEdges:
		blez	$s4, edgesChecked				# If we have no more edges, we have shown that the relationship doesn't exist
		lw	$t0, 0($s3)					# Load the first four bytes of the edge
		lw	$t1, 4($s3)					# Load the second four bytes of the edge
		beq	$t0, $s1, matchOneOne				# Compare the first with Person 1
		beq	$t0, $s2, matchOneTwo				# Compare the first with Person 2
		j	nextEdge					# Neither of Person 1/2 matched with the first part of the edge
		matchOneOne:
			beq	$t1, $s2, relationshipFound		# We found a match
			j	nextEdge				# Person 1 ended up matching but it wasn't a relationship with Person 2
		matchOneTwo:
			beq	$t1, $s1, relationshipFound		# We found a match
			j	nextEdge				# Person 2 ended up matching but it wasn't a relationship with Person 1
		nextEdge:
			addi	$s3, $s3, 12				# Check the next edge, the size of each edge is always 12, so we don't need to load from Network/s0
			addi	$s4, $s4, -1				# Decrease the number of edges to check
			j	checkEdges				# Keep checking until we break the cycle
	relationshipFound:
		addi	$v0, $0 , 1					# We found a relationship
		j	relationshipChecked				# Note: Person 1 and 2 will never the same person if the edge was added
	edgesChecked:
		move	$v0, $0						# We checked all the edges and there were no such relationships
	relationshipChecked:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		lw	$s4, 20($sp)					# Restores $s4 from stack
		addi	$sp, $sp, 24					# Deallocate stack space
		jr	$ra

add_relation: # Add a new relationship between two people
#a0 contains the base address of Network
#a1 contains the base address of Person 1
#a2 contains the base address of Person 2
#v0 will contain values letting us know how adding the relation went as listed below:
#   1 if we added it sucessfully, 0 if either person did not exist, -1 if Network is full of edges, -2 if relationship exists, -3 if Person 1 and 2 are the same
	addi	$sp, $sp, -16						# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack(Store the base address for Network)
	sw	$s1, 8($sp)						# Saves $s1 on stack(Store the base address for Person 1)
	sw	$s2, 12($sp)						# Saves $s2 on stack(Store the base address for Person 2)
	move	$s0, $a0						# Save Network
	move	$s1, $a1						# Save Person 1
	move	$s2, $a2						# Save Person 2
	jal	is_person_exists					# The arguments are already loaded to check if Person 1 exists; removes invalid addresses
	beqz	$v0, personNotFound					# Person 1 did not exist
	move	$a0, $s0						# Load Network
	move	$a1, $s2						# Load Person 2
	jal	is_person_exists					# See if Person 2 exists // could make a helper function to optimize checking two people
	beqz	$v0, personNotFound					# Person 2 did not exist
	lw	$t0, 20($s0)						# Get the current number of edges
	bltz	$t0, tooManyEdges					# We don't want a case of negative edges
	lw	$t1, 4($s0)						# Get the max number of edges
	bge	$t0, $t1, tooManyEdges					# Network is at capacity and we can't add anything
	move	$a0, $s0						# Load Network
	move	$a1, $s1						# Load Person 1
	move	$a2, $s2						# Load Person 2
	jal	is_relation_exists					# See if there is an existing relationship
	bnez	$v0, pastRelationFound					# We can't add a relationship that exists already	
	beq	$s1, $s2, cantDoThisLol					# If they are the same person, they have the same base address; same name can't be added to the Network
	lw	$t0, 0($s0)						# Load the max number of nodes allowed
	lw	$t1, 8($s0)						# Load the size of each node
	mult	$t0, $t1						# Multiply the two to get the space allocated for nodes
	mflo	$t0							# Get that result into register $t0
	add	$t0, $s0, $t0						# Add that to Network to 'skip' the nodes section
	addi	$a0, $t0, 36						# We also needed to skip the 36 fixed bits
	jal	get_next_multiple					# Since nodes are not always multiple of fours, and edges are word-aligned, the address should be a multiple of 4
	move	$t0, $v0						# Store that for the current address
	lw	$t1, 20($s0)						# Load the current number of edges
	lw	$t2, 12($s0)						# Load the size of each edge
	mult	$t1, $t2						# Multiply the two to get the space allocated for the current edges
	mflo	$t1							# Get that result into register $t1
	add	$t0, $t0, $t1						# Add the address of the first edge by the space allocated for current edges to get first free node
	sw	$s1, 0($t0)						# Store Person 1
	sw	$s2, 4($t0)						# Store Person 2
	sw	$0 , 8($t0)						# Set the friend property to be 0 initially
	lw	$t0, 20($s0)						# Load number of edges in Network
	addi	$t0, $t0, 1						# Increment it by 1 since we just added an edge
	sw	$t0, 20($s0)						# Store it back into Network
	addi	$v0, $0 , 1						# We sucessfully added a relation, so return 1
	j	relationAdded						# We added the new relationship successfully
	personNotFound:
		move	$v0, $0						# We could not find the people in question, so return 0
		j	relationAdded
	tooManyEdges:
		addi	$v0, $0	, -1					# There were an improper amount of edges, so return -1
		j	relationAdded
	pastRelationFound:
		addi	$v0, $0	, -2					# There was an existing relationship between the two, so return -2
		j	relationAdded
	cantDoThisLol:
		addi	$v0, $0	, -3					# THEY TRIED TO ADD THEMSELVES LMFAO RETURN -3
	relationAdded:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		addi	$sp, $sp, 16					# Deallocate stack space
		jr	$ra

add_relation_property: # Changes an existing friendship value to a set value
#a0 contains the base address of Network
#a1 contains the base address of Person 1
#a2 contains the base address of Person 2
#a3 contains the base address of a null-terminated string for a property name
#a4 contains the base address of a null-terminated string for a property value(not actually a4 but it's ok)
#v0 will contain values telling us how our operation went as listed below:
#   1 if we changed it successfully, 0 if there is no such relation, -1 if the property name was not FRIEND, -2 if the value of property is negative
	lw	$t0, 0($sp)						# Load the address for property value
	addi	$sp, $sp, -28						# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack(will save Network)
	sw	$s1, 8($sp)						# Saves $s1 on stack(will save Person 1)
	sw	$s2, 12($sp)						# Saves $s2 on stack(will save Person 2)
	sw	$s3, 16($sp)						# Saves $s3 on stack(will save property name)
	sw	$s4, 20($sp)						# Saves $s4 on stack(will save property value)
	sw	$s5, 24($sp)						# Saves $s5 on stack(will save the address of an edge)
	move	$s0, $a0						# Save Network
	move	$s1, $a1						# Save Person 1
	move	$s2, $a2						# Save Person 2
	move	$s3, $a3						# Save property name
	move	$s4, $t0						# We stored the property value in t0 before
	jal	get_address_relation					# The first three arguments already fit for this; will remove invalid addresses
	beqz	$v0, noRelationFound					# We can't change the property if no relation exists
	move	$s5, $v0						# Since we confirmed a relation exists, we want to save the address
	addi	$a0, $s0, 29						# Load the address for the FRIEND property
	move	$a1, $s3						# Load the address for the property name
	jal	str_equals						# Compare the two strings
	beqz	$v0, notFriend						# We weren't going to change the FRIEND value
	bltz	$s4, negativeValue					# We want the property value to be greater than or equal to 0
	sw	$s4, 8($s5)						# Offset of 8 is where the value for the friendship is stored
	addi	$v0, $0 , 1						# We successfully added the property
	j	propertyAdded
	noRelationFound:
		move	$v0, $0						# Therefore, we return 0
		j	propertyAdded
	notFriend:
		addi	$v0, $0 , -1					# Therefore, we return -1
		j	propertyAdded
	negativeValue:
		addi	$v0, $0 , -2					# Therefore, we return -2
	propertyAdded:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		lw	$s4, 20($sp)					# Restores $s4 from stack
		lw	$s5, 24($sp)					# Restores $s5 from stack
		addi	$sp, $sp, 28					# Deallocate stack space
		jr	$ra

is_friend_of_friend: # Determine if two people have a mutual friend without actually being friends
#a0 contains the base address of Network
#a1 contains the base address of Person 1's name in a null-terminated string
#a2 contains the base address of Person 2's name in a null-terminated string
#v0 will contain a psuedo-boolean for whether the two people are friends of friends(1 if they are, 0 if they aren't, or -1 if one of them don't exist)
	addi	$sp, $sp, -20						# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack(Store the base address for Network)
	sw	$s1, 8($sp)						# Saves $s1 on stack(Store the base address for Person 1)
	sw	$s2, 12($sp)						# Saves $s2 on stack(Store the base address for Person 2)
	sw	$s3, 16($sp)						# Saves $s3 on stack(Store the loop index for checking the nodes)
	move	$s0, $a0						# Save Network
	move	$s1, $a1						# Save Person 1's name for now
	move	$s2, $a2						# Save Person 2's name for now
	jal	is_person_name_exists					# Check if Person 1 exists
	beqz	$v0, doesNotExist					# Person 1 did not exist
	move	$s1, $v1						# On the assumption that Person 1 does exist, the address is in v1
	move	$a0, $s0						# Load Network
	move	$a1, $s2						# Load Person 2
	jal	is_person_name_exists					# Check if Person 2 exists
	beqz	$v0, doesNotExist					# Person 2 did not exist
	move	$s2, $v1						# On the assumption that Person 2 does exist, the address is in v1
	beq	$s1, $s2, notFriendOfFriend				# If they are the same person, they cannot be friends of friends
	move	$a0, $s0						# Load Network
	move	$a1, $s1						# Load Person 1
	move	$a2, $s2						# Load Person 2
	jal	is_friend						# See if they are friends(relation of greater than 0)
	bnez	$v0, notFriendOfFriend					# They are friends, and cannot be friend of friends
	lw	$s3, 16($s0)						# Load the current number of node
	friendOfFriendLoop:
		blez	$s3, notFriendOfFriend				# We checked all possible relations, and there was no way to match
		addi	$s3, $s3, -1					# We subtract by 1 to fix the indexing, and to decrement for the next loop
		move	$a0, $s0					# Load Network
		move	$a1, $s3					# Load the 0-index for the person to check
		jal	get_address_person				# Get the address of the person
		move	$a2, $v0					# Load the address of the person here
		move	$a0, $s0					# Load Network
		move	$a1, $s1					# Load Person 1
		jal	is_friend					# See if Person 1 is friends with the potential middleman
		beqz	$v0, friendOfFriendLoop				# If Person 1 isn't a friend, then it can't be a friend of friend middleman
		move	$a2, $v0					# We want to see if Person 2 is a friend as well
		move	$a0, $s0					# Load Network
		move	$a1, $s2					# Load Person 2
		jal	is_friend					# See if Person 2 is friends with the potential middleman
		beqz	$v0, friendOfFriendLoop				# If Person 2 isn't a friend, the friend of friend chain stops, so we should move on
	isFriendOfFriend:
		addi	$v0, $0 , 1					# We found a middle man who is friends with both people, so we should return 1
		j	friendOfFriendChecked				# Note that we already showed that Person 1 and 2 weren't directly friends
	doesNotExist:
		addi	$v0, $0 , -1					# Therefore, we should return -1
		j	friendOfFriendChecked
	notFriendOfFriend:
		move	$v0, $0						# Therefore, we should return 0
	friendOfFriendChecked:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		addi	$sp, $sp, 20					# Deallocate stack space
		jr	$ra

############################        HELPER FUNCTION        ############################
############################        HELPER FUNCTION        ############################
############################        HELPER FUNCTION        ############################

get_address_person: # Given a valid index in Network, we wil find the corresponding address(NO CHANGED ARGUMENT)
#a0 contains the base address to Network
#a1 contains the 0-index for the person we want to find
#v0 will contain the address of the Person at index a1
	lw	$t0, 8($a0)						# Load the size of each node
	mult	$t0, $a1						# Multiply by the index of our Person
	mflo	$t0							# Get the resulting offset
	addi	$t0, $t0, 36						# We will also add 36 to offset the initial variables
	add	$v0, $a0, $t0						# Find the address of the Person from the Network address
	jr	$ra

get_address_relation: # Given the address of two people, return the address of the responding relation(built off is_relation_exists, could have added extra outputs)<>
#a0 contains the base address of Network
#a1 contains the base address of Person 1
#a2 contains the base address of Person 2
#v0 will contain the address of the relation or 0 if none was found
	addi	$sp, $sp, -24						# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack(Store the base address for Network)
	sw	$s1, 8($sp)						# Saves $s1 on stack(Store the base address for Person 1)
	sw	$s2, 12($sp)						# Saves $s2 on stack(Store the base address for Person 2)
	sw	$s3, 16($sp)						# Saves $s3 on stack(Store the base address of the current edge)
	sw	$s4, 20($sp)						# Saves $s4 on stack(Store the loop index)
	move	$s0, $a0						# Save Network
	move	$s1, $a1						# Save Person 1
	move	$s2, $a2						# Save Person 2
	jal	is_person_exists					# Arguments line up nicely for checking Person 1
	beqz	$v0, edgesCheckedII					# If the node does not exist, there will be no need to check edges; removes invalid addresses
	move	$a0, $s0						# Load Network
	move	$a1, $s3						# Check is Person 2 exists
	beqz	$v0, edgesCheckedII					# If the node does not exist, there will be no need to check edge since there can be none with it
	lw	$t0, 0($s0)						# Load the max number of nodes allowed
	lw	$t1, 8($s0)						# Load the size of each node
	mult	$t0, $t1						# Multiply the two to get the space allocated for nodes
	mflo	$t0							# Get that result into register $t0
	add	$t0, $s0, $t0						# Add that to Network to 'skip' the nodes section
	addi	$a0, $t0, 36						# We also needed to skip the 36 fixed bits
	jal	get_next_multiple					# Since nodes are not always multiple of fours, and edges are word-aligned, the address should be a multiple of 4
	move	$s3, $v0						# Store that for the current edge
	lw	$s4, 20($s0)						# Get the number of edges in Network
	checkEdgesII:
		blez	$s4, edgesCheckedII				# If we have no more edges, we have shown that the relationship doesn't exist
		lw	$t0, 0($s3)					# Load the first four bytes of the edge
		lw	$t1, 4($s3)					# Load the second four bytes of the edge
		beq	$t0, $s1, matchOneOneII				# Compare the first with Person 1
		beq	$t0, $s2, matchOneTwoII				# Compare the first with Person 2
		j	nextEdgeII					# Neither of Person 1/2 matched with the first part of the edge
		matchOneOneII:
			beq	$t1, $s2, relationshipFoundII		# We found a match
			j	nextEdgeII				# Person 1 ended up matching but it wasn't a relationship with Person 2
		matchOneTwoII:
			beq	$t1, $s1, relationshipFoundII		# We found a match
			j	nextEdgeII				# Person 2 ended up matching but it wasn't a relationship with Person 1
		nextEdgeII:
			addi	$s3, $s3, 12				# Check the next edge, the size of each edge is always 12, so we don't need to load from Network/s0
			addi	$s4, $s4, -1				# Decrease the number of edges to check
			j	checkEdgesII				# Keep checking until we break the cycle
	relationshipFoundII:
		move	$v0, $s3					# We found a relationship
		j	relationshipCheckedII				# Note: Person 1 and 2 will never the same person if the edge was added
	edgesCheckedII:
		move	$v0, $0						# We checked all the edges and there were no such relationships
	relationshipCheckedII:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		lw	$s4, 20($sp)					# Restores $s4 from stack
		addi	$sp, $sp, 24					# Deallocate stack space
		jr	$ra

is_friend: # Check if two people are friends(meaning there exists a relationship with value greater than 0) (built off is_relation_exists, could have added extra outputs)<>
#a0 contains the base address for Network
#a1 contains the base address for Person 1
#a2 contains the base address for Person 2
#v0 will contain the base address of Person 2 or 0 if they are not friends
	addi	$sp, $sp, -24						# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack(Store the base address for Network)
	sw	$s1, 8($sp)						# Saves $s1 on stack(Store the base address for Person 1)
	sw	$s2, 12($sp)						# Saves $s2 on stack(Store the base address for Person 2)
	sw	$s3, 16($sp)						# Saves $s3 on stack(Store the base address of the current edge)
	sw	$s4, 20($sp)						# Saves $s4 on stack(Store the loop index)
	move	$s0, $a0						# Save Network
	move	$s1, $a1						# Save Person 1
	move	$s2, $a2						# Save Person 2
	jal	is_person_exists					# Arguments line up nicely for checking Person 1
	beqz	$v0, edgesCheckedIII					# If the node does not exist, there will be no need to check edges; removes invalid addresses
	move	$a0, $s0						# Load Network
	move	$a1, $s3						# Check is Person 2 exists
	beqz	$v0, edgesCheckedIII					# If the node does not exist, there will be no need to check edge since there can be none with it
	lw	$t0, 0($s0)						# Load the max number of nodes allowed
	lw	$t1, 8($s0)						# Load the size of each node
	mult	$t0, $t1						# Multiply the two to get the space allocated for nodes
	mflo	$t0							# Get that result into register $t0
	add	$t0, $s0, $t0						# Add that to Network to 'skip' the nodes section
	addi	$a0, $t0, 36						# We also needed to skip the 36 fixed bits
	jal	get_next_multiple					# Since nodes are not always multiple of fours, and edges are word-aligned, the address should be a multiple of 4
	move	$s3, $v0						# Store that for the current edge
	lw	$s4, 20($s0)						# Get the number of edges in Network
	checkEdgesIII:
		blez	$s4, edgesCheckedIII				# If we have no more edges, we have shown that the relationship doesn't exist
		lw	$t0, 0($s3)					# Load the first four bytes of the edge
		lw	$t1, 4($s3)					# Load the second four bytes of the edge
		beq	$t0, $s1, matchOneOneIII			# Compare the first with Person 1
		beq	$t0, $s2, matchOneTwoIII			# Compare the first with Person 2
		j	nextEdgeIII					# Neither of Person 1/2 matched with the first part of the edge
		matchOneOneIII:
			beq	$t1, $s2, relationshipFoundIII		# We found a match
			j	nextEdgeIII				# Person 1 ended up matching but it wasn't a relationship with Person 2
		matchOneTwoIII:
			beq	$t1, $s1, relationshipFoundIII		# We found a match
			j	nextEdgeIII				# Person 2 ended up matching but it wasn't a relationship with Person 1
		nextEdgeIII:
			addi	$s3, $s3, 12				# Check the next edge, the size of each edge is always 12, so we don't need to load from Network/s0
			addi	$s4, $s4, -1				# Decrease the number of edges to check
			j	checkEdgesIII				# Keep checking until we break the cycle
	relationshipFoundIII:
		lw	$t0, 8($s3)					# Load the friendship value of the relation
		blez	$t0, edgesCheckedIII				# There was no actual friendship, just a 0 relation
		move	$v0, $s2					# Return Person2
		j	relationshipCheckedIII				# Note: Person 1 and 2 will never the same person if the edge was added
	edgesCheckedIII:
		move	$v0, $0						# We checked all the edges and there were no such relationships
	relationshipCheckedIII:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		lw	$s4, 20($sp)					# Restores $s4 from stack
		addi	$sp, $sp, 24					# Deallocate stack space
		jr	$ra

get_next_multiple: # Get the next multiple of 4
#a0 contains any address that we want to check
#v0 will contain the next multiple of four
	multipleLoop:
		sll	$t0, $a0, 30					# We only want to check the last couple of bits
		beqz	$t0, multOfFour					# If it is a multiple of four(and therefore they are zero), we can break free
		addi	$a0, $a0, 1					# Increase until we get a multiple of four
		j	multipleLoop
	multOfFour:
		move	$v0, $a0					# Return the next multiple of for
		jr	$ra

is_valid_node: # Given a Network and an address, determine if it could be a node(will not change the arguments)
#a0 contains Network
#a1 contains an address we want to check
#v0 will contain a boolean for if its a node(1 if it is, 0 otherwise)
	addi	$t0, $a0, 36						# Skips the first 36 fixed bits
	lw	$t1, 8($a0)						# Load the size of each node
	lw	$t2, 0($a0)						# Load max number of nodes
	checkNext:
		beq	$t0, $a1, valid					# See if this was our address
		bltz	$t2, invalid					# We went through all possible node addresses
		add	$t0, $t0, $t1					# Add the size of node to check the next address
		addi	$t2, $t2, -1					# We read one more node
		j	checkNext
	invalid:
		addi	$v0, $0 , 0					# We want to return 0
		j	validityChecked
	valid:
		addi	$v0, $0 , 1					# We want to return 1
	validityChecked:
		jr	$ra
