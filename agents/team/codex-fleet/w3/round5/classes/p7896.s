# n=5 model=out iset=I1 prefix14_class=7896
mov S1, P3
mov S0, P0
cmp P2, P3
cmovg P3, P2
cmovl S1, P2
cmp P0, P1
cmovl P0, P1
cmovg S0, P1
cmp S1, S0
mov P1, P0
cmovge P2, S1
cmovg S1, S0
cmovg S0, P2
cmp P3, P0
