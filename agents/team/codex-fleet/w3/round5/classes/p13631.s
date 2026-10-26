# n=5 model=out iset=I1 prefix14_class=13631
cmp P2, P1
cmovl S2, P1
cmovl P1, P2
cmovge S2, P2
cmp P0, P3
cmovge S1, P0
cmovl S1, P3
cmovg P0, P3
cmp P1, P0
cmovge S0, P0
cmovge P0, P1
cmovge P1, S0
cmp S2, S1
cmovge P1, S1
