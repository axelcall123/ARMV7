.global main
main:
@imprimo mi cadena
LDR R0, =solicitar
BL printf

@obtengo el numero1
LDR R0, =scan
LDR R1, =num1
BL scanf


@imprimo mi cadena
LDR R0, =solicitar
BL printf

@obtengo el numero2
LDR R0, =scan
LDR R1, =num2
BL scanf

@mover valores
LDR R1,	=num1
LDR R1, [R1]
LDR R2, =num2
LDR R2, [R2]

@compara
CMP R1, R2
BPL true @R1>R2
MOV R1,R2

true: @para imprimir se necesita r0,r1
LDR R0, =imp
MOV R1, R1
BL printf

B main
@terminar
MOV R7, #1
MOV R0, #0
SVC 0


.data
scan: .asciz "%d"
solicitar: .asciz "Ingrese un Numero:\n"
imp: .ascii "numero mayor es:%d\n"
num1: .word 0
num2: .word 0
@as -o back.o back.s
@gcc -o back back.o
@./back