# n=5 model=out iset=I1 prefix14_class=6354
cmp P3, P1
mov S2, P2
cmovge S1, P3
cmovge P3, P1
cmovge P1, S1
cmp P2, P0
cmovge S2, P0
mov S0, P1
cmovg P0, P2
cmp P0, S0
cmovl S0, P0
cmovge P1, P0
cmp P3, S2
mov P1, S0
