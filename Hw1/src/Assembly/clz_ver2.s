.data
num_test:   .word 12
constant:   .word 0x0000FFFF,0x00FFFFFF,0x0FFFFFFF,0x3FFFFFFF,0x7FFFFFFF
test:       .word -1,0,1,2147483647,-2147483648,48763,54321,123456789,16,256,65536,65535
answer:     .word 0,32,31,1,0,16,16,5,27,23,15,16    
statement1: .string "All Test Pass"
statement2: .string "Wrong, Check Again"
.text
main:
    la t0, num_test
    lw a0, 0(t0)   # a0 = num_test
    la t1, test
    la t4, answer   
count:
    lw a1, 0(t1)   # a1 = number
    lw a2, 0(t4)   # a2 = answer
    li t2, 0       # t2 = count     
    li t6, 32
    la t5, constant  
    bne a1, x0, loop
    li t2, 32
    j next
loop:   
    lw t3, 0(t5)
    srli t6, t6, 1
    beq t6, x0, next
    addi t5, t5, 4
    bltu t3, a1, loop
    add t2, t2, t6
    sll a1, a1, t6
    j loop
next:
    bne t2, a2, wrong 
    addi t4, t4, 4
    addi t1, t1, 4
    addi a0, a0, -1
    bne a0, x0, count
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