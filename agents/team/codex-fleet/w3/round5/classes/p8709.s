# n=5 model=out iset=I1 prefix14_class=8709
cmp P3, P2
cmovge S0, P2
cmovge P2, P3
cmovg P3, S0
cmp P1, P0
cmovge S1, P1
mov S2, P2
cmovg P1, P0
cmovl S1, P0
cmp S1, S2
cmovge S2, S1
cmovl P2, S1
mov S2, P3
cmp P3, P1
