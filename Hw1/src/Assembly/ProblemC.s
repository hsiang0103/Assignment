.data
num_test:   .word 7
test:       .word 0x1234,0x5678,0x4876,0xF123,0xFC00,0x0400,0x3555
answer:     .word 0x3A468000,0x42cf0000,0x410ec000,0xc6246000,0xFF800000,0x38800000,0x3EAAA000 
statement1: .string "All Test Pass"
statement2: .string "Wrong, Check Again"
.text
main:
    la t0, num_test
    lw a6, 0(t0)   # a0 = num_test
    la s1, test
    la t3, answer   
fp16tofp32:
    lw t1, 0(s1)   # t1 = number
    lw a2, 0(t3)   # a2 = answer
    slli t0, t1, 16  
    li t6, 0x80000000
    and t4, t0, t6
    li t6, 0x7FFFFFFF
    and t5, t0, t6
########### call function clz #############
    addi sp, sp, -16   
    sw a1, 12(sp)       
    sw t2, 8(sp)         
    sw t1, 4(sp)  
    sw t0, 0(sp)           
    mv a0, t5       # a0 = num
    li a1, 0x55af
    jal ra, clz     # a0 = leading zero
    lw t0, 0(sp)          
    lw t1, 4(sp)      
    lw t2, 8(sp)      
    lw a1, 12(sp)     
##########################################
    sltiu t6, a0, 6
    bne t6, x0, lessthan5 
    addi a0, a0, -5
    j inf_nan_mask
lessthan5:
    li a0, 0
inf_nan_mask:
    li t6, 0x04000000
    add t6, t6, t5
    srai t6, t6, 8
    li a1, 0x7F800000
    and a1, t6, a1
    addi a5, t5, -1
    srai a5, a5, 31
    sub a5, x0, a5
    sll a3, t5, a0
    srli a3, a3, 3
    li a4, 0x70
    sub a4, a4, a0
    slli a4, a4, 23
    add a3, a3, a4
    or a3, a3, a1
    or a3, a3, a5
    or t2, a3, t4 
next:
    bne t2, a2, wrong 
    addi t3, t3, 4
    addi s1, s1, 4
    addi a6, a6, -1
    bne a6, x0, fp16tofp32
return:
    la a0, statement1
    addi a7, zero, 4
    ecall  
    j fin
wrong:
    la a0, statement2
    addi a7, zero, 4
    ecall
fin:
    li a7, 10   
    ecall
##########################################
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
    sltiu t1, a0, 1
    add t0, t0, t1
    mv a0, t0     
    ret                    
##########################################