.data
num_test: .word 10
test: .word 48763,-48763,696969,12345,1,0,654,12,0x444444,0x16412
store: .word 0x20000000
    
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