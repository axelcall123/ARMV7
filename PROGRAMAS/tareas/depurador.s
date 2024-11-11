.global main
main:

PUSH {FP,LR}
MOV R11, SP
MOV R0, #3
BL add
MOV R0, #2
BL add
MOV R0, #1
BL add
MOV R0, #0
POP {FP,LR}
BX LR

add:
LDR R1,=head
LDR R1, [R1]
CMP R1, #0
CMP R1, #0
BEQ empety
MOV SP, R1
SUB SP, SP, #8
STR R0, [SP]
STR R1, [SP, #4]
LDR R1, =head
STR SP, [R1]
MOV SP, FP
MOV PC, LR

empety:
SUB SP, SP, #64
LDR R1, =head
STR SP, [R1]
STR R0, [SP]
MOV R1, #0
STR R1, [SP, #4]
ADD SP, SP, #64
MOV PC, LR

.data
head:
 .long 0