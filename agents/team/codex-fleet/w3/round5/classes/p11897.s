# n=5 model=out iset=I1 prefix14_class=11897
mov S2, P2
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
cmovge P0, S0
cmp P1, P2
cmovg P2, P1
cmovl S2, P1
cmp P3, P2
mov P1, P0
cmovge S1, P3
cmovg P3, P2
cmovge P2, S1
cmp P1, S2
