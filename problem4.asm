#
# Assembly for this recursive C function:
# int fix(int  i,  int x)  //  assume  i  >  0,  x  >  0  
# {  
#  if  (x>0)  
#    return  fix(i,x-1)+1;  
#  else  if  (i>0)  
#    return  fix(i-1,  i-1)+5;  
#  else
#    return 1;  
# }
  
# Note: The  values  for  i,  and  x  are  user  inputs  to  
# the  program,  and  provision  has  to  be  made  to  
# receive  the  same  from  the user.  You  may  set  your 
# upper-bounds  for  the  values  input  for  these  variables.

.data
strPrompti:	 .asciiz "Enter the value of `i`:" 
strPromptx: 	 .asciiz "Enter the value of `x`:" 
strFix:		 .asciiz "Fixed i and x = " 
strCR:		 .asciiz "\n"

.text
		.globl main

main:
		# Prompt user for the value of `i`
		li $v0, 4   			# syscall number 4 will print string whose address is in $a0       
		la $a0, strPrompti      	# "load address" of the string
		syscall     			# actually print the string
		
		# Now read in the value for `i`
		li $v0, 5      			# syscall number 5 will read an int
		syscall        			# actually read the int
		move $s0, $v0  			# save result in $s0 for later
		
		# Prompt user for the value of `x`
		li $v0, 4      			# syscall number 4 will print string whose address is in $a0   
		la $a0, strPromptx      	# "load address" of the string
		syscall        			# actually print the string

		# Now read in the value for `x`
		li $v0, 5      			# syscall number 5 will read an int
		syscall        			# actually read the int
		move $s1, $v0  			# save result in $s1 for later
		and $v0, $v0, $zero		# clear the $v0 register
		
		jal fix				# $v0 contains the final result
		move $t0, $v0			# Move final result into $t0
		
		# Print strFix
		li $v0, 4			# syscall number 4 will print string whose address is in $a0
		la $a0, strFix			# "load address" of the string
		syscall
		
		# Print the result
		li $v0, 1			# We will be printing an integer
		la $a0, ($t0)			# Put the result integer in $a0
		syscall				# Print the integer
		
		# Print a newLine
		li $v0, 4			# We will be printing a character
		la $a0, strCR			# Load $a0 with CR
		syscall
		
		# Exit
		li $v0, 10  			# Syscall number 10 is to terminate the program
		syscall     			# exit now
		
fix:		add $sp, $sp, -4 		# Make room for return address
		sw $ra, 0($sp)			# Put the return address on the stack
		bgt $s1, $zero, xGreater	# Branch if x>0
		bgt $s0, $zero, iGreater	# Branch if i>0
		addu  $v0, $v0, 1		# Else add 1 to $v0
		lw $ra, 0($sp)			# Restore return address
		add $sp, $sp, 4			# Clean up the stack
		jr $ra				# Jump to the return address
		
xGreater:	addi $v0, $v0, 1		# Add 1 to the final result
		subi $s1, $s1, 1		# Subtract 1 from second parameter
		add $sp, $sp, 4			# Clean up the stack
		j fix				# Call fix with new paramters
		
iGreater:	addi $v0, $v0, 5		# Add 5 to final result
		subi $t0, $s0, 1		# Subtract 1 from first parameter
		move $s0, $t0			# Set i = i-1
		move $s1, $t0			# Set x = i-1
		add $sp, $sp, 4			# Clean up the stack
		j fix
		

		
		
