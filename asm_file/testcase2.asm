.data
    a: .word 10
    b: .word 5
    newline: .asciiz "\n"
.text
    main:
    addiu $v0,$zero,0x00000005
    syscall 
    
case1:
# Test Case 1: Calculate the cumulative sum of 1 to a number and check if it's negative
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t0,$zero,$v0 #a
        #li $t1, 0          # Initialize sum to 0
        addiu $t5,$zero,0x00000000
        #li $t2, 1          # Initialize counter to 1
        addiu $t2,$zero,0x00000001
        #li $t5, 0          # Initialize negative flag to 0
        addiu $s7,$zero,0x00000000
        loop1:
            # Check if the number is negative
        	add $t5, $t5, $t2   # Add counter to sum
            addi $t2, $t2, 1    # Increment counter
            # Check if the current number exceeds the given number
        	#bgt $t2, $t0, end_test_case_1
        	slt $at,$t0,$t2
        	bne $at, $zero,end_test_case_1
        	#blt $t0, $zero, set_negative_flag
        	slt $at,$t0,$zero
        	bne $at, $zero,set_negative_flag
        	j loop1   # If negative, go to end_test_case_1
        
        set_negative_flag:
            #li $t3, 1          # Set negative flag to 1
            addiu $s7,$zero,0x00000001
        	addiu $s7,$zero,0x00000000
        	addiu $s7,$zero,0x00000001
        	addiu $s7,$zero,0x00000000
        	addiu $s7,$zero,0x00000001
        	addiu $s7,$zero,0x00000000
        	addiu $s7,$zero,0x00000001
        	addiu $s7,$zero,0x00000000
        	addiu $s7,$zero,0x00000001
        	addiu $s7,$zero,0x00000000
        	addiu $s7,$zero,0x00000001
        	addiu $s7,$zero,0x00000000
        	j loop1
        
        end_test_case_1:
    # Test Case 2,3,4: Recursively calculate the sum 1 to an unsigned number and output stack operations
    addiu $v0,$zero, 5
	syscall
	add $a0, $zero, $v0
    jal calculate_cumulative_sum_recur
    addi $t5,$t9,0
    #addi $t5,$s0,-1
    
    case5:
        # Test Case 5: Addition of signed numbers and check for overflow
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t0,$zero,$v0 #a signed
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t1,$zero,$v0 #b signed
       
        add $t2, $t0, $t1
        add $t3, $t0, $t1
        bne $t2, $t3, overflow_occ
        
        addu $t5,$zero,$t2
        addu $t5,$zero,$t3
        j end_test_case_5

    overflow_occ:
        addiu $s7,$zero,0x00000001
        
    end_test_case_5:
        # Test Case 6: Subtract signed numbers and check for overflow
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t0,$zero,$v0 #a signed
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t1,$zero,$v0 #b signed
        
        sub $t2, $t0, $t1
        sub $t3, $t0, $t1
        bne $t2, $t3, overflow_occ_sub
        
        addu $t5,$zero,$t2
        addu $t5,$zero,$t3
        j end_test_case_6
        
    overflow_occ_sub:
        addiu $s7,$zero,0x00000001
        
    end_test_case_6:
case7:
	# Test Case 7: Multiply signed numbers and output the product
    addiu $v0,$zero, 5
	syscall
	addu $a0, $zero, $v0
	addiu $v0,$zero, 5
	syscall
	addu $a1, $zero, $v0
	addiu $t5,$zero, 0x00000000
   multiply_signed_numbers:
   	beq $a1, $zero, case8   # Exit the loop if multiplier becomes 0
        add $t5, $t5, $a0     # Add multiplicand to the result
        addi $a1, $a1, -1     # Decrement the multiplier by 1
        j multiply_signed_numbers                # Continue the loop
case8:
# Test Case 8: Divide signed numbers and output quotient and remainder
	addiu $v0,$zero, 5
	syscall
	add $a0, $zero, $v0
	addiu $v0,$zero, 5
	syscall
	add $a1, $zero, $v0
	addiu $t5,$zero, 0x00000000
	division_signed_numbers:
   # Subtract divisor from dividend
        sub $a0, $a0, $a1
        # If the result is negative or zero, exit the loop
        slt $t3, $a0, $zero
        addi $t4, $zero, 1
        beq $t4, $t3, exit_division
        # Increment quotient by 1
        addi $t5, $t5, 1
        # Continue the loop
        j division_signed_numbers
exit_division:
	add $a0, $a0, $a1
exit: 	
        #move $a0,$t5 
    	#li $v0,1 #print int
    	#syscall
    	
    	#li $v0, 4
    	#la $a0, newline
    	#syscall
    	
    	#move $a0,$s7 
    	#li $v0,1 #print int
    	#syscall
    	# Exit program
        #li $v0, 10
        addiu $v0,$zero,0x0000000a
        syscall
                
calculate_cumulative_sum_recur:
    addi $sp, $sp, -8     # Reserve space on the stack
    sw $ra, 0($sp)        # Save the return address
    addi $t9,$t9,1
    sw $a0, 4($sp)        # Save the value of 'a', show in case 010
     addi $t7,$a0,0
    addi $t9,$t9,1
    beq $a0, $zero,base_case   # Base case: if 'a' is 0, return 0
    addiu $a0, $a0, -1    # Decrement 'a' by 1 using unsigned immediate value

    jal calculate_cumulative_sum_recur  # Recursive call to calculate the sum of 1 to (a-1)
    lw $a0, 4($sp)        # Restore the value of 'a' case 011
    addi $t8,$a0,0
    addi $t9,$t9,1
    add $s0, $s0, $a0     # Add 'a' to the sum

base_case:
    lw $ra, 0($sp)        # Restore the return address
    addi $t9,$t9,1
    addi $sp, $sp, 8      # Release space on the stack
    jr $ra                # Return to the calling function


addiu $v0,$zero,0x00000005
   	syscall
    #move $t5, $v0  # Store the number in $t0
    addu $t5,$zero,$v0 #a
    #move $t7 $v0  # Store the number in $t7
    addu $t7,$zero,$v0 #a
    
    #li $t0,0 #sum
    addiu $t0,$zero,0x00000000
    #li $t1,1#increment
    addiu $t1,$zero,0x00000001
    #li $t2,0 #flow times
    addiu $t2,$zero,0x00000000
    #li $t3,0 #flow times
    addiu $t3,$zero,0x00000000
    
recur_sum_1:
    add $t0,$t0,$t1 #sum
    addu $t5,$zero,$t0
    addi $t1,$t1,1
    addu $t5,$zero,$t1
    
    addi $t2,$t2,1
    addi $t3,$t3,2 #total
    
    #move $t5,$t0 #current sum, parameters
    
    #bleu $t1,$t7,recur_sum #t1<=t7
    sltu $at,$t7,$t1
    beq $at,$zero,recur_sum_1
	#add $t0,$t0,$t1 #sum
    
	#move $t5,$t0	
    addu $t5,$zero,$t0 #sum
    
    subi $t2,$t2,1
    subi $t3,$t3,2 #total
    
    #move $t5,$t2	
    addu $t5,$zero,$t2 #flow
    
    #move $t5,$t3	
    addu $t5,$zero,$t3 #a