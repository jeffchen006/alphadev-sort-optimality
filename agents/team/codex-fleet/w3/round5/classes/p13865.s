# n=5 model=out iset=I1 prefix14_class=13865
cmp P3, P0
cmovge S0, P3
cmovg P3, P0
cmovge P0, S0
cmp P2, P1
cmovge S2, P1
cmovge P1, P2
cmovg P2, S2
cmp P1, P0
cmovge S1, P0
cmovge P0, P1
cmovge P1, S1
mov S2, P2
cmovl S1, P1
