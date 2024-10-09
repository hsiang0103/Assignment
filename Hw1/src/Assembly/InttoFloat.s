num_test: .word 10
test: .word -1,0,1,2147483647,-2147483648,0x08000008,0x08000018,48763,-48763,123456789
answer: .word 0,0xbf800000,0x3f800000,0xcf000000,0x4f000000,0x4d000000,0x4d000002,0x473e7b00,0xc73e7b00,0x4ceb79a3
store: .word 0x20000000

.text
main:
    la s0, num_test
    lw t0, 0(s0)   # t0 = num_test
    la s1, test
    la s2, store   
    lw t2, 0(s2)   # t2 = store address
    li s3, 158
    li s4, -8
    li s7, 0x007FFFFF
##########################################
    # t1 = num
    # t3 = sign
    # t4 = exponent
    # t5 = mantissa
    # t6 = round_bit
    # s5 = temp
    # s6 = temp
    # s7 = 0x007FFFFF
loop:       
    lw t1, 0(s1)   # t1 = num
    li a0, 0
    beq t1, x0, next
sign:
    slt t3, t1, x0
    beq t3, x0, exponent
    sub t1, x0, t1
exponent:
##########################################
    # call function clz
    addi sp, sp, -20      
    sw ra, 16(sp)   
    sw t3, 12(sp)    
    sw t2, 8(sp)         
    sw t1, 4(sp)  
    sw t0, 0(sp)           
    mv a0, t1       # a0 = num
    li a1, 0x55af
    li a2, 1
    jal ra, clz
    lw t0, 0(sp)          
    lw t1, 4(sp)      
    lw t2, 8(sp)  
    lw t3, 12(sp)          
    lw ra, 16(sp)  
##########################################
    sub t4, s3, a0
    add s5, s4, a0
    slt s6, s5, x0
    bne s6, x0, adjust
    li t6, 0
    sll s6, t1, s5
j mantissa
    adjust:
    sub s5, x0, s5
    addi s6, s5, -1
    srl s6, t1, s6
    andi t6, s6, 1
    srl s6, t1, s5
mantissa:
    and s8, s6, s7
    add t5, s8, t6
    slli t3, t3, 31
    slli t4, t4, 23
    or a0, t3, t4
    or a0, a0, t5
##########################################
next:
    sw a0, 0(t2)
    addi t2, t2, 4
    addi s1, s1, 4
    addi t0, t0, -1
    bne t0, zero, loop
return:
    li a7, 10
    ecall
##########################################

##########################################
    # function:clz
    # t0 = count
    # t1 = temp
    # t2 = temp
    # a0 = number, return count
    # a1 = 0x55af
    # a2 = 1
clz:
    li t0, 0      
    li t1, 0x00010000 
    sltu t2, a0, t1
    slli t2, t2, 4
    add t0, t0, t2
    sll a0, a0, t2
    li t1, 0x01000000
    sltu t2, a0, t1
    slli t2, t2, 3
    add t0, t0, t2
    sll a0, a0, t2
    li t1, 0x10000000  
    sltu t2, a0, t1
    slli t2, t2, 2
    add t0, t0, t2
    sll a0, a0, t2
    srli t1, a0, 27
    andi t1, t1, 0x1e
    srl t1, a1, t1
    andi t1, t1, 3
    add t0, t0, t1
    sltu t1, a0, a2 
    add t0, t0, t1
    mv a0, t0     
    ret                    
##########################################