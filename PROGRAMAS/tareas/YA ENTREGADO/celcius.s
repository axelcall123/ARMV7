.global main
main:
VLDR S0, varA
VLDR S1, varB
VDIV.F32 S0, S0, S1
VLDR S1, TC
VMUL.F32 S0, S0, S1
VLDR S1, varC
VADD.F32 S0, S0, S1
VCVT.S32.F32 S0, S0
VMOV R0, S0
BX LR

varA: .float 9.0
varB: .float 5.0
varC: .float 32.0
TC: .float 30.0
.data
@as -mfpu=vfp -o test.o test.s
@gcc -o test test.o
@./test ; echo $?

