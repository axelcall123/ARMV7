.global main
main:
@imprimo mi cadena
LDR R0, =name
BL printf

@obtengo la cadena
MOV R7, #3
MOV R0, #0
LDR R1, =buf
MOV R2, #10
SVC 0

@hacer ciclo
MOV R4, #0
ciclo:
	LDR R1, =buf
	@obtener ascii #1
	LDRB R2, [R1,R4] 
	@imprimir numero ascii#1
	LDR R0, =imp
	MOV R1, R2
	BL printf

	ADD R4,R4,#1
	CMP R4, #10
	BMI ciclo

MOV R7, #1
MOV R0, #0
SVC 0

.data
buf: .fill 10
name: .ascii "Ingrese una cadena:\n\0"
imp: .ascii "|%d|\n"

@as -o cadena.o cadena.s
@gcc -o cadena cadena.o
@./cadena