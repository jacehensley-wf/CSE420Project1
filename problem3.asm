# This is file is assemble written for the following C Program:

# int  sum  =  0;  int  *sump  =  &sum;
# int  a[10];
# void  PSum(int  *s,  int  *e)
# {
#   *s  +=  *e;
# }
# int  main()
# {
#   for  (int  i=0;  i<10;  i++)
#   {
#    a[i]  = 3(i+1);
#   }
#   for  (int  i=0;  i<10;  i++)
#   {
#     PSum(sump,  a+i);
#   }
# printf("?sum  =  %d\n"?,  sum);
# }

.data
array: 		.word 	0:10
sum:		.word	0
strResult:	.asciiz	"sum = "
strCR:		.asciiz "\n"

.text
		.globl 	main
		
main:		#add $sp, $sp, 4		# Make room on the stack for local variable sum
		
		la $s0, sum		# Load the address of sum in $s0, AKA sump
		la $s1, array		# Load the address of array into $s1
		move $s2, $zero		# $t0 = i = 0
		li $t1, 4		# This will be the address offset added to the array address
		li $t2, 10		# This is the reference value for the for loops
		li $t3, 3		# This value will be used to multiply (i+1)
		move $a0, $s1		# $a0 will help with iterating over the array
		
first_for:	bge $s2, $t2, end_first_for	# Break from the for loop if i = 10
		addi $t4, $s2, 1	# Add 1 to intermediate value
		mul $t4, $t4, $t3	# $t4 = 3(i+1)
		sw $t4, ($a0)		# Store 3(i+1) at the next address
		add $a0, $a0, $t1	# Add the address offset to a0 for next iteration
		addi $s2, $s2, 1	# Increment i
		and $t4, $t4, $zero	# Clear $t4 for next iteration
		j first_for		# Jump back to beginning of loop
		
		
end_first_for:	move $s2, $zero		# Reset i variable
		move $a0, $s1		# $a0 will help with iterating over the array again
		
second_for:	bge $s2, $t2, end_second_for	# Break from the for loop if i = 10
		jal psum		# Jump to psum function
		addi $s2, $s2, 1	# Increment i
		j second_for		# Jump back to beginning of loop
		
end_second_for:	# Print 'sum = '
		li $v0, 4   		# Syscall number 4 will print string whose address is in $a0       
		la $a0, strResult	# Load address of the string
		syscall			# Actually print the string
		
		# Print value of sum
		li $v0, 1		# Syscall 5 will print an integer
		lw $a0, 0($s0)		# $s0 is pointing to sum AKA sump
		syscall			# Make the syscall to print
		
		# Print a newline
		li $v0, 4   		# Syscall number 4 will print string whose address is in $a0       
		la $a0, strCR		# Load address of the string
		syscall			# Make the syscall to print
		
		# Exit the program
		li $v0, 10		# Load $v0 to exit
		syscall

psum:		add $sp, $sp, 4		# Make room on the stack for return address
		sw $ra, 0($sp)		# Save the return address on the stack
		li $t0, 4		# Will be used to multiply i to get address offset
		mul $t0, $s2, $t0	# offset = i * 4
		add $a1, $t0, $s1	# $a1 = a+i
		lw $t0, ($a1)		# Load the value at that index
		lw $t1, ($s0)		# Load the value of sump
		add $t1, $t1, $t0	# Add value @ sump and value @ a+i
		sw $t1, ($s0)		# Store value of sump back 
		lw $ra, 0($sp)		# Load the return address
		add $sp, $sp, -4	# Clean up stack
		jr $ra
		
		
