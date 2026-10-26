# n=5 model=out iset=I1 prefix14_class=3362
mov S0, P0
mov S2, P2
cmp P3, P0
cmovl P0, P3
cmovg S0, P3
cmp P1, P2
cmovl S2, P1
cmovg P2, P1
cmp P0, S2
cmovge S1, P0
cmovg P0, S2
cmovge S2, S1
mov P3, S2
cmp S0, P2
