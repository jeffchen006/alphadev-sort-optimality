# n=5 model=out iset=I1 prefix14_class=9198
cmp P2, P3
mov S2, P3
cmovge S2, P2
cmovg P2, P3
cmp P1, P0
cmovge S0, P0
cmovg P0, P1
cmovge P1, S0
cmp P1, P2
mov S1, P1
cmovge P1, P2
cmovl S1, P2
cmp P0, S2
cmovl P3, P0
