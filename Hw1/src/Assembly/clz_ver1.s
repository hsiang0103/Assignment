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
    lw a0, 0(t0)
    la a2, store
    lw a2, 0(a2)
count:
    lw a1, 0(t1)
    li t2, 0
    li t3, 31
    li t4, 1
loop:
    sll t5, t4, t3
    and t5, a1, t5
    bne t5, x0, next
    addi t2, t2, 1
    addi t3, t3, -1
    blt t3, x0, next
    j loop
next:
    sw t2, 0(a2)
    addi a2, a2, 4
    addi t1, t1, 4
    addi a0, a0, -1
    bge a0, t4, count
return:
    li t3, 31
    li a7, 10
    ecall