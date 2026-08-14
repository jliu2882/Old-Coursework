# Jack Liu
# jalliu
# 112655156

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text

load_game: # Initializes GameState as well as let us know if the number of stones/pockets are valid
#a0 contains the pointer(starting memory address) of a GameState which CAN hold the contents of the file; assume it has garbage
#a1 contains the filename we should open and read
#v0 will be -1 if the file does not exist, 0 if the stones exceed the limit(99), and 1 if the stones fit in the limit
#v1 will be -1 if the file does not exist, 0 if the pockets exceed the limit(98), and will be the number of pockets otherwise
	addi	$sp, $sp, -32						# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack(Store the pointer to GameState)
	sw	$s1, 8($sp)						# Saves $s1 on stack(Store a variable we want to keep between calls)
	sw	$s2, 12($sp)						# Saves $s2 on stack(Store the v0 between calls)
	sw	$s3, 16($sp)						# Saves $s3 on stack(Store the v1 between calls)
	sw	$s4, 20($sp)						# Saves $s4 on stack(Store the running stone count)
	sw	$s5, 24($sp)						# Saves $s5 on stack(Store the character for bot mancala)
	sw	$s6, 28($sp)						# Saves $s6 on stack(Store the other character for bot mancala)
	move 	$s0, $a0						# Uses s0 to store the a0 pointer to GameState
	move	$a0, $a1        					# Pre-emptively load filename
	li	$v0, 13							# Loads the syscall for opening a file
	move	$a1, $0							# Loads the file flag for opening a file in read mode
	move	$a2, $0		 					# Loads the file mode (unused?)
	syscall								# Opens the file
	bgez	$v0, fileFound						# If the file descriptor is not negative, we found the file
	addi	$s2, $0 , -1						# If the file is not found, we should return -1 in v0
	addi	$s3, $0 , -1						# If the file is not found, we should return -1 in v1
	j	loadedGame						# Should not modify the return values any further
	fileFound: # Assumes numbers in files are positive, since negative numbers are 'invalid'
		move	$a0, $v0					# Load file descriptor from the previous syscall, will be our a0 argument forever :)
		topMancala:
			jal	read_char				# Reads the first character for top mancala
			move	$s1, $v0				# Store the first character for later use
			jal	read_char				# Reads the next character(arguments haven't changed)
			li	$t0, '\n'				# Loads the new character symbol
			bne	$t0, $v0, appendTwoTop			# If we didn't get a newline, we should append both characters
			addi	$t1, $0 , 48				# Loads the ASCII for 0 since we read a newline
			sb	$t1, 6($s0)				# Loads the '0' as the tens digit, since we only have 1
			sb	$s1, 7($s0)				# Loads the ones digit into the gameboard
			addi	$s1, $s1, -48				# Convert the character into its integer value
			move	$s4, $s1				# Keep a track of total stones, initially 0 so 0+s1 = s1
			sb	$s1, 1($s0)				# Store the value into top mancala
			j	botMancala				# We finished reading top mancala
			appendTwoTop:
				sb	$s1, 6($s0)			# Loads the tens digit(the first one read)
				sb	$v0, 7($s0)			# Loads the ones digit(the recent one read)
				addi	$s1, $s1, -48			# Convert the first character into its integer value
				li	$t0, 10				# We want to multiply the tens digit by 10
				mult	$s1, $t0			# We did it
				mflo	$s1				# Single digit * 10 will never overflow
				addi	$v0, $v0, -48			# Convert the recent character into its integer value
				add	$s1, $s1, $v0			# Add the tens digit with the ones digit
				move	$s4, $s1			# Keep a track of total stones, initially 0 so 0+s1 = s1
				sb	$s1, 1($s0)			# Store the value into top mancala
				topCheck:
					jal	read_char		# Reads the character again
					li	$t0, '\n'		# Loads the new character symbol
					beq	$t0, $v0, botMancala	# On a newline, we have finished reading top mancala
					move	$s2, $0			# Since we have somehow read 3 digits without a newline, bot mancala contains more than 99 stones
					j	topCheck		# Repeatedly read the next char, until we reach the newline; will repeatedly assign s2=0
		botMancala:
			jal	read_char				# a0 is still file descriptor so :), saving/loading is redudant (read_char  property)
			move	$s1, $v0				# Store the first character for later use
			jal	read_char				# Reads the next character(arguments haven't changed)
			li	$t0, '\n'				# Loads the new character symbol
			bne	$t0, $v0, appendTwoBot			# If we didn't get a newline, we should append both characters
			addi	$t1, $0 , 48				# Loads the ASCII for 0 since we read a newline
			move	$s5, $t1				# Loads the '0' to append once we know how many pcokets there are
			move	$s6, $s1				# Loads the one digit for the same reason
			addi	$s1, $s1, -48				# Convert the character into its integer value
			add	$s4, $s4, $s1				# Keep a track of total stones
			sb	$s1, 0($s0)				# Store the value into bot mancala
			j	pockets					# We finished reading bot mancala
			appendTwoBot:
				move	$s5, $s1			# Loads the tens digit(the first one read) for later
				move	$s6, $v0			# Loads the ones digit(the recent one read) for later
				addi	$s1, $s1, -48			# Convert the first character into its integer value
				li	$t0, 10				# We want to multiply the tens digit by 10
				mult	$s1, $t0			# We did it
				mflo	$s1				# Single digit * 10 will never overflow
				addi	$v0, $v0, -48			# Convert the recent character into its integer value
				add	$s1, $s1, $v0			# Add the tens digit with the ones digit
				add	$s4, $s4, $s1			# Keep a track of total stones
				sb	$s1, 0($s0)			# Store the value into bot mancala
				botCheck:
					jal	read_char		# Reads the character again
					li	$t0, '\n'		# Loads the new character symbol
					beq	$t0, $v0, pockets	# On a newline, we have finished reading bot mancala
					move	$s2, $0			# Since we have somehow read 3 digits without a newline, bot mancala contains more than 99 stones
					j	botCheck		# Repeatedly read the next char, until we reach the newline; will repeatedly assign s2=0
		pockets:
			jal	read_char				# blah blah arguments same
			move	$s1, $v0				# Store the first character for later use
			jal	read_char				# Reads the next character(arguments haven't changed)
			li	$t0, '\n'				# Loads the new character symbol
			bne	$t0, $v0, appendTwoPockets		# If we didn't get a newline, we should append both characters
			addi	$s1, $s1, -48				# Convert the character into its integer value
			sb	$s1, 2($s0)				# Store the value into bot_pockets
			sb	$s1, 3($s0)				# Store the value into top_pockets
			sll	$s3, $s1, 1				# We have two times the number of pockets(top+bottom), single digit*2 will never be more than 98
			j	moveCount				# We finished reading bot mancala
			appendTwoPockets:
				addi	$s1, $s1, -48			# Convert the first character into its integer value
				li	$t0, 10				# We want to multiply the tens digit by 10
				mult	$s1, $t0			# We did it
				mflo	$s1				# Single digit * 10 will never overflow
				addi	$v0, $v0, -48			# Convert the recent character into its integer value
				add	$s1, $s1, $v0			# Add the tens digit with the ones digit
				sb	$s1, 2($s0)			# Store the value into bot_pockets
				sb	$s1, 3($s0)			# Store the value into top_pockets
				sll	$s3, $s1, 1			# Multiply the value by two and store it in the saved variable
				addi	$t0, $0 , 98			# We don't want there to be a case of more than 98 pockets (49 top/49 bot)
				bgt	$s3, $t0, tooMany		# If we do have more than 98, we should set s3 to 0, and read until we get newline
				pocketCheck:
					jal	read_char		# Reads the character again
					li	$t0, '\n'		# Loads the new character symbol
					beq	$t0, $v0, moveCount	# On a newline, we have finished reading the pockets
					tooMany:
						move	$s3, $0		# Since we have somehow read 3 digits without a newline, pockets are more than 98
						j	pocketCheck	# Repeatedly read the next char, until we reach the newline; will repeatedly assign s3=0
		moveCount:
			sb	$0, 4($s0)				# By default, moves executed should be 0
		playerTurn:
			addi	$t0, $0, 66				# Loads ASCII value for 'B'
			sb	$t0, 5($s0)				# By default, player turn should be 'B'
		addi	$s0, $s0, 8					# It's easier to change the address now; too lazy to reset s0 to read the mancala so I saved a count
		topRow:
			jal	read_char				# Read the first character of the pair for top row
			li	$t0, '\n'				# Loads the new character symbol
			beq	$t0, $v0, botRow			# On a newline, we have finished reading the top row
			sb	$v0, 0($s0)				# Otherwis, we want to store our character in the state
			addi	$s0, $s0, 1				# When we do read the next character, it should be in the next position
			addi	$t0, $v0, -48				# Get the numerical value of the character
			addi	$t1, $0, 10				# We want to multiply it by 10
			mult	$t0, $t1				# Done
			mflo	$t0					# Move the product into t0
			add	$s4, $s4, $t0				# Add that to our running count of stones
			jal	read_char				# Read the second character of the pair; will never be newline if input is valid
			sb	$v0, 0($s0)				# We want to store this character in the state
			addi	$v0, $v0, -48				# Get the numerical value of the character
			add	$s4, $s4, $v0				# Add the character into running count
			addi	$s0, $s0, 1				# When we read the next character, it should be in the next position
			j	topRow					# Then we want to read another character
		botRow:
			jal	read_char				# Read the first character of the bot row
			li	$t0, '\n'				# Loads the new character symbol
			beq	$t0, $v0, finalSetup			# On a newline, we have finished reading the bot row
			sb	$v0, 0($s0)				# Otherwis, we want to store our character in the state
			addi	$s0, $s0, 1				# When we do read the next character, it should be in the next position
			addi	$t0, $v0, -48				# Get the numerical value of the character
			addi	$t1, $0, 10				# We want to multiply it by 10
			mult	$t0, $t1				# Done
			mflo	$t0					# Move the product into t0
			add	$s4, $s4, $t0				# Add that to our running count of stones
			jal	read_char				# Read the second character of the pair; will never be newline if input is valid
			sb	$v0, 0($s0)				# We want to store this character in the state
			addi	$v0, $v0, -48				# Get the numerical value of the character
			add	$s4, $s4, $v0				# Add the character into running count
			addi	$s0, $s0, 1				# When we read the next character, it should be in the next position
			j	botRow					# Then we want to read another character
		finalSetup:
			addi	$t0, $0, 100				# We don't want to violate our stone count of 99
			slt	$s2, $s4, $t0				# If our stone count is less than 100, our output is valid(1); otherwise it'll be invalid(0)
			sb	$s5, 0($s0)				# We now reached the position of bot mancala
			sb	$s6, 1($s0)				# So we append them here
	loadedGame:
		li	$v0, 16						# Loads the syscall to close file with argument a0 already there
		syscall							# Closes the file cause it's the nice thing to do :D
		move	$v0, $s2					# Loads the proper function output
		move	$v1, $s3					# Loads the proper function output
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		lw	$s4, 20($sp)					# Restores $s4 from stack
		lw	$s5, 24($sp)					# Restores $s5 from stack
		lw	$s6, 28($sp)					# Restores $s6 from stack
		addi	$sp, $sp, 32					# Deallocate stack space
		jr	$ra

#I made a bunch of helper functions and eventually refactored this code to be clean but forgot it existed until part 7 LOL
get_pocket: # Without changing main memory, we will return the number of stones in a pocket
#a0 contains the pointer to a GameState
#a1 contains an ASCII value for which players turn we are in: 'T' or 'B'
#a2 contains the distance of the pocket we want to read; should be positive
#v0 will contain the integer value of the stones at the pocket; or -1 if player or distance is invalid
	addi	$sp, $sp, -4						# Allocate space on the stack to store $ra
	sw	$ra, 0($sp)						# Saves $ra on stack
	jal	get_index						# The function was made such that our parameters line up :)
	addi	$t0, $0 , -1						# Prepare to test our output with -1; with -1 being an error occured
	beq	$v0, $t0, gotPocket					# We got an error, so we should pre-emptively end the program
	lbu	$a0, 0($v0)						# This is the tens
	lbu	$a1, 1($v0)						# This is the ones
	jal	get_integer						# Get the integer equivalent
	gotPocket:
		lw	$ra, 0($sp)					# Restores $ra from stack
		addi	$sp, $sp, 4					# Deallocate stack space
		jr	$ra

set_pocket: #We will set a pocket to a given value with minimal changes to state
#a0 contains the pointer to a GameState
#a1 contains the player whose row will be affected
#a2 contains the distance of the pocket who will be affected
#a3 contains the value in ASCII to overwrite with
#v0 will contain the size(if both player/distance are valid), -1 if either are invalid, -2 if the size is not within 0-99
	addi	$sp, $sp, -12						# Allocate space on the stack to store $ra and saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack (will save the index since I made another helper....)
	sw	$s1, 8($sp)						# Saves $s1 on stack (will save a3 since I'm addicted to more functions..)
	jal	get_index						# The function was made such that our parameters line up :)
	addi	$t0, $0 , -1						# Prepare to test our output with -1; with -1 being an error occured
	beq	$v0, $t0, pocketSet					# We got an error, so we should pre-emptively end the program
	move	$s0, $v0						# Move our output somewhere safe
	addi	$v0, $0 , -2						# Assumes our output is invalid
	bltz	$a3, pocketSet						# Our concerns were jusitified, we were trying to set it to negative
	addi	$t1, $0 , 99						# Another concern, what if we tried to set it to more than 99
	bgt	$a3, $t1, pocketSet					# Now, it's justified (MORE THAN 99; HOW DARE YOU)
	move	$s1, $a3						# Haha, just kidding we're just gonna save the size for later
	move	$a0,$a3							# Move the value into our arguments
	jal	get_ascii						# Get the ASCII equivalent to store
	sb	$v0, 0($s0)						# Store the value into the index
	sb	$v1, 1($s0)						# Store the value into the index
	move	$v0, $s1						# Loads our saved size now(not after pocketSet to preserve errors)
	pocketSet:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		addi	$sp, $sp, 12					# Deallocate stack space
		jr	$ra

collect_stones: #Changes a players mancala in both GameState and the gameboard part of GameState
#a0 contains a pointer to GameState
#a1 contains the player the mancala belongs to
#a2 contains quantity of stones to add; we can assume safely that the stones to add will not add up to over 99
#v0 will contain the number of stones(from a2) if player and stones are valid; -1 if the player is invalid; -2 if the stones is less than or equal to 0
	addi	$sp, $sp, -16						# Allocate space on the stack to store $ra and saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack (will save the pointer to GameState)
	sw	$s1, 8($sp)						# Saves $s1 on stack (will save the number of stones)
	sw	$s2, 12($sp)						# Saves $s2 on stack (will save the pointer to GameState)
	move	$s0, $a0						# See?
	move	$s2, $a0						# I was too spooked to move it somewhere else in case of "convention"
	li	$t0, 'T'						# Load the immediate for 'T'
	li	$t1, 'B'						# Load the immediate for 'B'
	addi	$v0, $0 , -1						# Assume the player is invalid
	beq	$a1, $t0, collectTop					# We want to modify the mancala for the top player
	bne	$a1, $t1, collected					# The player is neither 'T'op or 'B'ot, so we assumed correctly
	addi	$v0, $v0, -1						# Assume that the stones are now invalid
	blez	$a2, collected						# If the stones are less than or equal to zero, we should end
	move	$v0, $a2						# The stones are valid, so we should return the stone count
	move	$s1, $a2						# Save the number of stones for now
	lb	$t0, 2($s0)						# Get number of pockets
	sll	$t0, $t0, 2						# Multiply by 4 because I can (and the math adds up)
	addi	$t0, $t0, 8						# Add 8 to account for the previous variable/top mancala
	add	$s0, $s0, $t0						# Add the offset to the address
	lb	$a0, 0($s0)						# Load the current value of bot mancala
	lb	$a1, 1($s0)						# Load the current value of bot mancala
	jal	get_integer						# Get the integer value of bot mancala; doesn't change a2 but
	add	$s1, $s1, $v0						# Add the stones together
	sb	$s1, 0($s2)						# Store the stone count in bot mancala
	move	$a0, $s1						# Load the argument in for get_ascii(stone count)
	jal	get_ascii						# Get the two ASCII values for top mancala
	sb	$v0, 0($s0)						# Store the first ASCII value in
	sb	$v1, 1($s0)						# Store the other ASCII value in
		move	$v0, $s1					# When there is no errors, we should return the number of stones
	j	collected
	collectTop:
		addi	$v0, $v0, -1					# Assume that the stones are now invalid
		blez	$a2, collected					# If the stones are less than or equal to zero, we should end
		move	$v0, $a2					# The stones are valid, so we should return the stone count
		move	$s1, $a2					# Save the number of stones for now
		lb	$a0, 6($s0)					# Load the current value of top mancala
		lb	$a1, 7($s0)					# Load the current value of top mancala
		jal	get_integer					# Get the integer value of top mancala; doesn't change a2 but
		add	$s1, $s1, $v0					# Add the stones together
		sb	$s1, 1($s0)					# Store the stone count in top mancala
		move	$a0, $s1					# Load the argument in for get_ascii(stone count)
		jal	get_ascii					# Get the two ASCII values for top mancala
		sb	$v0, 6($s0)					# Store the first ASCII value in
		sb	$v1, 7($s0)					# Store the other ASCII value in
		move	$v0, $s1					# When there is no errors, we should return the number of stones
	collected:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s1 from stack
		addi	$sp, $sp, 16					# Deallocate stack space
		jr	$ra

verify_move: #We will verify if a move is legal without modifying memory(except in a special case of 99)
#a0 contains a pointer to GameState
#a1 contains the origin pocket or the number of pockets from the mancala of the current player
#a2 contains the distance to move
#v0 will contain 2 if the distance was 99; 1 if the move was legal; Errors for v0 will be listed below
#-1 if the origin pocket is invalid; 0 if origin pocket has zero stones; -2 if the distance is zero or not equal to stones in origin pocket
	addi	$sp, $sp, -8						# Allocate space on the stack to store $ra and $s0
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack (Will save the distance to move)
	move	$s0, $a2						# We will load arguments into a2 before we get to use up a2
	li	$t0, 99							# If we have the special case of distance 99, we should treat it separately
	bne	$a2, $t0, notSpecial					# If distance isn't 99, we can't just return 2
	lb	$t0, 5($a0)						# The player turn is offset by 5 of base address of gamestate
	li	$t1, 'T'						# Loads ASCII for player turn 'T'op
	li	$t2, 'B'						# Loads ASCII for player turn 'B'ot
	beq	$t0, $t1, topSpecial					# GameState will be valid so it will be 'T'op or 'B'ot
	sb	$t1, 5($a0)						# We want to swap the turn so bot->top
	addi	$v0, $0 , 2						# Special case needs to return 2
	lb	$t0, 4($a0)						# Get the number of moves executed thus far
	addi	$t0, $t0, 1						# Increase the number of moves executed by 1
	sb	$t0, 4($a0)						# Store the increased moves into game state
	j	verified						# We verified this subsection of moves
	topSpecial:
		sb	$t2, 5($a0)					# We want to swap the turn so top->bot
		addi	$v0, $0 , 2					# Special case needs to return 2
		lb	$t0, 4($a0)					# Get the number of moves executed thus far
		addi	$t0, $t0, 1					# Increase the number of moves executed by 1
		sb	$t0, 4($a0)					# Store the increased moves into game state
		j	verified					# We verified this move was valid
	notSpecial:
		lb	$t0, 2($a0)					# Loads the number of pockets
		blt	$a1, $t0, validOrigin				# If the origin is strictly less than the pocket count, we are valid(since we are 0-index)
		invalidOrigin:
			addi	$v0, $0 , -1				# Our origin's index was out of bounds(includes negatives since )
			j	verified				# We verified this move was invalid	
	validOrigin:
		bltz	$a1, invalidOrigin				# Actually, I don't know if the input will be positive but we should catch that too
		move	$a2, $a1					# The origin pocket was the index; so we should load it up as such
		lb	$a1, 5($a0)					# Load the player turn into get_index; gamestate and distance are already loaded
		jal	get_index					# Get the index from default position a0 of our origin pocket
		
		lb	$a0, 0($v0)					# Load the tens digit for get_integer
		lb	$a1, 1($v0)					# Load the ones digit for get_integer
		jal	get_integer					# Get the integer value of the origin pocket
		bnez	$v0, originFull					# Our origin pocket has more than 0 stones
		move	$v0, $0						# Our origin pocket was empty :((
		j	verified					# We have verified that our move is invalid
	originFull:
		blez	$s0, invalidDistance				# Our distance must not be 0(STILL ASSUMING THAT DISTANCE MUST BE POSITIVE, although this part isn't needed)
		bne	$s0, $v0, invalidDistance			# If our stones don't match the distance, invalid distance(Since pockets can't be negative, this handles that^)
		addi	$v0, $0 , 1					# We have passed all cases of nonlegal/special moves
		j	verified					# Our move is indeed valid
	invalidDistance:
		addi	$v0, $0 , -2					# Our distance was invalid, one way or the other
	verified:
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		addi	$sp, $sp, 8					# Deallocate stack space
		jr	$ra

execute_move: #We will take an origin pocket and perform a move after verifying it's validity; therefore all moves here are valid
#a0 contains game state
#a1 contains origin pocket, the distance from the mancala of the current player
#v0 will contain the number of stones added to the mancala
#v1 will contain a number based on where the last stone was dropped; 2 for mancala, 1 for anywhere in the players row and was empty before, 0 anywhere else
	addi	$sp, $sp, -36						# Allocate space on the stack to store $ra and $s0
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack (Will save v0)
	sw	$s1, 8($sp)						# Saves $s1 on stack (Will save v1)
	sw	$s2, 12($sp)						# Saves $s2 on stack (Will save player turn)
	sw	$s3, 16($sp)						# Saves $s3 on stack (Will save index of pocket we are visiting)
	sw	$s4, 20($sp)						# Saves $s4 on stack (Will save total stones)
	sw	$s5, 24($sp)						# Saves $s5 on stack (Will save the index; cause I'm too lazy to check for dynamic positions)
	sw	$s6, 28($sp)						# Saves $s6 on stack (Will save gamestate cause I'm too lazy; see above)
	sw	$s7, 32($sp)						# Saves $s7 on stack (Will save amount of stones; 'when in doubt add another saved register' -jack)
	move	$s0, $0							# Initialize stones added to mancala as 0; s1 will be set
	move	$s5, $a1						# Save origin pocket as index for later :)
	move	$s6, $a0						# Save gameState for later
	lb	$t0, 4($a0)						# Since the move will be valid, we will pre-emptively increase the move count
	addi	$t0, $t0, 1						# Note that the '99' move can't be run from here
	sb	$t0, 4($a0)						# Last 2 lines of code with this are just loading, increasing and storing the moves
	lb	$s2, 5($a0)						# Get the current player turn
	move	$a2, $a1						# Move the origin pocket to the distance argument
	move	$a1, $s2						# Load the parameter player turn
	jal	get_index						# Get the index of the origin pocket
	move	$s3, $v0						# Save it for later use
	lb	$a0, 0($v0)						# Load the tens place
	lb	$a1, 1($v0)						# Load the ones place
	jal	get_integer						# Get the integer value of the pocket
	move	$s4, $v0						# Store the amount of stones we picked up
	move	$a0, $s6						# Get the game state into a0
	move	$a1, $s2						# Prepares to set origin to zero
	move	$a2, $s5						# This is because we picked it up; so it should have no stones
	move	$a3, $0							# Now we can redistribute those stones
	jal	set_pocket						# Finally remembered to use previous functions
	li	$t0, 'T'						# Load the ASCII for 'T'op
	beq	$s2, $t0, executeTop					# We will move our stones skipping the origin at the top
	executeBot:
		beqz	$s5, mancalaCheckBot				# idk bugfix time
		addi	$s3, $s3, 2					# Move to the next spot in a counter-clockwise position
		addi	$s4, $s4, -1					# Drop a stone off at this point
		addi	$s5, $s5, -1					# We are moving closer to our mancala so the index drops
		lb	$a0, 0($s3)					# Load the tens stone in the new pocket for get_integer
		lb	$a1, 1($s3)					# Load the ones stone in the new pocket for get_integer
		jal	get_integer					# Get the integer value
		addi	$t0, $v0, 1					# Increment it by 1
		move	$s7, $t0					# Save the integer value for later
		move	$a0, $t0					# Load the integer value for get_ascii
		jal	get_ascii					# Get the ASCII values
		sb	$v0, 0($s3)					# Store it back into the new position
		sb	$v1, 1($s3)					# Store it back into the new position
		bnez	$s4, botStone					# If we still have stones, we don't need to do much more
		li	$t1, 'B'					# If we ran out of stones, we want to check if it is 'B'ot turn
		bne	$s2, $t1, notBotTurn				# Either way, our last stone was dropped off on the 'B'ot row
		addi	$t1, $0 , 1					# If the pocket was empty; it should now have one stone
		beq	$s7, $t1, emptyPocketBot			# Register s7 has the stones in the new pocket; so we see if it was empty
		move	$s1, $0						# This means it was 'B'ot turn and the pocket we dropped into was not empty at bot
		li	$s3, 'T'					# It was bot turn, but our move means it's now top's turn; saved in s3 because we want to keep original turn
		j	executed					# Our move is executed
		emptyPocketBot:
			addi	$s1, $0 , 1				# This means it was 'B'ot turn and the pocket we dropped into was empty at bot
			li	$s3, 'T'				# It was bot turn, but our move means it's now top's turn; saved in s3 because we want to keep original turn
			j	executed				# Our move is executed
		notBotTurn:
			move	$s1, $0					# This means that it was 'T'op turn and we dropped it off at bot(anywhere else)
			li	$s3, 'B'				# It was top turn, but our move means it's now bot's turn; saved in s3 because we want to keep original turn
			j	executed				# Our move is executed
		botStone:
			beqz	$s5, mancalaCheckBot			# If we just dropped our last stone adjacent to a mancala, we should check it out
			j	executeBot				# Otherwise, we should stay in our row
	executeTop:
		beqz	$s5, mancalaCheckTop				# idk bugfix time
		addi	$s3, $s3, -2					# Move to the next spot in a counter-clockwise position
		addi	$s4, $s4, -1					# Drop a stone off at this point
		addi	$s5, $s5, -1					# We are moving closer to our mancala so the index drops
		lb	$a0, 0($s3)					# Load the tens stone in the new pocket for get_integer
		lb	$a1, 1($s3)					# Load the ones stone in the new pocket for get_integer
		jal	get_integer					# Get the integer value
		addi	$t0, $v0, 1					# Increment it by 1
		move	$s7, $t0					# Save the integer value for later
		move	$a0, $t0					# Load the integer value for get_ascii
		jal	get_ascii					# Get the ASCII values
		sb	$v0, 0($s3)					# Store it back into the new position
		sb	$v1, 1($s3)					# Store it back into the new position
		bnez	$s4, topStone					# If we still have stones, we don't need to do much more
		li	$t1, 'T'					# If we ran out of stones, we want to check if it is 'T'op turn
		bne	$s2, $t1, notTopTurn				# Either way, our last stone was dropped off on the 'T'op row
		addi	$t1, $0 , 1					# If the pocket was empty; it should now have one stone
		beq	$s7, $t1, emptyPocketTop			# Register s7 has the stones in the new pocket; so we see if it was empty
		move	$s1, $0						# This means it was 'T'op turn and the pocket we dropped into was not empty at top
		li	$s3, 'B'					# It was top turn, but our move means it's now bot's turn; saved in s3 because we want to keep original turn
		j	executed					# Our move is executed
		emptyPocketTop:
			addi	$s1, $0 , 1				# This means it was 'T'op turn and the pocket we dropped into was empty at top
			li	$s3, 'B'				# It was top turn, but our move means it's now bot's turn; saved in s3 because we want to keep original turn
			j	executed				# Our move is executed
		notTopTurn:
			move	$s1, $0					# This means that it was 'B'ot turn and we dropped it off at top(anywhere else)
			li	$s3, 'T'				# It was bot turn, but our move means it's now top's turn; saved in s3 because we want to keep original turn
			j	executed				# Our move is executed
		topStone:
			beqz	$s5, mancalaCheckTop			# If we just dropped our last stone adjacent to a mancala, we should check it out
			j	executeTop				# Otherwise, we should stay in our row
	mancalaCheckBot:
		li	$t0, 'B'					# We want to see if it is curently 'B'ot's turn, so we can add to the mancala
		bne	$s2, $t0, botChecked				# It isn't bot's turn, so we can't add to it's mancala
		addi	$s4, $s4, -1					# Our stones being moved around decreased
		addi	$s0, $s0, 1					# Stones added to the mancala increased
		bnez	$s4, botChecked					# Check if we dropped our last stone here
		addi	$s1, $0 , 2 					# We dropped our last stone in the bot mancala on bot turn
		li	$s3, 'B'					# We want to keep the turn as bot; saved in s3 because we want to keep original turn
		j	executed					# We executed the move
		botChecked:
			lb	$s5, 2($s6)				# Get the number of pockets(0-index but execute takes care of that)
			move	$a0, $s6				# Load gamestate for get_index
			li	$a1, 'T'				# We want to get the index for the other row
			addi	$a2, $s5, -1				# We just set the index(maximum) so we use that in our argument
			jal	get_index				# Get the address of the new index
			move	$s3, $v0				# Move that into s3 to keep using
			addi	$s3, $s3, 2				# Idk but it works
			addi	$s5, $s5, 1				# nvm executeTop decreases early so we need to be above it, but get_index needed the 0index so
			j	executeTop				# We did what we needed to do for bot row, so move on to the top row
	mancalaCheckTop:
		li	$t0, 'T'					# We want to see if it is curently 'T'op's turn, so we can add to the mancala
		bne	$s2, $t0, topChecked				# It isn't top's turn, so we can't add to it's mancala
		addi	$s4, $s4, -1					# Our stones being moved around decreased
		addi	$s0, $s0, 1					# Stones added to the mancala increased
		bnez	$s4, topChecked					# Check if we dropped our last stone here
		addi	$s1, $0 , 2 					# We dropped our last stone in the top mancala on top turn
		li	$s3, 'T'					# We want to keep the turn as top; saved in s3 because we want to keep original turn
		j	executed					# We executed the move
		topChecked:
			lb	$s5, 2($s6)				# Get the number of pockets(0-index but execute takes care of that)
			move	$a0, $s6				# Load gamestate for get_index
			li	$a1, 'B'				# We want to get the index for the other row
			addi	$a2, $s5, -1				# We just set the index(maximum) so we use that in our argument
			jal	get_index				# Get the address of the new index
			move	$s3, $v0				# Move that into s3 to keep using
			addi	$s3, $s3, 2				# Idk but it works
			addi	$s5, $s5, 1				# nvm executeTop decreases early so we need to be above it, but get_index needed the 0index so
			j	executeBot				# We did what we needed to do for top row, so move on to the bot row
	executed:
		sb	$s3, 5($s6)					# Store the updated player turn into GameState; move will always be valid so no worries about s3 not being updated
		move	$a0, $s6					# Load gameState for collect_stones
		move	$a1, $s2					# Load the original player turn
		move	$a2, $s0					# Load the amount of stones to add
		jal	collect_stones					# Add the amount of stones in the mancala; if it was zero, no change occurs
		move	$v0, $s0					# Load the output
		move	$v1, $s1					# Load the output
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		lw	$s4, 20($sp)					# Restores $s4 from stack
		lw	$s5, 24($sp)					# Restores $s5 from stack
		lw	$s6, 28($sp)					# Restores $s6 from stack
		lw	$s7, 32($sp)					# Restores $s7 from stack
		addi	$sp, $sp, 36					# Deallocate stack space
		jr	$ra

steal: #We will use steal when execute_move returns v1=1.
#a0 contains a pointer to GameState
#a1 contains the destination pocket, aka where the previous player dropped the stone to start the steal
#v0 will contain number of stones added to the mancala
	addi	$sp, $sp, -24						# Allocate space on the stack to store $ra and $s0
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack (Will save the gameState)
	sw	$s1, 8($sp)						# Saves $s1 on stack (Will save the destination pocket)
	sw	$s2, 12($sp)						# Saves $s2 on stack (Will save the number of stones added)
	sw	$s3, 16($sp)						# Saves $s3 on stack (Will save the other players turn)
	sw	$s4, 20($sp)						# Saves $s4 on stack (Will save the other pocket)
	lb	$t0, 5($a0)						# Get the player turn, note that the stealer is the other player
	li	$t1, 'T'						# Load the ASCII for top
	beq	$t0, $t1, topSteal					# If it is top turn, we should get bot
	li	$s3, 'T'						# It is currently bot's turn, so top must have been the stealer
	j	thiefFound						# We have found the stealer
	topSteal:
		li	$s3, 'B'					# It is currently top's turn, so bot must have been the stealer
	thiefFound:
		move	$s0, $a0					# Save GameState for later
		move	$s1, $a1					# Save destination pocket
		move	$a2, $a1					# Load the argument for set_pocket
		move	$a1, $s3					# Load player turn for set_pocket
		move	$a3, $0						# We want to empty destination pocket of the 1
		jal	set_pocket					# Clears destination pocket
		lb	$t0, 2($s0)					# Get the pockets, so we can inverse it to find the other side
		addi	$t0, $t0, -1					# Subtract 1, so the indexing is corrected
		sub	$s4, $t0, $s1					# Subtract the destination to get the inverse; stores it for later use
		move	$a0, $s0					# Load the state for get_pocket
		lb	$a1, 5($s0)					# Load the player turn for get_pocket
		move	$a2, $s4					# Load the distance for the other pocket
		jal	get_pocket					# Get the pockets from the opposite side
		addi	$s2, $v0, 1					# Increase the amount of stones by 1 (for the destination pocket)
		move	$a0, $s0					# Load gamestate argument for set_pocket
		lb	$a1, 5($s0)					# Load the player turn we are stealing from
		move	$a2, $s4					# Load the distance for the other pocket
		move	$a3, $0						# We want to clear the other pocket since we stole from it
		jal	set_pocket					# Set the other side to 0 as well
	stolen:
		move	$a1, $s3					# Load the other player's turn, or the stealers turn
		move	$a2, $s2					# Load the amount of stones we stole to the mancala
		move	$a0, $s0					# Load in gameState again to call collect_stone
		jal	collect_stones					# Collects the stone we added into the proper mancala
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		lw	$s4, 20($sp)					# Restores $s4 from stack
		addi	$sp, $sp, 24					# Deallocate stack space
		jr	$ra

check_row: #Called after execute_move, we check to see if there is an empty row and if there is: clear gameboard and give remaining pieces to the side it is on
#a0 contains a pointer to GameState
#v0 will contain 1 if there was an empty row(Game over); 0 if both rows had something
#v1 will contain 0 if it's a tie; 1 if player 1 has a greater mancala value; 2 if player 2 has a greater value
	addi	$sp, $sp, -20						# Allocate space on the stack to store $ra and $s0
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack (Will save the gameState)
	sw	$s1, 8($sp)						# Saves $s1 on stack (Will save the sum of a row)
	sw	$s2, 12($sp)						# Saves $s2 on stack (Will save the pockets left in a row)
	sw	$s3, 16($sp)						# Saves $s3 on stack (Will save the index we are on)
	move	$s0, $a0						# Save GameState for later
	move	$s1, $0							# Set the sum of the row to be 0
	lb	$s2, 2($s0)						# Get the number of pockets
	addi	$s3, $s0, 8						# We want to start from the first element in the top row
	checkTop:
		lb	$t0, 0($s3)					# Load the tens digit
		lb	$t1, 1($s3)					# Load the ones digit
		li	$t2, '0'					# If either are non zero, our row is not empty
		addi	$s3, $s3, 2					# We are going two at a time
		addi	$s2, $s2, -1					# Decrease the pockets left
		bne	$t0, $t2, topRowChecked				# Testing two at a time because it allows us to use pockets
		bne	$t1, $t2, topRowChecked				# Rather than doubling pockets and looping through one at a time
		bgtz	$s2, checkTop					# If we have more pockets left, we should loop again
		lb	$s2, 2($s0)					# Get the number of pockets
		clearBot:
			lb	$a0, 0($s3)				# Get the tens digit
			lb	$a1, 1($s3)				# Get the ones digit
			jal	get_integer				# Get the integer value of the pocket
			add	$s1, $s1, $v0				# Increase our sum by the count in the pocket
			li	$t0, '0'				# Load the ASCII for 0
			sb	$t0, 0($s3)				# Set the tens digit to '0'
			sb	$t1, 1($s3)				# Set the ones digit to '0'
			addi	$s3, $s3, 2				# Move on to the next pair
			addi	$s2, $s2, -1				# Decrease the pockets left
			bgtz	$s2, clearBot				# If we have more pockets left, we should loop again
		move	$a0, $s0					# Load the game state for collect_stones
		li	$a1, 'B'					# The top row was empty, so the bot row goes to bot
		move	$a2, $s1					# The stones were being kept in s1, so we load it here
		jal	collect_stones					# Add the stones into the proper mancala
		li	$t0, 'D'					# Set the game to finished or 'D'one
		sb	$t0, 5($s0)					# Store it into the game state
		addi	$v0, $0 , 1					# We have one empty row// Game over status message
		j	checkMancalas					# Check the mancalas to update v1
	topRowChecked:
		move	$s1, $0						# Set the sum of the row to be 0
		lb	$s2, 2($s0)					# Get the number of pockets; s3 was set by checkTop
		addi	$s3, $s0, 8					# We want to start from the first element in the top row
		sll	$t0, $s2, 1					# We also want to add the amount of elements in the top row to get to the first element in bottom row
		add	$s3, $s3, $t0					# Change the position of the index to the first in bot row
	checkBot:
		lb	$t0, 0($s3)					# Load the tens digit
		lb	$t1, 1($s3)					# Load the ones digit
		li	$t2, '0'					# If either are non zero, our row is not empty
		addi	$s3, $s3, 2					# We are going two at a time
		addi	$s2, $s2, -1					# Decrease the pockets left
		bne	$t0, $t2, botRowChecked				# Testing two at a time because it allows us to use pockets
		bne	$t1, $t2, botRowChecked				# Rather than doubling pockets and looping through one at a time
		bgtz	$s2, checkBot					# If we have more pockets left, we should loop again
		addi	$s3, $s0, 8					# Reset our index to be for the top row
		lb	$s2, 2($s0)					# Get the number of pockets
		clearTop:
			lb	$a0, 0($s3)				# Get the tens digit
			lb	$a1, 1($s3)				# Get the ones digit
			jal	get_integer				# Get the integer value of the pocket
			add	$s1, $s1, $v0				# Increase our sum by the count in the pocket
			li	$t0, '0'				# Load the ASCII for 0
			sb	$t0, 0($s3)				# Set the tens digit to '0'
			sb	$t1, 1($s3)				# Set the ones digit to '0'
			addi	$s3, $s3, 2				# Move on to the next pair
			addi	$s2, $s2, -1				# Decrease the pockets left
			bgtz	$s2, clearTop				# If we have more pockets left, we should loop again
		move	$a0, $s0					# Load the game state for collect_stones
		li	$a1, 'T'					# The bot row was empty, so the top row goes to top
		move	$a2, $s1					# The stones were being kept in s1, so we load it here
		jal	collect_stones					# Add the stones into the proper mancala
		addi	$v0, $0 , 1					# We have one empty row// Game over status message
		li	$t0, 'D'					# Set the game to finished or 'D'one
		sb	$t0, 5($s0)					# Store it into the game state
		j	checkMancalas					# Check the mancalas to update v1
	botRowChecked:
		move	$v0, $0						# We looped through both rows and they were all '00'
	checkMancalas:
		lb	$t0, 0($s0)					# Load the bot mancala
		lb	$t1, 1($s0)					# Load the top mancala
		beq	$t0, $t1, tie					# They were equal
		bgt	$t0, $t1, botWin				# The bottom mancala or player 1 has more stones
		addi	$v1, $0 , 2					# Otherwise, player 2 has more(aka top mancala)
		j	rowChecked					# We have checked the row
		botWin:
			addi	$v1, $0 , 1				# Player 1(bot mancala) has more
			j	rowChecked				# We have checked the row
		tie:
			move	$v1, $0					# They have an eqaul amount of stones	
		rowChecked:
			lw	$ra, 0($sp)				# Restores $ra from stack
			lw	$s0, 4($sp)				# Restores $s0 from stack
			lw	$s1, 8($sp)				# Restores $s1 from stack
			lw	$s2, 12($sp)				# Restores $s2 from stack
			lw	$s3, 16($sp)				# Restores $s3 from stack
			addi	$sp, $sp, 20				# Deallocate stack space	
			jr	$ra

load_moves: #Take a file and interpret it in a way, where every couple of moves, we add a '99' move
#a0 contains moves, a label to the starting address of an array big enough to house the moves
#a1 contains the filename where we are reading our files from
#v0 will contain how many moves were in the file, if it existed; -1 if there was an error opening the file
	addi	$sp, $sp, -36						# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack(Store the pointer to moves)
	sw	$s1, 8($sp)						# Saves $s1 on stack(Store the v0 between calls)
	sw	$s2, 12($sp)						# Saves $s2 on stack(Store file descriptor between calls)
	sw	$s3, 16($sp)						# Saves $s3 on stack(Utility variable to save things :D )
	sw	$s4, 20($sp)						# Saves $s4 on stack(Store columns)
	sw	$s5, 24($sp)						# Saves $s5 on stack(Store rows)
	sw	$s6, 28($sp)						# Saves $s6 on stack(Store flag of legality)
	sw	$s7, 32($sp)						# Saves $s7 on stack(Store a count for a loop)
	move 	$s0, $a0						# Uses s0 to store the a0 pointer to moves
	move	$s6, $0							# Initiazes our legality flag
	move	$a0, $a1        					# Pre-emptively load filename
	li	$v0, 13							# Loads the syscall for opening a file
	move	$a1, $0							# Loads the file flag for opening a file in read mode
	move	$a2, $0		 					# Loads the file mode (unused?)
	syscall								# Opens the file
	bgez	$v0, movesFound						# If the file descriptor is not negative, we found the file
	addi	$v0, $0 , -1						# If the file is not found, we should return -1 in v0
	move	$s1, $v0						# Save v0 here for now
	j	loadedMoves						# Should not modify the return values any further
	movesFound: #Assume 2*columns*row is the size of the third row since the file is valid
		move	$a0, $v0					# Load file descriptor from the previous syscall
		move	$s2, $v0					# Save file descriptor
		column:
			jal	read_char				# Read the first character
			move	$s3, $v0				# Store the character for later use
			jal	read_char				# Read the second character
			li	$t0, '\n'				# Load the ASCII for newline
			bne	$t0, $v0, twoColumn			# If our character was not a newline, we should handle the case of 2+ length col
			addi	$a0, $0	, 48				# Load 0 as our tens argument in ASCII form
			move	$a1, $s3				# Use the character we stored now in integer form
			jal	get_integer				# Get the integer value
			move	$s4, $v0				# Store the amount of columns for later use
			j	row					# We should now process the rows
			twoColumn:
				move	$a0, $s3			# Load the first character as the tens
				move	$a1, $v0			# Load the new character as the ones
				jal	get_integer			# Get the integer value
				move	$s4, $v0			# Store the amount of columns for later use
				move	$a0, $s2			# Load file descriptor
				columnLoop:
					jal	read_char		# Reads the character again
					li	$t0, '\n'		# Loads the new character symbol
					beq	$t0, $v0, row		# On a newline, we have finished reading the columns
					j	columnLoop		# This should never happen since we are looking to store rows/cols of size [1-99]
		row:
			move	$a0, $s2				# Load file descriptor
			jal	read_char				# Read the first character
			move	$s3, $v0				# Store the character for later use
			jal	read_char				# Read the second character
			li	$t0, '\n'				# Load the ASCII for newline
			bne	$t0, $v0, twoRow			# If our character was not a newline, we should handle the case of 2+ length row
			addi	$a0, $0	, 48				# Load 0 as our tens argument in ASCII form
			move	$a1, $s3				# Use the character we stored now
			jal	get_integer				# Get the integer value
			move	$s5, $v0				# Store the amount of rows for later use
			j	processMoves				# We should now process the moves
			twoRow:
				move	$a0, $s3			# Load the first character as the tens
				move	$a1, $v0			# Load the new character as the ones
				jal	get_integer			# Get the integer value
				move	$s5, $v0			# Store the amount of rows for later use
				move	$a0, $s2			# Load file descriptor
				rowLoop:
					jal	read_char		# Reads the character again
					li	$t0, '\n'		# Loads the new character symbol
					beq	$t0, $v0, processMoves	# On a newline, we have finished reading the rows
					j	rowLoop			# This should never happen since we are looking to store rows/cols of size [1-99]
		processMoves:
			mult	$s4, $s5				# The amoount of elements in a 2d array, including the invalids
			mflo	$s1					# Put that in our final output
			add	$s1, $s1, $s5				# At the end of each row, we add a '99' instruction except the last
			addi	$s1, $s1, -1				# This way of calculating v0 is faster than adding 1 everytime we see one
			move	$s7, $0					# Our loop should initially be 0
			moveLoop:
				move	$a0, $s2			# Load file descriptor
				jal	read_char			# Read the first character
				move	$s3, $v0			# Save the tens digit for later
				move	$a0, $v0			# Prepares to check if move was legal
				jal	get_legality			# Gets the legality of the move
				bgtz	$v0, legalOne			# If our result wasn't negative, we read a character
				addi	$s6, $0 , 1			# FLAGS UP ILLEGAL STUFF HAPPENED
				legalOne:
					move	$a0, $s2		# Load file descriptor
					jal	read_char		# Read the second character
					move	$a0, $v0		# Prepares to check it
					jal	get_legality		# Gets the legality of the move
					bgtz	$v0, legalTwo		# If our result was positive, we read a character
					addi	$s6, $0 , 1		# Hey this was illegal too >:(
				legalTwo:
					beqz	$s6, legal		# The flag was never raised
					addi	$t0, $0 , -1		# This will distinguish it from valid moves
					sb	$t0, 0($s0)		# Store our integer into s0
					addi	$s0, $s0, 1		# Increment to make room the next one
					j	skipBlock		# oops bugfix
					legal:
						move	$a0, $s3	# Load the tens
						move	$a1, $v0	# Load the ones(equal to the ASCII value since it was lega)
						jal	get_integer	# Get the integer value
						sb	$v0, 0($s0)	# Store our integer into s0
						addi	$s0, $s0, 1	# Increment to make room the next oneS
				skipBlock:
					move	$s6, $0			# Reset flag
					addi	$s7, $s7, 1		# Add one to our counter
					bne	$s7, $s4, moveLoop	# If we haven't iterated to column, we haven't finished the row
					addi	$s5, $s5, -1		# Decrement the rows(partly because I wanted to, but also I ran out of saved registers)
					beqz	$s5, loadedMoves	# If we ran out of rows to iterate through, we shouldn't loop anymore
					li	$t0, 99			# Load the 99 instruction
					sb	$t0, 0($s0)		# Store our integer into s0
					addi	$s0, $s0, 1		# Increment to make room the next one
					move	$s7, $0			# Reset the counter
					j	moveLoop		# Go through the next row
	loadedMoves:
		li	$v0, 16						# Loads the syscall to close file with argument a0 already there
		syscall							# Closes the file cause it's the nice thing to do :D
		move	$v0, $s1					# Load the proper output
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		lw	$s4, 20($sp)					# Restores $s4 from stack
		lw	$s5, 24($sp)					# Restores $s5 from stack
		lw	$s6, 28($sp)					# Restores $s6 from stack
		lw	$s7, 32($sp)					# Restores $s7 from stack
		addi	$sp, $sp, 36					# Deallocate stack space
		jr	$ra

play_game: #Given a movefile and board, we will play the game out
#a0 contains the filename to read the moves
#a1 contains the filename to read the board
#a2 contains a pointer to a gameState
#a3 contains a pointer to a moves array
#a4 contains the number of moves to execute. We may go under it, but may never go over it; not actually a4 but :)
#v0 will contain -1 if there was an error reading files; 0 if nobody won; 1 if player 1 won; 2 if player 2 won
#v1 will contain -1 if there was an error reading files; otherwise it will have the valid moves executed
	lw	$t0, 0($sp)						# Load the number of moves to execute
	addi	$sp, $sp, -36						# Allocate space on the stack to store $ra and some saved registers
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack(save GameState)
	sw	$s1, 8($sp)						# Saves $s1 on stack(save moves array)
	sw	$s2, 12($sp)						# Saves $s2 on stack(will save a variable to store things between function calls)
	sw	$s3, 16($sp)						# Saves $s3 on stack(will save the total number of moves to execute)
	sw	$s4, 20($sp)						# Saves $s4 on stack(will save v0)
	sw	$s5, 24($sp)						# Saves $s5 on stack(will save v1//didnt really use it well)
	sw	$s6, 28($sp)						# Saves $s6 on stack(will save a counter for the number of moves we executed)
	sw	$s7, 32($sp)						# Saves $s7 on stack(will save our current move)
	move	$s0, $a2						# Save the GameState
	move	$s1, $a3						# Save the moves array
	move	$s2, $a1						# Store the board filename for now; may store other things
	move	$s3, $t0						# Move the moves to execute into s3
	move	$s4, $0							# Assumes no one will win unless told otherwise
	move	$s6, $0							# Initializes the moves we executed so far
	move	$a1, $a0						# Load the filename for load_moves
	move	$a0, $s1						# Load the moves array for load_moves
	jal	load_moves						# Load the moves into the moves array
	bltz	$v0, errorFound						# If we had trouble opening the file, return an error
	move	$a0, $s0						# Load the game state
	move	$a1, $s2						# Load the board filename, s2 is now a free agent
	move	$s2, $v0						# Use s2 to now store the number of moves in moves array
	jal	load_game						# Load the game; the output is only used for errors since we can find pockets easily
	blez	$v0, errorFound						# If the file was invalid, both v0 is -1; if there were too many stones v0 is 0
	blez	$v0, errorFound						# Invalid file means v0 is -1; too  many pockets means v0 is 0
	blez	$s3, hardCode						# Case where num_moves_to_execute is 0/negative
	playLoop:
	 	beq	$s6, $s3, breakLoop				# We have ran as many moves as we are allowed to execute; our assumption of no winner was accurate
	 	beqz	$s2, breakLoop					# We have ran as many moves as are in the array; our assumption of no winner was accurate
		lb	$v0, 0($s1)					# Load the move
		addi	$s1, $s1, 1					# Read the next move in the array later
		addi	$s2, $s2, -1					# Decrease the moves left in the array
		move	$s7, $v0					# Save the current move
		bltz	$v0, playLoop					# If the move was invalid, we want to skip this loop
		li	$t0, 99						# We want to check if we had a 99 move
		beq	$t0, $v0, ninetyNine				# We had a 99 move
		move	$a0, $s0					# Load state for getting stones in the origin
		lb	$a1, 5($s0)					# The player turn is located in game state
		move	$a2, $v0					# Our move is the origin pocket
		jal	get_pocket					# Get the number of stones in the pocket
		move	$a2, $v0					# That is the distance for verify_move
		move	$a1, $s7					# Load the current move as the origin pocket
		move	$a0, $s0					# Load state for verify move
		jal	verify_move					# Verify if the move was legal or not
		j	notNinetyNine					# We did not get a 99 move so we shouldnt run the next bit
		ninetyNine:
			move	$a2, $v0				# Our distance should be 99, and origin doesn't matter
			move	$a0, $s0				# Load state for verify move
			jal	verify_move				# Verify if the move was legal or not
			addi	$s6, $s6, 1				# Increase the counter of moves we ran
		notNinetyNine:
		li	$t0, 1						# If the move was anything but legal(even if it was 99), we shouldn't execute it
		bne	$v0, $t0, playLoop				# The move was either illegal or was a special 99 move which ran in verify move
		addi	$s6, $s6, 1					# The move was legal so we run it; 99 had this incremented already so it ended the loop
		move	$a0, $s0					# Load state for execute move
		move	$a1, $s7					# Load the current move for execute move
		jal	execute_move_with_steal				# Run the current move with steal automatically being run if applicable
		move	$a0, $s0					# Load state to see if the game is over
		jal	check_row					# Check if any rows are empty
		bnez	$v0, gameOver					# If a row was empty(v0=1), we should not run any more moves
		j	playLoop					# The game wasn't over after the steal, so we should run the next move
	gameOver:	
		move	$s4, $v1					# If the game was over(from check_row), v1 will have the winner
	breakLoop:
		move	$s5, $s6					# Load the number of moves we executed
		j	playedGame					# We didn't get any errors
	errorFound:
		li	$s4, -1						# We ran into an error
		li	$s5, -1						# We ran into an error		
	playedGame:
		move	$v0, $s4					# Restore $v0
		move	$v1, $s5					# Restore $v1
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		lw	$s4, 20($sp)					# Restores $s4 from stack
		lw	$s5, 24($sp)					# Restores $s5 from stack
		lw	$s6, 28($sp)					# Restores $s6 from stack
		lw	$s7, 32($sp)					# Restores $s7 from stack
		addi	$sp, $sp, 36					# Deallocate stack space
		jr	$ra
	hardCode: #Hey it was the last case, can you blame me?
		move	$a0, $s0					# Load state to see if the game is over
		jal	check_row					# Check if any rows are empty
		bnez	$v0, gameOver					# If v0 is 1, aka not zero, aka game over, the winning player depends on v1
		li	$s4, 0						# Otherwise, the game still belongs to anyone
		j	playedGame					# s5 is already set to 0 moves executed

print_board: #Print the board given the state, will not return anything
#a0 contains the GameState
	addi	$sp, $sp, -12						# Allocate space on the stack to store $ra and $s0
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack (Will store GameState)
	sw	$s1, 8($sp)						# Saves $s1 on stack (Will save the amount of pockets)
	move	$s0, $a0						# Save GameState
	li	$v0, 11							# Sycall to print characters
	lb	$a0, 6($s0)						# Load the top mancala tens digit
	syscall								# Print it
	lb	$a0, 7($s0)						# Load the top mancala ones digit
	syscall								# Print it
	li	$a0, '\n'						# Load the newline
	syscall								# Print it
	lb	$a0, 0($s0)						# Get the integer value of bot mancala
	jal	get_ascii						# Get the ASCII representation
	move	$a0, $v0						# Print the tens digit
	li	$v0, 11							# Reload the syscll to print
	syscall								# Print the tens digit
	move	$a0, $v1						# Load the ones digit
	syscall								# Print it
	li	$a0, '\n'						# Load the newline
	syscall								# Print it
	lb	$s1, 2($s0)						# Get the amount of pocckets
	move	$t0, $s1						# Have a counter for the top row
	addi	$s0, $s0, 8						# Start with the top row
	printTop:
		lb	$a0, 0($s0)					# Get the tens digit of the character
		syscall							# Print it
		lb	$a0, 1($s0)					# Get the ones digit of the character
		syscall							# Print it
		addi	$s0, $s0, 2					# Move to the next pocket
		addi	$t0, $t0, -1					# Decrement the counter
		bnez	$t0, printTop					# As long as there's remaining pockets, we print
	li	$a0, '\n'						# Load the newline
	syscall								# Print it
	move	$t0, $s1						# Reset the counter for the bot row
	printBot:
		lb	$a0, 0($s0)					# Get the tens digit of the character
		syscall							# Print it
		lb	$a0, 1($s0)					# Get the ones digit of the character
		syscall							# Print it
		addi	$s0, $s0, 2					# Move to the next pocket
		addi	$t0, $t0, -1					# Decrement the counter
		bnez	$t0, printBot					# As long as there's remaining pockets, we print
	li	$a0, '\n'						# Load the newline
	syscall								# Print it
	lw	$ra, 0($sp)						# Restores $ra from stack
	lw	$s0, 4($sp)						# Restores $s0 from stack
	lw	$s1, 8($sp)						# Restores $s1 from stack
	addi	$sp, $sp, 12						# Deallocate stack space
	jr	$ra

write_board: #Write the board to a file called 'output.txt'
#a0 contains the gameState
#v0 will contain 1 if the writing was successful, -1 if we found an error
	addi	$sp, $sp, -32						# Make space on the stack for 'output.txt'
	li	$t0, 'o'						# Load character for 'o'
	li	$t1, 'u'						# Load character for 'u'
	li	$t2, 't'						# Load character for 't'
	li	$t3, 'p'						# Load character for 'p'
	li	$t4, '.'						# Load character for '.'
	li	$t5, 'x'						# Load character for 'x'
	sb	$t0, 0($sp)						# o
	sb	$t1, 1($sp)						# u
	sb	$t2, 2($sp)						# t
	sb	$t3, 3($sp)						# p
	sb	$t1, 4($sp)						# u
	sb	$t2, 5($sp)						# t
	sb	$t4, 6($sp)						# .
	sb	$t2, 7($sp)						# t
	sb	$t5, 8($sp)						# x
	sb	$t2, 9($sp)						# t
	sb	$0 , 10($sp)						# NULL TERMINATOR; lead next one blank I geuss
	sw	$ra, 12($sp)						# Store $ra on the stack
	sw	$s0, 16($sp)						# Store $s0 on the stack(will store game state)
	sw	$s1, 20($sp)						# Store $s1 on the stack(will store number of pockets)
	sw	$s2, 24($sp)						# Store $s2 on the stack(will store file descriptor)
	sw	$s3, 28($sp)						# Store $s3 on the stack(will store position in gamestate, redundant but makes coding easier :D)
	move	$s0, $a0						# Save game state
	lb	$s1, 2($s0)						# Save the amount of pocckets
	li	$v0, 13							# Load syscall for opening files
	move	$a0, $sp						# Use the file 'output.txt' to write to
	li	$a1, 1							# Load the flag for writing
	li	$a2, 0							# Ignore the mode
	syscall								# Open the file
	bltz	$v0, error						# A negative v0 means we couldn't open the file
	move	$s2, $v0						# Save the file descriptor
	addi	$sp, $sp, -1						# We want to write our file backwards
	li	$t0, '\n'						# Load a newline to store
	sb	$t0, 0($sp)						# Store the newline
	sll	$t1, $s1, 2						# Get 4x the pockets
	addi	$s3, $t1, 6						# Basically to find the proper offset to get the last pocket
	add	$s3, $s3, $s0						# Add the original position to get the position
	move	$t0, $s1						# We want to read all the pockets in the bottom row
	writeBot:
		lb	$t1, 0($s3)					# Get the tens digit
		lb	$t2, 1($s3)					# Get the ones digit
		addi	$sp, $sp, -2					# Make space to write them on the stack
		addi	$s3, $s3, -2					# Then move on to read the next pocket
		sb	$t1, 0($sp)					# Store the tens
		sb	$t2, 1($sp)					# Store the one
		addi	$t0, $t0, -1					# Decremenet our counter
		bnez	$t0, writeBot					# As long as there's remaining pockets, we will store it in the stack
	addi	$sp, $sp, -1						# We want to write our file backwards
	li	$t0, '\n'						# Load a newline to store
	sb	$t0, 0($sp)						# Store the newline
	move	$t0, $s1						# Reset our counter
	writeTop:
		lb	$t1, 0($s3)					# Get the tens digit
		lb	$t2, 1($s3)					# Get the ones digit
		addi	$sp, $sp, -2					# Make space to write them on the stack
		addi	$s3, $s3, -2					# Then move on to read the next pocket
		sb	$t1, 0($sp)					# Store the tens
		sb	$t2, 1($sp)					# Store the one
		addi	$t0, $t0, -1					# Decremenet our counter
		bnez	$t0, writeTop					# As long as there's remaining pockets, we will store it in the stack
	addi	$sp, $sp, -1						# We want to write our file backwards
	li	$t0, '\n'						# Load a newline to store
	sb	$t0, 0($sp)						# Store the newline
	lb	$a0, 0($s0)						# Could have manually reset s3, but w.e. Get bot mancala
	jal	get_ascii						# Get the ASCII
	addi	$sp, $sp, -2						# We want to write our file backwards
		sb	$v0, 0($sp)					# Store the tens
		sb	$v1, 1($sp)					# Store the one
	addi	$sp, $sp, -1						# We want to write our file backwards
	li	$t0, '\n'						# Load a newline to store
	sb	$t0, 0($sp)						# Store the newline
	addi	$sp, $sp, -2						# We want to write our file backwards
	lb	$a0, 1($s0)						# Get top mancala
	jal	get_ascii						# Get the ASCII
		sb	$v0, 0($sp)					# Store the tens
		sb	$v1, 1($sp)					# Store the one
	move	$a1, $sp						# Load the address of our board to print
	sll	$t0, $s1, 2						# Multiply pockets by 4(2 rows of pocekts * 2 characters)
	addi	$t0, $t0, 8						# We also add 4 to get the total characters we wrote(4 for mancala; 4 for newlines)
	move	$a2, $t0						# Our buffer length is the characters we wrote
	add	$sp, $sp, $t0						# We finished writing with that space, so de-allocate it
	li	$v0, 15							# Load syscall for writing to files
	move	$a0, $s2						# Load the file descriptor
	syscall								# Write to the file
	bltz	$v0, error						# A negative v0 means we couldn't write to the file
	li	$v0, 16							# Load syscall for closing files
	move	$a0, $s2						# Load file descriptor
	syscall								# Close the file
	li	$v0, 1							# Sucessfully opened and wrote to the file
	j	written							# There were no errors on our way
	error:
		li	$v0, -1						# We could not open a file to write to
	written:
		lw	$ra, 12($sp)					# Restore $ra
		lw	$s0, 16($sp)					# Restore $s0
		lw	$s1, 20($sp)					# Restore $s1
		lw	$s2, 24($sp)					# Restore $s2
		lw	$s3, 28($sp)					# Restore $s3
		addi	$sp, $sp, 32					# Restore stack pointer
		jr	$ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

# HELPER FUNCTIONS

read_char: #Assuming that files are formatted properly, and we won't be thrown any invalid input
#a0 contains the file descriptor, will not be touched so we can reuse a0
#v0 will contain the character read or the newline
	addi	$sp, $sp, -4						# Allocate space on the stack to store our character read
	move	$a1, $sp						# We will use the stack to store the input read
	li	$a2, 1							# We only want to read 1 byte at a time
	li	$t1, '\r'						# Loads the part of the newline symbol in Windows
	li	$t2, '\n'						# Loads newline symbol for Windows/Linux
	reread:
		li	$v0, 14						# Loads the syscall for reading from a file
		syscall							# Reads the file, will change v0 to number of characters read
		lbu	$t0, 0($a1) 					# Looks in the address of where we read the character
		beq	$t0, $t1, reread				# If we read a \r, we should pre-emptively read the \n
		beq	$v0, $0 , fileEnd				# If the output was 0(end of file), we should return a end of line//newline
		move	$v0, $t0					# Move our result into function output
		addi	$sp, $sp, 4					# Deallocate stack space
		jr	$ra
	fileEnd:
		li	$v0, '\n'					# If we reach the end of the file, we should return newline since we'll treat it as end of line
		addi	$sp, $sp, 4					# Deallocate stack space
		jr	$ra

get_index: #Simple way to get the proper index since pockets are not spaced by 1 byte
#a0 contains the address of the GameState
#a1 contains whose the player whose being affected
#a2 contains the distance
#v0 will contain the address that is being affected; -1 if the player or distance is invalid
	addi	$v0, $0 , -1						# Assumes the input has some error until we update it
	bltz	$a2, gotIndex						# If our input is negative, we should return an error
	lbu	$t0, 2($a0)						# Could load from 3($a0) as well to get either number of pockets
	bge	$a2, $t0, gotIndex					# We are trying to go further than the max number of pockets(0-index)
	li	$t1, 'T'						# Loads the ASCII for 'T'
	li	$t2, 'B'						# Loads the ASCII for 'B'
	addi	$a0, $a0, 8						# The first element in top row is located at the 8th position
	beq	$a1, $t1, getTopRow					# If the player is 'T'op, we want to check the top row
	bne	$a1, $t2, gotIndex					# If the player isn't 'B'ot and wasn't 'T'op, we should return -1
	
	sll	$t0, $t0, 2						# To find the index of the bottom row, we're gonna need the times 4
	sll	$a2, $a2, 1						# Basically, we have to fix the base address by adding pockets(2x since each character is two bytes)
	sub	$a2, $t0, $a2						# Then, we have to get the proper index of the bottom row, which is "reverse" of the norm
	addi	$a2, $a2, -2						# We have to subtract pockets by the distance(and 1 since pockets is "more" than the max index)
	add	$v0, $a0, $a2						# Then we will have the right index to retrieve our pocket from
	j	gotIndex						# We finished getting the pockets
	getTopRow:
		sll	$a2, $a2, 1					# We want to move twice the distance since each character is two bytes
		add	$v0, $a0, $a2					# Base of top row + distance = element at the index we want
	gotIndex:
		jr	$ra

get_ascii: #Convert an two digit integer to it's two ASCII equivalent
#a0 contains the integer value; will be one or two digits
#v0 will contain the tens digit in ASCII (cause making the halfword is too much brainpower and I don't neeeed to do it)
#v1 will contain the ones digit in ASCII (or I would rather write this over shifting it and adding/and them and return that to manipulate)
	move	$v0, $0							# We will store the tens digit here
	addi	$t0, $0	, 10						# We will store the ten here
	loop:
		blt	$a0, $t0, loopEnd				# If our number is less than 10, our ones are done
		sub	$a0, $a0, $t0					# Subtract 10 until we reach single digits to get the tens place
		addi	$v0, $v0, 1					# Increase tens by 1 for every 10 we lose
		j	loop						# loOoOop
	loopEnd:
		addi	$v0, $v0, 48					# Get the ASCII value of the tens digit
		addi	$v1, $a0, 48					# Get the ASCII value of the ones digit
		jr	$ra

get_integer: #Convert two ASCII characters into its corresponding integer value
#a0 contains the tens digit of the ASCII
#a1 contains the ones digit of the ASCII
#v0 will contain the integer value
	addi	$a0, $a0, -48						# Get numerical value of the tens digit
	addi	$a1, $a1, -48						# Get numerical value of the ones digit
	addi	$t0, $0 , 10						# Multiply the tens digit by 10
	mult	$a0, $t0						# Done
	mflo	$v0							# Store the value in our output
	add	$v0, $v0, $a1						# Add the ones digit
	jr	$ra

get_legality: #Check the legality of an ASCII character
#a0 contains the ASCII character
#v0 will contain the character if it is legal, -1 otherwise
	addi	$v0, $0 , -1						# Assume input is invalid
	li	$t0, '0'						# Load ASCII for '0'
	li	$t1, '9'						# Load ASCII for '9'
	bgt	$a0, $t1, legalityChecked				# If the ASCII is greater than 9, it wasn't an digit
	blt	$a0, $t0, legalityChecked				# If the ASCII is less than 0, it wasn't a digit
	move	$v0, $a0						# Since it was valid, we should return the ASCII	
	legalityChecked:
		jr	$ra


execute_move_with_steal: #IM SORRY I DIDNT WANT TO DO THE MOD MATH(i think its mod math anyway)
#a0 contains game state
#a1 contains origin pocket, the distance from the mancala of the current player
#v0 will contain the number of stones added to the mancala
#v1 will contain a number based on where the last stone was dropped; 2 for mancala, 1 for anywhere in the players row and was empty before, 0 anywhere else
	addi	$sp, $sp, -36						# Allocate space on the stack to store $ra and $s0
	sw	$ra, 0($sp)						# Saves $ra on stack
	sw	$s0, 4($sp)						# Saves $s0 on stack (Will save v0)
	sw	$s1, 8($sp)						# Saves $s1 on stack (Will save v1)
	sw	$s2, 12($sp)						# Saves $s2 on stack (Will save player turn)
	sw	$s3, 16($sp)						# Saves $s3 on stack (Will save index of pocket we are visiting)
	sw	$s4, 20($sp)						# Saves $s4 on stack (Will save total stones)
	sw	$s5, 24($sp)						# Saves $s5 on stack (Will save the index; cause I'm too lazy to check for dynamic positions)
	sw	$s6, 28($sp)						# Saves $s6 on stack (Will save gamestate cause I'm too lazy; see above)
	sw	$s7, 32($sp)						# Saves $s7 on stack (Will save amount of stones; 'when in doubt add another saved register' -jack)
	move	$s0, $0							# Initialize stones added to mancala as 0; s1 will be set
	move	$s5, $a1						# Save origin pocket as index for later :)
	move	$s6, $a0						# Save gameState for later
	lb	$t0, 4($a0)						# Since the move will be valid, we will pre-emptively increase the move count
	addi	$t0, $t0, 1						# Note that the '99' move can't be run from here
	sb	$t0, 4($a0)						# Last 2 lines of code with this are just loading, increasing and storing the moves
	lb	$s2, 5($a0)						# Get the current player turn
	move	$a2, $a1						# Move the origin pocket to the distance argument
	move	$a1, $s2						# Load the parameter player turn
	jal	get_index						# Get the index of the origin pocket
	move	$s3, $v0						# Save it for later use
	lb	$a0, 0($v0)						# Load the tens place
	lb	$a1, 1($v0)						# Load the ones place
	jal	get_integer						# Get the integer value of the pocket
	move	$s4, $v0						# Store the amount of stones we picked up
	move	$a0, $s6						# Get the game state into a0
	move	$a1, $s2						# Prepares to set origin to zero
	move	$a2, $s5						# This is because we picked it up; so it should have no stones
	move	$a3, $0							# Now we can redistribute those stones
	jal	set_pocket						# Finally remembered to use previous functions
	li	$t0, 'T'						# Load the ASCII for 'T'op
	beq	$s2, $t0, executeTopPlus				# We will move our stones skipping the origin at the top
	executeBotPlus:
		beqz	$s5, mancalaCheckBotPlus			# idk bugfix time
		addi	$s3, $s3, 2					# Move to the next spot in a counter-clockwise position
		addi	$s4, $s4, -1					# Drop a stone off at this point
		addi	$s5, $s5, -1					# We are moving closer to our mancala so the index drops
		lb	$a0, 0($s3)					# Load the tens stone in the new pocket for get_integer
		lb	$a1, 1($s3)					# Load the ones stone in the new pocket for get_integer
		jal	get_integer					# Get the integer value
		addi	$t0, $v0, 1					# Increment it by 1
		move	$s7, $t0					# Save the integer value for later
		move	$a0, $t0					# Load the integer value for get_ascii
		jal	get_ascii					# Get the ASCII values
		sb	$v0, 0($s3)					# Store it back into the new position
		sb	$v1, 1($s3)					# Store it back into the new position
		bnez	$s4, botStonePlus				# If we still have stones, we don't need to do much more
		li	$t1, 'B'					# If we ran out of stones, we want to check if it is 'B'ot turn
		bne	$s2, $t1, notBotTurnPlus			# Either way, our last stone was dropped off on the 'B'ot row
		addi	$t1, $0 , 1					# If the pocket was empty; it should now have one stone
		beq	$s7, $t1, emptyPocketBotPlus			# Register s7 has the stones in the new pocket; so we see if it was empty
		move	$s1, $0						# This means it was 'B'ot turn and the pocket we dropped into was not empty at bot
		li	$s3, 'T'					# It was bot turn, but our move means it's now top's turn; saved in s3 because we want to keep original turn
		j	executedPlus					# Our move is executed
		emptyPocketBotPlus:
			addi	$s1, $0 , 1				# This means it was 'B'ot turn and the pocket we dropped into was empty at bot
			li	$s3, 'T'				# It was bot turn, but our move means it's now top's turn; saved in s3 because we want to keep original turn
			sb	$s3, 5($s6)				# Store the player turn early to steal
			move	$a1, $s5				# Register s3 was where we last dropped our stone
			move	$a0, $s6				# Load GameState
			jal	steal					# Commence the steal
			j	executedPlus				# Our move is executed
		notBotTurnPlus:
			move	$s1, $0					# This means that it was 'T'op turn and we dropped it off at bot(anywhere else)
			li	$s3, 'B'				# It was top turn, but our move means it's now bot's turn; saved in s3 because we want to keep original turn
			j	executedPlus				# Our move is executed
		botStonePlus:
			beqz	$s5, mancalaCheckBotPlus		# If we just dropped our last stone adjacent to a mancala, we should check it out
			j	executeBotPlus				# Otherwise, we should stay in our row
	executeTopPlus:
		beqz	$s5, mancalaCheckTopPlus			# idk bugfix time
		addi	$s3, $s3, -2					# Move to the next spot in a counter-clockwise position
		addi	$s4, $s4, -1					# Drop a stone off at this point
		addi	$s5, $s5, -1					# We are moving closer to our mancala so the index drops
		lb	$a0, 0($s3)					# Load the tens stone in the new pocket for get_integer
		lb	$a1, 1($s3)					# Load the ones stone in the new pocket for get_integer
		jal	get_integer					# Get the integer value
		addi	$t0, $v0, 1					# Increment it by 1
		move	$s7, $t0					# Save the integer value for later
		move	$a0, $t0					# Load the integer value for get_ascii
		jal	get_ascii					# Get the ASCII values
		sb	$v0, 0($s3)					# Store it back into the new position
		sb	$v1, 1($s3)					# Store it back into the new position
		bnez	$s4, topStonePlus				# If we still have stones, we don't need to do much more
		li	$t1, 'T'					# If we ran out of stones, we want to check if it is 'T'op turn
		bne	$s2, $t1, notTopTurnPlus			# Either way, our last stone was dropped off on the 'T'op row
		addi	$t1, $0 , 1					# If the pocket was empty; it should now have one stone
		beq	$s7, $t1, emptyPocketTopPlus			# Register s7 has the stones in the new pocket; so we see if it was empty
		move	$s1, $0						# This means it was 'T'op turn and the pocket we dropped into was not empty at top
		li	$s3, 'B'					# It was top turn, but our move means it's now bot's turn; saved in s3 because we want to keep original turn
		j	executedPlus					# Our move is executed
		emptyPocketTopPlus:
			addi	$s1, $0 , 1				# This means it was 'T'op turn and the pocket we dropped into was empty at top
			li	$s3, 'B'				# It was top turn, but our move means it's now bot's turn; saved in s3 because we want to keep original turn
			sb	$s3, 5($s6)				# Store the player turn early to steal
			move	$a1, $s5				# Register s3 was where we last dropped our stone
			move	$a0, $s6				# Load GameState
			jal	steal					# Commence the steal			
			j	executedPlus				# Our move is executed
		notTopTurnPlus:
			move	$s1, $0					# This means that it was 'B'ot turn and we dropped it off at top(anywhere else)
			li	$s3, 'T'				# It was bot turn, but our move means it's now top's turn; saved in s3 because we want to keep original turn
			j	executedPlus				# Our move is executed
		topStonePlus:
			beqz	$s5, mancalaCheckTopPlus		# If we just dropped our last stone adjacent to a mancala, we should check it out
			j	executeTopPlus				# Otherwise, we should stay in our row
	mancalaCheckBotPlus:
		li	$t0, 'B'					# We want to see if it is curently 'B'ot's turn, so we can add to the mancala
		bne	$s2, $t0, botCheckedPlus			# It isn't bot's turn, so we can't add to it's mancala
		addi	$s4, $s4, -1					# Our stones being moved around decreased
		addi	$s0, $s0, 1					# Stones added to the mancala increased
		bnez	$s4, botCheckedPlus				# Check if we dropped our last stone here
		addi	$s1, $0 , 2 					# We dropped our last stone in the bot mancala on bot turn
		li	$s3, 'B'					# We want to keep the turn as bot; saved in s3 because we want to keep original turn
		j	executedPlus					# We executed the move
		botCheckedPlus:
			lb	$s5, 2($s6)				# Get the number of pockets(0-index but execute takes care of that)
			move	$a0, $s6				# Load gamestate for get_index
			li	$a1, 'T'				# We want to get the index for the other row
			addi	$a2, $s5, -1				# We just set the index(maximum) so we use that in our argument
			jal	get_index				# Get the address of the new index
			move	$s3, $v0				# Move that into s3 to keep using
			addi	$s3, $s3, 2				# Idk but it works
			j	executeTopPlus				# We did what we needed to do for bot row, so move on to the top row
	mancalaCheckTopPlus:
		li	$t0, 'T'					# We want to see if it is curently 'T'op's turn, so we can add to the mancala
		bne	$s2, $t0, topCheckedPlus			# It isn't tot's turn, so we can't add to it's mancala
		addi	$s4, $s4, -1					# Our stones being moved around decreased
		addi	$s0, $s0, 1					# Stones added to the mancala increased
		bnez	$s4, topCheckedPlus				# Check if we dropped our last stone here
		addi	$s1, $0 , 2 					# We dropped our last stone in the top mancala on top turn
		li	$s3, 'T'					# We want to keep the turn as top; saved in s3 because we want to keep original turn
		j	executedPlus					# We executed the move
		topCheckedPlus:
			lb	$s5, 2($s6)				# Get the number of pockets(0-index but execute takes care of that)
			move	$a0, $s6				# Load gamestate for get_index
			li	$a1, 'B'				# We want to get the index for the other row
			addi	$a2, $s5, -1				# We just set the index(maximum) so we use that in our argument
			jal	get_index				# Get the address of the new index
			move	$s3, $v0				# Move that into s3 to keep using
			addi	$s3, $s3, -2				# Idk but it works
			j	executeBotPlus				# We did what we needed to do for top row, so move on to the bot row
	executedPlus:
		sb	$s3, 5($s6)					# Store the updated player turn into GameState; move will always be valid so no worries about s3 not being updated
		move	$a0, $s6					# Load gameState for collect_stones
		move	$a1, $s2					# Load the original player turn
		move	$a2, $s0					# Load the amount of stones to add
		jal	collect_stones					# Add the amount of stones in the mancala; if it was zero, no change occurs
		move	$v0, $s0					# Load the output
		move	$v1, $s1					# Load the output
		lw	$ra, 0($sp)					# Restores $ra from stack
		lw	$s0, 4($sp)					# Restores $s0 from stack
		lw	$s1, 8($sp)					# Restores $s1 from stack
		lw	$s2, 12($sp)					# Restores $s2 from stack
		lw	$s3, 16($sp)					# Restores $s3 from stack
		lw	$s4, 20($sp)					# Restores $s4 from stack
		lw	$s5, 24($sp)					# Restores $s5 from stack
		lw	$s6, 28($sp)					# Restores $s6 from stack
		lw	$s7, 32($sp)					# Restores $s7 from stack
		addi	$sp, $sp, 36					# Deallocate stack space
		jr	$ra
