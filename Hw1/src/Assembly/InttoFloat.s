.data
num_test: .word 13
test: .word -1,0,1,2147483647,-2147483648,0x08000008,0x08000018,48763,-48763,123456789,537530813,278410568,1509961956
answer: .word 0xbf800000,0,0x3f800000,0x4f000000,0xcf000000,0x4d000000,0x4d000002,0x473e7b00,0xc73e7b00,0x4ceb79a3,0x4e002847,0x4d84c1aa,0x4eb40062
statement1: .string "All Test Pass"
statement2: .string "Wrong, Check Again"

.text
main:
    la s0, num_test
    lw t0, 0(s0)   # t0 = num_test
    la s1, test
    la t2, answer   
##########################################
loop:       
    lw t1, 0(s1)   # t1 = num
    lw a2, 0(t2)   # a2 = answer
    beq t1, x0, next
sign:
    srli t3, t1, 31
    bgt t1, x0, exponent
    sub t1, x0, t1
exponent:
########### call function clz #############
    addi sp, sp, -12      
    sw t2, 8(sp)         
    sw t1, 4(sp)  
    sw t0, 0(sp)           
    mv a0, t1       # a0 = num
    li a1, 0x55af
    jal ra, clz     # a0 = leading zero
    lw t0, 0(sp)          
    lw t1, 4(sp)      
    lw t2, 8(sp)         
##########################################
    sub a0, x0, a0
    addi s5, a0, 31
    addi t4, s5, 127
    slt s6, s5, x0
mantissa:
    li s8, 1
    sll s7, s8, s5
    xor t5, t1, s7
round:
    li s7, 23
    ble s5, s7, noround
    addi s9, s5, -24
    srl s7, t5, s9
    andi t6, s7, 1
    addi s7, s5, -23
    srl s7, t5, s7
    andi s6, s7, 1
    sll s8, s8, s9
    addi s8, s8, -1
    and s8, s8, t5
    bne s8, x0, noroundeven
    beq t6, x0, noroundeven
    mv t6, s6
noroundeven:    
    addi s9, s5, -23
    srl t5, t5, s9
    add t5, t5, t6
    j merge
noround:
    sub s5, x0, s5
    addi s7, s5, 23
    sll t5, t5, s7
merge:
    slli t3, t3, 31
    slli t4, t4, 23
    or a0, t3, t4
    add t1, a0, t5
##########################################
next:
    bne t1, a2, wrong 
    addi t2, t2, 4
    addi s1, s1, 4
    addi t0, t0, -1
    bne t0, zero, loop
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