# n=5 model=out iset=I1 prefix14_class=7792
mov S1, P2
mov S0, P1
cmp P2, P0
cmovl P2, P0
cmovg S1, P0
cmp S0, P3
cmovl S0, P3
cmovge P1, P3
mov P3, P1
cmp S1, P1
cmovl P3, S1
cmovg P1, S1
cmovge S2, S0
cmp P2, S0
