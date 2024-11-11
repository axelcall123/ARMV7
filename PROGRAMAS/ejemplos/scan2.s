.global main
main:
    LDR R0, =txt1
    LDR R1, =num1
    LDR R2, =num2
    LDR R1, [R1]
    LDR R2, [R2]
    BL printf

    LDR R0, =txt2
    LDR R1, =num3
    LDR R2, =num4
    LDR R1, [R1]
    LDR R2, [R2]
    BL printf

    MOV R7, #1
    MOV R0, #0
    SVC 0

.data
pat: .asciz "%d"
num1: .word 10
num2: .word 20
num3: .word 30
num4: .word 40
txt1: .asciz "(%d.%d,"
txt2: .asciz "%d.%d)\n"
