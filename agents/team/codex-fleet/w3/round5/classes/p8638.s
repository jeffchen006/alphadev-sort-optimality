# n=5 model=out iset=I1 prefix14_class=8638
mov S2, P3
cmp P2, S2
cmovge S2, P2
mov S1, S2
mov S0, P0
cmovg P2, P3
cmp P0, P1
cmovl S0, P1
cmovge P0, P1
cmp S0, S2
cmovl S2, S0
cmovge S1, S0
cmp P2, P0
cmovl P3, P2
