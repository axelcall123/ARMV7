.global main
main:
LDR R0, =name
BL printf

@obtengo la cadena
MOV R7, #3
MOV R0, #0
LDR R1, =buf
MOV R2, #10
SVC 0

LDR R0,=txt
LDR R1,=buf
BL printf


MOV R7, #1
MOV R0, #0
SVC 0

.data
buf: .fill 12
name: .ascii "Ingrese el nombre:\n\0"
txt: .ascii "Hola: %s\n"

@as -o impCadena.o impCadena.s
@gcc -o impCadena impCadena.o
@./impCadena

