# n=5 model=out iset=I1 prefix14_class=7145
cmp P2, P0
mov S2, P3
cmovl S0, P2
cmovge S0, P0
cmovge P0, P2
cmp P3, P1
cmovg S2, P1
cmovg P1, P3
cmp S2, S0
cmovge S1, S0
mov P2, P0
cmovge S0, S2
cmovge S2, S1
cmp P1, P0
