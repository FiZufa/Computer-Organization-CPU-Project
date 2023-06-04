.data
    a: .word 8
    b: .word 5
    c: .word 1
    newline: .asciiz "\n"
    
.text
    main:
    	# Read input number
    #li $v0, 5 read integer
    addiu $v0,$zero,0x00000005
    syscall 
    
        beq $v0,$zero,case1
    	addi $at,$zero,0x00000001
    	beq $v0,$at,case2
    	addi $at,$zero,0x00000002
    	beq $v0,$at,case3
    	addi $at,$zero,0x00000003
    	beq $v0,$at,case4
    	addi $at,$zero,0x00000004
    	beq $v0,$at,case5
    	addi $at,$zero,0x00000005
    	beq $v0,$at,case6
    	addi $at,$zero,0x00000006
    	beq $v0,$at,case7
    	addi $at,$zero,0x00000007
    	beq $v0,$at,case8
    	j exit
case1: #can't detect
        # Test Case 1: Whether a number is a power of two
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t5,$zero,$v0 #a
        addu $t0,$zero,$t5
        # Check if the number is a power of 2
    	#li $t1, 1        # Initialize $t1 to 1
	    addiu $t1, $zero, 1
	    and $t2, $t0, $t0   # Copy the number to $t2
    	sub $t2, $t2, $t1   # Subtract 1 from the number
	    and $t2, $t2, $t0   # Bitwise AND the number and the number minus 1
    	beq $t2,$zero, power_of_two #beqz $t2, isPowerOfTwo   # If the result is zero, the number is a power of 2
   
        j not_power_of_two    # If not a power of two, go to end_test_case_1
        
    power_of_two:#0x00000001
        addiu $s7,$zero,0x00000001
        j end_test_case_1
        
    not_power_of_two: #0x0040007c
        addiu $s7,$zero,0x00000000
        
    end_test_case_1: #0x00400080
    	j exit
case2:
        # Test Case 2: Whether a is an odd number
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t5,$zero,$v0 #a
    	addu $t0,$zero,$v0 #a
        andi $t1, $t0, 1     # Check if the least significant bit is set
        beq $t1,$zero, even_number  #beqz $t1, even_number       # If not set, go to even_number
        addiu $s7,$zero,0x00000001
        j end_test_case_2
        
    even_number:
        addiu $s7,$zero,0x00000000
        
    end_test_case_2:
    	j exit
case3:
        # Test Case 3: Bitwise OR operation a & b
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t5,$zero,$v0 
        addu $t0,$zero,$t5 #a
        
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t1,$zero,$v0 #b
        addu $t5,$zero,$v0 
        
        or $t5, $t0, $t1 #13?
        j exit
case4:
        # Test Case 4: Bitwise NOR operation a & b
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t5,$zero,$v0 
        addu $t0,$zero,$t5 #a
        
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t5,$zero,$v0 
        addu $t1,$zero,$t5 #b
        
        nor $t5, $t0, $t1
        j exit
case5:
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t5,$zero,$v0 
        addu $t0,$zero,$t5 #a
        
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t5,$zero,$v0 
        addu $t1,$zero,$t5 #b
        
        xor $t5, $t0, $t1
        j exit
case6:
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t5,$zero,$v0 
        addu $t0,$zero,$t5 #a
        
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t5,$zero,$v0 
        addu $t1,$zero,$t5 #b
        
        slt $t2, $t0, $t1
        beq $t2, $zero, a_greater_than_b  #beqz $t2, a_greater_than_b    # If not less than, go to a_greater_than_b
        addiu $t5,$zero,0x00000000
        j end_test_case_6
        	
    a_greater_than_b:
        addiu $t5,$zero,0x00000001
    end_test_case_6:
    	j exit
case7:
        # Test Case 7: sltu instruction compare unsigned a & b
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t5,$zero,$v0 
        addu $t0,$zero,$t5 #a
        
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t5,$zero,$v0 
        addu $t1,$zero,$t5 #b
        
        sltu $t2, $t0, $t1
        beq $t2, $zero, unsigned_a_greater_than_b    #beqz $t2, unsigned_a_greater_than_b    # If not less than, go to unsigned_a_greater_than_b
        addiu $t5,$zero,0x00000000
        j end_test_case_7
        
    unsigned_a_greater_than_b:
        addiu $t5,$zero,0x00000001
    end_test_case_7:
    	j exit
case8:
        # Test Case 8: Display the values of a and b
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t5,$zero,$v0 
        addu $t0,$zero,$t5 #a
        
        addiu $v0,$zero,0x00000005
    	syscall
    	addu $t5,$zero,$v0 
        addu $t1,$zero,$t5 #b
        
exit:    #j 0x00400128   
        move $a0,$s7 #double
    	li $v0,1 #print double =3
    	syscall
    	
    	li $v0, 4
    	la $a0, newline
    	syscall
    	
    	move $a0,$t5 #double
    	li $v0,1 #print double =3
    	syscall
    	# Exit program
        #li $v0, 10
        addiu $v0,$zero,0x0000000a
        syscall
        

