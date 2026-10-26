# n=5 model=out iset=I1 prefix14_class=6727
cmp P3, P2
cmovge S1, P2
cmovge P2, P3
cmovge P3, S1
mov S1, P1
cmp P1, P0
cmovge P1, P0
cmovl S1, P0
cmp P2, S1
cmovge S2, P2
cmovg P2, S1
cmovge S1, S2
cmp P3, P1
cmovge S0, P3
