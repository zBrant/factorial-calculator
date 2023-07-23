.data

line: .asciiz "-------------------------\n"
ProgramName: .asciiz "Factorial Calculator\n"
message: .asciiz "Enter a number to calculate its factorial: "
result: .asciiz "Result: "

.text

# Code 4 for the syscall to print a string
li $v0, 4
la $a0, line
syscall

li $v0, 4
la $a0, ProgramName
syscall

li $v0, 4
la $a0, line
syscall

li $v0, 4
la $a0, message
syscall

# Code 5 for the syscall to read an integer
li $v0, 5
syscall

move $s0, $v0     # Move the user input to s0

li $v0, 4
la $a0, result
syscall

move $a0, $s0     # Move the user input to the a0 register (passing it as an argument to the fatorialCalc function)
jal fatorialCalc

move $a0, $v0
li $v0, 1       # Syscall to print an integer
syscall

li $v0, 10      # Syscall for exit
syscall

fatorialCalc:
    sub $sp, $sp, 8     # Allocate space on the stack (2*4 = 8 bytes)
    sw $ra, 4($sp)      # Save the return address
    sw $a0, 0($sp)      # Save the argument (n) address

    # Check if the argument (n) is less than 1
    slti $t0, $a0, 1    # (argument < 1) ? t0 = 1 : t0 = 0
    beq $t0, $zero, else    # If t0 == 0, go to "else" (argument >= 1), otherwise continue

    li $v0, 1       # Save 1 in v0 to return 1 (base case)
    add $sp, $sp, 8     # Deallocate space on the stack
    jr $ra         # Return

else:
    sub $a0, $a0, 1     # Subtract 1 from the argument (n - 1)
    jal fatorialCalc     # Call the function recursively with (n - 1) and update the return address to the next instruction of this "function"

    # Return point of the recursive function call
    lw $a0, 0($sp)      # Restore the argument passed, which was saved on the stack
    lw $ra, 4($sp)      # Restore the return address, which was also saved on the stack
    add $sp, $sp, 8     # Deallocate space on the stack

    mul $v0, $a0, $v0   # Multiply n (argument) by fatorialCalc(n - 1)
    jr $ra             

