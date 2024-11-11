.global main
main:
@imprimo mi cadena
LDR R0, =solicitar
BL printf

@tomo numero
LDR R0, =pat
LDR R1, =num
BL scanf

@paso a un registro
LDR R1, =num
LDR R1, [R1]

MOV R2, #1 @resultado mult

do:
MUL R3,R2,R1@ la multiplicacion debe ir a otro registro rd, rn,rm
MOV R2,R3
SUB R1,R1,#1
CMP R1, #1
BNE do

LDR R0, =imp
MOV R1,R2
BL printf

MOV R7, #1
MOV R0, #0
SVC 0

.data
pat: .asciz "%d"
imp: .asciz "factorial es: %d\n"
solicitar: .asciz "Ingrese un Numero:\n"
num: .word 0

@el numero mas grande seria factorial de 16!
@as -o dow.o dow.s
@gcc -o dow dow.o
@./dow