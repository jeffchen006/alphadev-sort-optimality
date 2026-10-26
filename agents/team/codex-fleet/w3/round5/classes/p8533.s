# n=5 model=out iset=I1 prefix14_class=8533
cmp P0, P3
cmovge S1, P0
cmovl S1, P3
cmovl P3, P0
cmp P2, P1
mov S0, P2
cmovl S0, P1
cmovl P1, P2
cmp S1, S0
cmovge P0, S0
cmovge S0, S1
cmovg S1, P0
mov S2, P1
cmp P3, S2
