# n=5 model=out iset=I1 prefix14_class=2582
cmp P3, P1
mov S2, P1
cmovg P1, P3
cmovg P3, S2
cmp P2, P0
cmovge S1, P2
cmovl S1, P0
cmovg P2, P0
cmp S1, P1
cmovl S0, S1
cmovl S1, P1
cmovge S0, P1
cmp P3, P2
cmovge S1, P2
