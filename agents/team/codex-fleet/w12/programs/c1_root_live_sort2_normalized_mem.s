# n=2 R=7 iset=I1 model=mem source=w12_C1_control
mov S0, P0
mov S1, P1
cmp S0, S1
mov S2, S0
cmovg S2, S1
mov S3, S0
cmovg S3, S1
cmp S0, S1
mov S4, S0
cmovg S4, S1
cmovg S1, S0
mov P0, S4
mov P1, S1
