.global main
main:
@FIXME: lo nuevo, parte de mis compañeros
LDR R0, =filename
MOV R1, #0
MOV R2, #0
MOV R7, #5
SVC 0

LDR R1, =bufferascii
MOV R2, #72
MOV R7, #3
SVC 0

MOV R7, #6
SVC 0

LDR R4, =bufferascii
MOV R5, #0
MOV R6, #10

MOV R3, #0
loop:@r4,r5,r6
	LDRB R0, [R4], #1
	CMP R0, #0
	BEQ end
	CMP R0, #10
	BEQ enter
	SUB R0, R0, #48
	MUL R1, R5, R6
	ADD R5, R0, R1
	B loop

	enter:@r1
		@LDR R0, =pattern
		@MOV R1, R5
		@BL printf
		@------
		@cambiar entre ejes x,y
		LDR R1,=cXY
		LDR R0, [R1]
		CMP R0, #0
		BEQ ejeX
		CMP R0, #1
		BEQ ejeY
			 
		ejeX:
		@---cambiar var x->y
		PUSH {R1,LR}
		MOV R1, R0
		BL moverTPuntos
		POP {R1,LR}
			
		MOV R0, #1
		LDR R1,=cXY
		STR R0, [R1]
		BL finalEje
			 
		ejeY:
		@---cambiar var y->x
		PUSH {R1,LR}
		MOV R1, R0
		BL moverTPuntos
		POP {R1,LR}
			
		MOV R0, #0
		LDR R1,=cXY
		STR R0, [R1]
		ADD R3, R3, #1
		finalEje:
			 				
		MOV R5, #0
		B loop

	end:
	@------
	@calcula la raiz del cluster
	LDR R0, =tamArray
	ADD R3, R3, #1@por si falta uno
	STR R3, [R0]
	LDR R0, [R0]

	PUSH {LR}@func(numero)
	BL raizCluster
	POP {LR}@->ro,r1;raiz,mitad
		
	@almacenar valor tamañoArray
	LDR R1,=noCluster
	STR R0, [R1]

	@; LDR R0,=tamArray
	@; LDR R0, [R0]
	@; varTam:
	@; LDR R0, =noCluster
	@; LDR R0, [R0]
	@; varClu:
	@; LDR R1, =puntos
	@; MOV R2, R1
	@; ADD R2, R2, #40
	@; cicloVerificar:
	@; 	LDR R0, [R1]
	@; 	verVar:
	@; @condicion ciclo
	@; ADD R1,R1,#4
	@; CMP R1, R2
	@; BNE cicloVerificar

@FIXME: lo viejo

	oneAlgo:@todo el algoritmo para luego repetirlo
		LDR R0, =repitoC @repetir el ciclo poner por default todo en 0
		MOV R1, #0
		STR R1, [R0]

		@----------------------------------------------
		PUSH {R6}
		@operacion del cluster en manhhatan
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
		POP {R6}

		@----------------------------------------------
		PUSH {R5}
		@la sumatoria de los puntos xy del cluster
		LDR R5, =tamArray @tamaño del array
		LDR R5, [R5]
		cicloClusterD:
		SUB R5, R5, #1
			PUSH {LR}@func(posicion_array)
			BL comparacionClusterSE
			POP {LR}@->nada
		@condicion ciclo
		CMP R5, #0
		BNE cicloClusterD
		POP {R5}

		@----------------------------------------------
		@promedio de los puntos xy del cluster
		PUSH {R4}
		LDR R4, =noCluster
		LDR R4, [R4]
		cicloClusterS:
		SUB R4, R4, #1
			PUSH {LR}
			BL changeXYPromedio
			POP {LR}
		@condicion ciclo
		CMP R4, #0
		BNE cicloClusterS
		POP {R4}

		@----------------------------------------------
		@comparacion de los resultados
		LDR R0, =numeroElementos
		MOV R1, #1
		cicloN:
		 	VLDR.F32 S0, [R0]
		  	ADD R0, R0, #4
		  	@convetir
		  	@VCVT.S32.F32 S0, S0 @convierte de float a word
		  	@VMOV R3, S0
		  	@test:
		CMP R1, #1
		BNE cicloN

	@condicion ciclo
	@si repitoC==0 continuo el ciclo
	@saber el valor
	LDR R0, =repitoC
	LDR R0, [R0]
	CMP R0, #1
	BEQ oneAlgo

	@----------------------------------------------
	@imprimir los resultados
	LDR R2, =noCluster
	LDR R2, [R2] @fila cluster
	cicloClusterImp:
	SUB R2, R2, #1
		PUSH {LR}@func(numero_cluster)
		BL changeXYImp
		POP {LR}
	@condicion ciclo
	CMP R2, #0
	BNE cicloClusterImp

	@imprimir ultima parte para el salto de linea
	@MOV R1, #123
	LDR R0, =txt3
	PUSH {LR}
	BL printf
	POP {LR}

	@BX LR
	MOV R0, #0
 	MOV R7, #1
 	SVC 0

raizCluster:@calcula la raiz cuadrada
	@raiz(n/2)
	VMOV.F32 S0, R0
	VCVT.F32.S32 S0, S0 @convierte el valor de word a float
	
	MOV R0, #2
	VMOV.F32 S1, R0
	VCVT.F32.S32 S1, S1 @convierte el valor de word a float
	VDIV.F32 S0, S0, S1 @division entre 2

	VSQRT.F32 S0, S0 @raiz cuadrada
	VCVT.S32.F32 S0, S0 @convierte de float a word
	VMOV R0, S0
	
	MOV PC,LR@->ro;raiz
	
moverTPuntos:@R1;fila
	@----------------------------------------------
	@posicion de puntos
	PUSH {LR}@func(fila,numero_columnas,columna)
	MOV R2, R3 @columna nueva
	MOV R1, #20 @numero de columnas
	verXY:
	BL rowMajor
	POP {LR}@->R1:resultado, rowMajor
	
	@mover a info puntos
	
	LDR R0, =puntos
	MOV R2, #4

	MUL R2, R1, R2

	ADD R2, R0, R2

	LDR R7, [R2]
	
	STR R5, [R2]

	MOV PC, LR@->nada

changeXYImp:
	PUSH {R4}
	@----------------------------------------------
	@eje x
	@posicion del promedioCluster X
	PUSH {R2,LR}@func(fila,numero_columnas,columna)
	MOV R0, R2 @fila cluster
	MOV R2, #0 @columna x
	MOV R1, #2 @numero columnas
	BL rowMajor
	POP {R2,LR}@->R1:resultado, rowMajor

	@info x promedioCluster
	LDR R0, =promedioCluster
	@posicion de la matriz*4
	MOV R3, #4
	MUL R3, R1, R3
	ADD R1, R0, R3
	VLDR.F32 S0, [R1]@flotante

	PUSH {LR}@func(flotante)
	BL separarDecimales
	POP {LR} @->R0,R1@; entera,decimal

	@----------------------------------------------
	@eje y
	PUSH {R0,R1}

	@posicion del promedioCluster y
	PUSH {R2,LR}@func(fila,numero_columnas,columna)
	MOV R0, R2 @fila cluster
	MOV R2, #1 @columna y
	MOV R1, #2 @numero columnas
	BL rowMajor
	POP {R2,LR}@->R1:resultado, rowMajor

	@info y promedioCluster
	LDR R0, =promedioCluster
	@posicion de la matriz*4
	MOV R3, #4
	MUL R3, R1, R3
	ADD R1, R0, R3
	VLDR.F32 S0, [R1]@flotante

	PUSH {LR}@func(flotante)
	BL separarDecimales
	POP {LR} @->R0,R1; entera,decimal

	MOV R3,R0
	MOV R4,R1
	POP {R0,R1}

	@----------------------------------------------
	@imprimir primera parte
	PUSH {R2}
	PUSH {R3,R4}@por si las moscas BL printf
	MOV R2, R1
	MOV R1, R0
	LDR R0, =txt1
	PUSH {LR}
    BL printf
	POP {LR}
	POP {R3,R4}


	@imprimir segunda parte
	MOV R2, R4
	MOV R1, R3
	LDR R0, =txt2
	PUSH {LR}
	BL printf
	POP {LR}


	POP {R2}

	POP {R4}
	MOV PC, LR@->nada



separarDecimales:
    @numero 555.333333 -> 555 y 333
    @tengo el valor 555
    VMOV S1, S0 @555.333
    VCVT.S32.F32 S0, S0 @convierte de float a word
	VMOV R0, S0 @555

    @555.0000
    VMOV.F32 S0, R0 @mueve el valor
	VCVT.F32.S32 S0, S0 @convierte el valor de word a float
    @resta @0.333 
    VSUB.F32 S0, S1, S0  
    @1000.00  
    MOV R1, #1000
    VMOV.F32 S2, R1 @mueve el valor
    VCVT.F32.S32 S2, S2 @convierte el valor de word a float

    @multiplica 333
    VMUL.F32 S3, S2, S0 @multiplica 0.333*1000
    VCVT.S32.F32 S3, S3 @convierte de float a word
    VMOV R1, S3 @333
    MOV PC, LR@->R0,R1; 555,333

changeXYPromedio:
	@----------------------------------------------
	@puntos de xy
	MOV R3, #0 @xy
	cilcoXYave:
		PUSH {LR}@func(xy)
		BL sacarPromedioEje
		POP {LR}@->R0, posicion del numero de elementos
	@condicion ciclo
	ADD R3, R3, #1
	CMP R3, #2
	BLT cilcoXYave

	@dejar por Default numeroElementos
	MOV R1, #0 @TODO: cambiar por 0
	VMOV.F32 S2, R1 @mueve el valor
	VCVT.F32.S32 S2, S2 @convierte el valor de word a float
	@almacenar en numeroElementos
	VSTR.F32 S2, [R0]

 	MOV PC, LR

sacarPromedioEje:@saca el promedio de los puntos de un eje
	@----------------------------------------------
	@posicion del la suma promedio
	PUSH {LR}@func(fila,numero_columnas,columna)
	MOV R0, R4 @fila cluster
	MOV R2, R3 @columna xy
	MOV R1, #2 @numero columnas
	BL rowMajor
	POP {LR}@->R1:resultado, rowMajor

	@posicion suma promedio
	LDR R0, =sumaPromedio
	@posicion de la matriz*4
	MOV R2, #4
	MUL R2, R1, R2
	ADD R0, R0, R2
	VLDR.F32 S0, [R0]@float 2

	@dejar por Default sumaPromedio
	MOV R1, #0 @TODO: cambiar por 0
	VMOV.F32 S1, R1 @mueve el valor
	VCVT.F32.S32 S1, S1 @convierte el valor de word a float
	@almacenar en sumaPromedio
	VSTR.F32 S1, [R0]

	@----------------------------------------------
	PUSH {R2}
	@posicion de las numero de elementos
	PUSH {LR}@func(fila,numero_columnas,columna)
	MOV R0, R4 @fila cluster
	MOV R2, #0 @columna
	MOV R1, #1 @numero columnas
	BL rowMajor
	POP {LR}@->R1:resultado, rowMajor

	@posicion numero Elementos
	LDR R0, =numeroElementos
	@posicion de la matriz*4
	MOV R2, #4
	MUL R2, R1, R2
	ADD R0, R0, R2
	@MOV R5, R0 @posicion numero Elementos
	VLDR.F32 S1, [R0]@float 2
	POP {R2}@reutlizar posicion de la suma promedio

	VDIV.F32 S2, S0, S1 @Divide el contenido de S0 por el contenido de S1

	@almacenar en promedioCluster, para reutilzar no hacer mas operaciones
	LDR R1, =promedioCluster
	ADD R1, R1, R2 @reutilizo la posicion de la suma promedio
	VSTR.F32 S2, [R1]

	@----------------------------------------------TODO: ultimo codigo validado
	@compara cluster ademas muevo de promedioCluster hacia resultado
	@posicion del cluster 
	PUSH {R0}
	PUSH {LR}@func(fila,numero_columnas,columna)
	MOV R0, R3 @fila xy
	MOV R2, R4 @columna cluster
	MOV R1, #5 @numero columnas
	BL rowMajor
	POP {LR}@->R1:resultado, rowMajor

	@posicion del cluster
	LDR R0, =cluster
	@posicion de la matriz*4
	MOV R2, #4
	MUL R2, R1, R2
	ADD R1, R0, R2
	VLDR.F32 S0, [R1]@float 2
	POP {R0}

	@si repitoC==1 entonces ya no comparo
	@saber el valor
	LDR R2, =repitoC
	LDR R2, [R2]
	CMP R2, #1
	BEQ comparacionCluster1
		@comparacion de los resultados, si uno no cuadra repitoC=1
		VCMP.F32 S2, S0 @promedio, cluster
		VMRS APSR_nzcv, FPSCR
		BNE comparacionCluster2 @S2!=S0
		CMP R4, #0 @si es el final de todos los cluster
		BEQ comparacionCluster1 @si es el final de todos los cluster
		CMP R4, #0
		BNE comparacionCluster1 @si no es el final de todos los cluster
		comparacionCluster2:
			@almacenar en noCluster
			PUSH {R3}@ es para que no se pierda el valor de R3, que es xy
			LDR R2, =repitoC
			MOV R3, #1
			STR R3, [R2]
			POP {R3}
	comparacionCluster1:
	VSTR.F32 S2, [R1]
	@----------------------------------------------TODO: ultimo codigo
	MOV PC, LR@->R0, posicion del numero de elementos



comparacionClusterSE:@compara todos los cluster almacena la suma total de un eje

	@default
	@MOVW R0, #65535 @contador cluster
	LDR R0, =65535
	VMOV.F32 S0, R0 @mueve el valor
	VCVT.F32.S32 S0, S0 @convierte el valor @float 1
	@MOVW R3, #65535 @que cluster es
	LDR R3, =65535

	LDR R1, =noCluster 
	LDR R1, [R1]
	cicloMenores:
	SUB R1, R1, #1
		@----------------------------------------------
		@obtener el valor float
		@posicion del float
		PUSH {R0,R1,R3,LR}@func(fila,numero_columnas,columna)
		MOV R0, R1 @fila clusters
		MOV R2, R5 @columna cambio del tamaño del array
		MOV R1, #20 @numero columnas
		BL rowMajor

		@el float
		LDR R2, =resultado
		@posicion de la matriz*4
		MOV R3, #4
		MUL R3, R1, R3
		ADD R2, R2, R3
		VLDR.F32 S1, [R2]@float 2

		@dejar por  Default el resultado
		@MOVW R0, #65535 @TODO: cambiar por 65535
		LDR R0, =65535
		VMOV.F32 S2, R0 @mueve el valor
		VCVT.F32.S32 S2, S2 @convierte el valor @float
		@almacenar en resultado
		VSTR.F32 S2, [R2]

		POP {R0,R1,R3,LR}@->R1:resultado, rowMajor

		@----------------------------------------------
		PUSH {LR}@func(numero_cluster,float1,float2)
		BL elMenor
		POP {LR}@->S0
		
	@condicion ciclo
	CMP R1, #0
	BNE cicloMenores@->R3:numero cluster

	PUSH {R4}
	MOV R4, #0 @eje
	cicloXYcc:@cambio en x,y
		PUSH {LR}@func(numero_cluster,eje)
		BL sumatoriaE
		POP {LR}@->nada
	@condicion ciclo
	ADD R4, R4, #1
	CMP R4, #2
	BLT cicloXYcc
	POP {R4}

	@----------------------------------------------
	@numeroElementos
	@posicion numero numeroElementos
	PUSH {LR}@func(fila,numero_columnas,columna)
	MOV R0, R3 @fila cluster
	MOV R2, #0 @columna
	MOV R1, #1 @numero columnas
	BL rowMajor
	POP {LR}@->R1:resultado, rowMajor

	@posicion numero Elementos
	LDR R0, =numeroElementos
	@posicion de la matriz*4
	MOV R2, #4
	MUL R2, R1, R2
	ADD R0, R0, R2
	VLDR.F32 S1, [R0]@float 2

	@suma un elemento para luego hacer el promedio
	MOV R1, #1 @contador
	VMOV.F32 S0, R1 @mueve el valor
	VCVT.F32.S32 S0, S0 @convierte el valor @float 1
	VADD.F32 S1, S1, S0

	@almacenar en numeroElementos
	VSTR.F32 S1, [R0]

	MOV PC, LR


elMenor:@verifica cual es el menor de los 2 valores float
	@----------------------------------------------
	VCMP.F32 S0, S1@comparacion
	VMRS APSR_nzcv, FPSCR @guarda el resultado de la comparacion
	BLT elMenors0Menor @si es menor s0<s1
	MOV R3, R1 @nuevo cluster
	VMOV.S32 S0, S1
	MOV PC, LR
	elMenors0Menor:

		MOV PC, LR

	MOV PC, LR

sumatoriaE:@suma todos los puntos de un cluster
	@----------------------------------------------
	@puntos de X
	PUSH {LR}@func(fila,numero_columnas,columna)
	MOV R0, R4 @fila x,y
	MOV R1, #20 @numero columnas
	MOV R2, R5 @columna posicion del array
	BL rowMajor 
	POP {LR}@->r1:resultado

	@----------------------------------------------
	@obtener numero X puntos
	LDR R2, =puntos
	@posicion de la matriz*4
	PUSH {R4}
	MOV R4, #4
	MUL R0, R1, R4
	LDR R2, [R2, R0] @val1
	VMOV.F32 S0, R2 @mueve el valor
	VCVT.F32.S32 S0, S0 @convierte el valor
	POP {R4} @S0, R3
	
	@----------------------------------------------
	@sumaPromedio
	@posicion numero sumaPromedio
	PUSH {LR}@func(fila,numero_columnas,columna)
	MOV R0, R3 @fila cluster
	MOV R2, R4 @columna  x,y
	MOV R1, #2 @numero columnas
	BL rowMajor
	POP {LR}@->R1:resultado, rowMajor

	@posicion suma promedio
	LDR R0, =sumaPromedio
	@posicion de la matriz*4
	MOV R2, #4
	MUL R2, R1, R2
	ADD R0, R0, R2
	VLDR.F32 S1, [R0]@float 2
	
	VADD.F32 S1, S1, S0

	@almacenar en sumaPromedio
	VSTR.F32 S1, [R0]

	MOV PC, LR


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
	MOV R2, R0 @columna tamaño del array
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
	SUB R1, R1, #1 @columna-1 tamaño del array
	MOV R2, R1 @columna
	MOV R0, R5 @fila xy
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
	MOV R0, R5 @fila xy
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
	VCVT.F32.S32 S1, S1 @convierte el valor de word a float
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
@FUNCIONES----------------------------------
@; calcularCluster:
@; 	LDR R0, =tamanioCluster
@; 	LDR R0, [R0]
@; 	ASR R2, R0, #1   @dividir entre 2 
@; 	MOV R2, #10 @ajustar precision 10 iteraciones
@; 	MOV R1, #1  @INICIALIZAR LA ESTIMACION
@; 	BL sqrt
@; 	POP {LR}

@; sqrt:     @Aplica la fórmula de Newton-Raphson: x_n+1 = 0.5 * (x_n + num / x_n)
@; 	MOV R3, R2
@; 	SDIV R4, R3, R1
@; 	ADD R1, R1, R4
@; 	ASR R1, R1, #1
@; 	SUBS R2, R2, #1
@; 	CMP R2, #0
@; 	BNE sqrt
@; 	STR R1, [R0]
@; 	POP {LR}

.data
puntos: 
 .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 @20 columnas @x
 .word 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40 @y
resultado: 
 .float 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0 @20 columnas
 .float 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0
 .float 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0
 .float 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0
 .float 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0, 65535.0
cluster:
	@5 columnas 
	.float 2.0, 5.0, 0.0, 0.0, 0.0@x
 	.float 2.0, 3.0, 0.0, 0.0, 0.0@y

sumaPromedio:@ x,y sirve para la sumatoria de los puntos xy del cluster
	.float 0.0, 0.0
	.float 0.0, 0.0
	.float 0.0, 0.0
	.float 0.0, 0.0
	.float 0.0, 0.0

numeroElementos:
	.float 0.0
	.float 0.0
	.float 0.0
	.float 0.0
	.float 0.0

promedioCluster:
	@        x,y
	.float 0.0, 0.0
	.float 0.0, 0.0
	.float 0.0, 0.0
	.float 0.0, 0.0
	.float 0.0, 0.0

@variables normales
tamArray: .word 0 
noCluster: .word 0 @numero cluster que generar
repitoC: .word 0 @repetir el ciclo de cluster
@para imprimir
txt1: .asciz "(%d.%d,"
txt2: .asciz "%d.%d) "
txt3: .asciz "\n"
@para leer
cXY: .word 0 @cambiar entre x,y
filename: .asciz "test01.txt"
pattern: .asciz "%d \n"
bufferascii: .asciz
