# n=5 model=out iset=I1 prefix14_class=3244
mov S0, P0
mov S1, P2
cmp P1, S0
cmovg S0, P1
cmovge P1, P0
cmp P3, P2
cmovge P2, P3
cmovg P3, S1
mov P0, P1
cmp P0, P3
cmovl P0, P3
cmovge P1, P3
cmp P2, S0
cmovg S2, S0
