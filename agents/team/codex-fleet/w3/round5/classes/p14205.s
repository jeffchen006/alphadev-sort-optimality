# n=5 model=out iset=I1 prefix14_class=14205
cmp P3, P2
mov S2, P2
cmovge S2, P3
cmovge P3, P2
cmp P1, P0
mov S1, P3
mov S0, S2
cmovge P2, P0
cmovg P0, P1
cmovge P1, P2
cmp S2, P0
cmovl S2, P0
cmovge S0, P0
cmovl P0, S0
