# n=5 model=out iset=I1 prefix14_class=6300
mov S1, P3
cmp P0, S1
cmovl S1, P0
cmovge P3, P0
mov S2, P1
cmp P1, P2
cmovg P1, P2
cmovg P2, S2
cmp P2, P3
cmovge S0, P3
cmovg P3, P2
mov P0, P1
cmovge P2, S0
cmp P0, S1
