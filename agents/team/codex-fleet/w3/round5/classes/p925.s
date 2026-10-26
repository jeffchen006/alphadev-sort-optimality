# n=5 model=out iset=I1 prefix14_class=925
mov S2, P1
cmp P3, S2
mov S0, P0
cmovge S2, P3
cmovl P1, P3
cmp S0, P2
cmovge S0, P2
cmovg P2, P0
mov P0, S2
cmp P2, P0
mov S1, S0
cmovge S2, P2
cmovl P0, P2
cmovg P2, P0
