.global main
main:
LDR R0, =txt
MOV R1, #1
ADD R1,R1,R1
BL printf

MOV R7, #1
MOV R0, #0
svc 0
.data
txt: .ascii "hola%d\n"
@as -o primero.o primero.s
@gcc -o primero primero.o
@./primero