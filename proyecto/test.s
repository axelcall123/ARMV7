.global main
main:
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
    MOV R8, #0 @INICIALIZAR EL TAMANIO DEL VECTOR

    loop_size:
        LDRB R0, [R4], #1
        CMP R0, #0
        BEQ end_size
        CMP R0, #10
        BEQ enter_size
        SUB R0, R0, #48
        MUL R1, R5, R6
        ADD R5, R0, R1
        B loop_size

    enter_size:
    LDR R8, =tamanioVectorX
    LDR R9, [R8] @CALCULAR EL TAMANIO DE LOS REGISTROS
    ADD R9, R9, #1
    STR R9, [R8]
    
    LDR R8, =tamanioCluster
    STR R9, [R8]  @TAMANIO DE LOS REGISTROS PARA EL CLUSTER

    MOV R5, #0
    B loop_size

    end_size:
    LDR R0, =tamanioVectorX   @DIVIDE ENTRE 2 PARA SABER CUANTOS REGISTROS EN X VAN HABER
    LDR R1, [R0]
    ASR R1, R1, 0
    LDR R1, [R0]

    B loop_vector

    loop_vector:
        LDRB R0, [R4], #1
        CMP R0, #0
        BEQ end_vector
        CMP R0, #10
        BEQ enter_vector
        SUB R0, R0, #48
        MUL R1, R5, R6
        ADD R5, R0, R1
        B loop_vector

    enter_vector:
    LDR R0, =pattern
    MOV R1, R5
    @BL printf

    AND R2, R0, #1
    CMP R2, #0
    BEQ nuevo_punto
    BNE finalizar_punto
 
    nuevo_punto:
    LDR R1, =contador
    LDR R0, [R1] @POSICION X

    MOV R1, #0 @POSICIÓN Y
    MOV R2, R5 @VALOR A INGRESAR

    LDR R4, =tamanioVectorX
    LDR R4, [R4]  @TAMANIO DE LAS COLUMNAS

    MUL R3, R0, R4  @MULTIPLICAR EL INDICE DE FILA POR EL TAMAÑO DE LAS COLUMNAS
    ADD R3, R3, R1  @SUMAR EL INDICE DE LA COLUMNA
    LSL R3, R3, #2  @MULTIPLICAR EL INDICE TOTAL POR EL TAMAÑO DE CADA ELEMENTO

    @CALCULAR LA DIRECCIÓN DE MEMORIA DEL ELEMENTO
    LDR R4, =matriz
    ADD R4, R4, R3

    @ALMACENAR EL VALOR EN MATRIZ
    STR R2, [R4]

    B loop_vector

    finalizar_punto:
    LDR R1, =contador
    LDR R0, [R1] @POSICION X

    MOV R1, #1 @POSICIÓN Y
    MOV R2, R5 @VALOR A INGRESAR

    LDR R4, =tamanioVectorX
    LDR R4, [R4]  @TAMANIO DE LAS COLUMNAS

    MUL R3, R0, R4  @MULTIPLICAR EL INDICE DE FILA POR EL TAMAÑO DE LAS COLUMNAS
    ADD R3, R3, R1  @SUMAR EL INDICE DE LA COLUMNA
    LSL R3, R3, #2  @MULTIPLICAR EL INDICE TOTAL POR EL TAMAÑO DE CADA ELEMENTO

    @CALCULAR LA DIRECCIÓN DE MEMORIA DEL ELEMENTO
    LDR R4, =matriz
    ADD R4, R4, R3

    @ALMACENAR EL VALOR EN MATRIZ
    STR R2, [R4]

    @SUMAR EL REGISTRO DEL CONTADOR
    LDR R0 =contador
    LDR R1 [R0]CALCULAR EL TAMANIO DE LOS REGISTROS
    ADD R1 R1 #1
    STR R1 [R0]

    B loop_vector


    end_vector:

    PUSH {LR}
    BL calcularCluster

@-------------RESTO DE CODIGO -----------------

 


@-------------TERMINAR PROGRAMA
    MOV R0, #0
    MOV R7, #1
    SVC 0


@FUNCIONES----------------------------------

calcularCluster:
    LDR R0, =tamanioCluster
    LDR R0, [R0]
    
    ASR R2, R0, #1   @dividir entre 2 
    
    MOV R2, #10 @ajustar precision 10 iteraciones
    MOV R1, #1  @INICIALIZAR LA ESTIMACION

    BL sqrt

    POP {LR}

sqrt:     @Aplica la fórmula de Newton-Raphson: x_n+1 = 0.5 * (x_n + num / x_n)
    MOV R3, R2
    SDIV R4, R3, R1
    ADD R1, R1, R4
    ASR R1, R1, #1

    SUBS R2, R2, #1

    CMP R2, #0
    BNE sqrt

    STR R1, [R0]

    POP {LR}

 


.data
filename: .asciz "test01.txt"
pattern: .asciz "%d \n"
bufferascii: .asciz
tamanioVectorX: .word 0
tamanioCluster: .word 0
matriz: 
 .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 @20 columnas @x
 .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 @y
contador: .word 0
