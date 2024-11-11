.global main
main:
LDR R0, =pat
LDR R1, =num
BL scanf

LDR R0, =txt
LDR R1, =num
LDR R1, [R1]
BL printf

MOV R7, #1
MOV R0, #0
SVC 0

.data
pat: .asciz "%d"
num: .word 0
txt: .asciz "El numero ingresado es: %d\n"	