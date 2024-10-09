.data
num_test:   .word 12
test:       .word -1,0,1,2147483647,-2147483648,48763,54321,123456789,16,256,65536,65535
answer:     .word 0,32,31,1,0,16,16,5,27,23,15,16    
statement1: .string "All Test Pass"
statement2: .string "Wrong, Check Again"
.text
main:
    la t0, num_test
    la t1, test
    la a2, store   
    lw a0, 0(t0)   # a0 = num_test
    addi a0, a0, -1
    lw a2, 0(a2)   # a2 = store address
    li a3, 1
count:
    lw a1, 0(t1)   # a1 = number
    li t2, 0       # t2 = count
    li t3, 0x00010000 
    sltu t4, a1, t3
    slli t4, t4, 4
    add t2, t2, t4
    sll a1, a1, t4
    li t3, 0x01000000
    sltu t4, a1, t3
    slli t4, t4, 3
    add t2, t2, t4
    sll a1, a1, t4
    li t3, 0x10000000  
    sltu t4, a1, t3
    slli t4, t4, 2
    add t2, t2, t4
    sll a1, a1, t4
    li t3, 0x40000000  
    sltu t4, a1, t3
    slli t4, t4, 1
    add t2, t2, t4
    sll a1, a1, t4
    li t3, 0x80000000  
    sltu t4, a1, t3 
    add t2, t2, t4
    sll a1, a1, t4
    sltu t4, a1, a3
    add t2, t2, t4
    next:
    sw t2, 0(a2)
    addi a2, a2, 4
    addi t1, t1, 4
    addi a0, a0, -1
    bge a0, x0, count
return:
    li a7, 10
    ecall