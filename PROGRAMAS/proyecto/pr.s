.global main
main:
	@----------------------------------------------
	MOV R6, #0 @contador cluster
	cicloCluster:
		PUSH {LR} @func(contador_cluster)
		BL clusterE
		POP {LR} @->nada

		LDR R0, =noCluster
		LDR R0, [R0]

	@condicion ciclo
	ADD R6, R6, #1
	CMP R6, R0
	BLT cicloCluster
	
	@----------------------------------------------
	@comparacion de los resultados
	LDR R0, =resultado
	MOV R1, #0
	cicloN:
		VLDR.F32 S0, [R0]
		ADD R0, R0, #4
		@convetir
		VCVT.S32.F32 S0, S0
		VMOV R3, S0
		test:
	CMP R1, #1
	BNE cicloN

	BX LR

clusterE:@genera los cluster
	@----------------------------------------------
	@genera todos los puntos del cluster para el promedio
	LDR R0, =tamArray @tamaño del array
	LDR R0, [R0]
	cicloPuntos:
		PUSH {LR} @func(tamaño_array)
		BL manhhatan
		POP {LR} @->nada

	@condicion ciclo
	SUB R0,R0,#1
	CMP R0, #0
	BNE cicloPuntos

	
	MOV PC, LR

manhhatan:@|x0-y0|+|x1-y1|
	PUSH {R4}

	@----------------------------------------------
	@poner por default
	MOV R1, #0
	VMOV.F32 S2, R1 @mueve el valor
	VCVT.F32.S32 S2, S2 @convierte el valor

	@----------------------------------------------
	@cambia los puntos en x,y
	MOV R5, #2 @cambio
	cicloXY:
		SUB R5, R5, #1	
		PUSH {LR} @func(cambio)
		BL changeXY
		POP {LR} @->S0

		@suma |x0-y0|+|x1-y1|
		VADD.F32 S2, S2, S0

	CMP R5, #0
	BNE cicloXY

	@----------------------------------------------
	@obtener numero X cluster
	PUSH {R0, LR}@func(fila,numero_columnas,columna)
	MOV R2, R0 @columna
	SUB R2, R2, #1 @columna-1
	MOV R0, R6 @fila Cluster
	MOV R1, #20 @numero columnas
	BL rowMajor 
	POP {R0, LR}@->r1:resultado

	@----------------------------------------------
	@almacenar en resultado
	LDR R4, =resultado
	@posicion de la matriz*4
	MOV R2, #4
	MUL R3, R1, R2
	ADD R4, R4, R3
	VSTR.F32 S2, [R4]

	@convetir
	@VCVT.S32.F32 S2, S2
	@VMOV R2, S2

	POP {R4}
	MOV PC, LR

changeXY:@cambia los puntos en x,y
	PUSH {R4}
	@----------------------------------------------
	@puntos de X
	MOV R1, R0 @aux
	PUSH {R0, LR}@func(fila,numero_columnas,columna)
	SUB R1, R1, #1 @columna-1
	MOV R2, R1 @columna
	MOV R0, R5 @fila
	MOV R1, #20 @numero columnas
	BL rowMajor 
	POP {R0, LR}@->r1:resultado
	
	@----------------------------------------------
	@obtener numero X puntos
	LDR R2, =puntos
	@posicion de la matriz*4
	MOV R4, #4
	MUL R3, R1, R4
	LDR R2, [R2, R3] @val1
	
	@----------------------------------------------
	@cluster de X
	@MOV R1, R0 @aux
	PUSH {R0, R2, LR}@func(fila,numero_columnas,columna)
	MOV R0, R5 @fila
	MOV R1, #5 @numero columnas
	MOV R2, R6 @columna Cluster
	BL rowMajor 
	POP {R0, R2, LR}@->R1:resultado
	
	@----------------------------------------------	
	@obtener numero X cluster
	LDR R4, =cluster
	
	@----------------------------------------------
	@absoluto de X
	PUSH {LR}@func(val1,val2)
	@posicion de la matriz*4
	MOV R3, #4
	MUL R3, R1, R3
	
	MOV R1, R2 @val1 word
	ADD R4, R4, R3
	VLDR.S32 S0, [R4] @val2 float
	BL resAbsoluto
	POP {LR}@->S0
	

	POP {R4}
	MOV PC, LR

resAbsoluto:@|val1-val2|

	@resta
	VMOV.F32 S1, R1 @mueve el valor
	VCVT.F32.S32 S1, S1 @convierte el valor
	VSUB.F32 S0, S0, S1 @val1-val2
	VABS.F32 S0, S0 @absoluto
	
	MOV PC, LR
	@return S0




rowMajor:@fila*numero_columnas+columna;x×noFil+y
	
	@R0*R1+R2
	MUL R1,R0,R1
	ADD R1,R1,R2
	
	MOV PC, LR
	@return R1
	

.data
puntos: 
 .word 3, 5, 2, 2, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 @20 columnas
 .word 2, 3, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
resultado: 
 .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 @20 columnas
 .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
 .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
 .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
 .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
cluster:
 .float 2.0, 5.0, 0.0, 0.0, 0.0 @5 columnas
 .float 2.0, 3.0, 0.0, 0.0, 0.0

sumaPromedio:
	.float 0.0
	.float 0.0
	.float 0.0
	.float 0.0
	.float 0.0

numeroElementos:
	.float 0.0
	.float 0.0
	.float 0.0
	.float 0.0
	.float 0.0

@variables normales
tamArray: .word 6
noCluster: .word 2 @numero cluster que generar
