.global main
.extern printf
main:
PUSH {lr}
MOV R2, #0
EOR R3,R2, #0
LDR R0, =a
MOV R1,R3
BL printf

MOV R2, #0
EOR R3,R2, #1
LDR R0, =a
MOV R1,R3
BL printf

MOV R2, #0
EOR R3,R2, #1
LDR R0, =a
MOV R1,R3
BL printf

MOV R2, #1
EOR R3,R2, #0
LDR R0, =a
MOV R1,R3
BL printf

MOV R2, #1
EOR R3,R2, #1
LDR R0, =a
MOV R1,R3
BL printf

POP {pc}

BX LR
.data
a: .asciz "0xor0=%d\n"
b: .asciz "0xor1%d\n"
c: .asciz "1xor0%d\n"
d: .asciz "1xor1%d\n"

@terminal
@gcc -o xor xor.s
@./xor