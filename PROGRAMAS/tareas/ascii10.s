.global main
main:
LDR R0, =filename
MOV R1, #0
MOV R2, #0
MOV R7, #5
SVC 0

LDR R1, =buffer
MOV R2, #11
MOV R7, #3
SVC O


LDR R0, [SP,#8]
LDR R1, =buffer
MOV R2, #0

MOV R4, #1@para multiplicar en 10 en 10

loop:
LDRB R3, [R0]
CMP R3, #0
BEQ end
CMP R3, #48
BEQ loop
SUB R3, R3, #48
@multiplicacion ax10
MUL R5,R4,R3
ADD R6,R6,R3
@multiplicacion x10nveces
MUL R5,R4,#10
MOV R4,R5
B loop

