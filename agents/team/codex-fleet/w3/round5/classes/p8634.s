# n=5 model=out iset=I1 prefix14_class=8634
cmp P0, P2
cmovl S0, P0
cmovge S0, P2
cmovge P2, P0
cmp P1, P3
cmovge P0, P1
mov S2, P2
cmovg P1, P3
cmovg P3, P0
cmp P3, P2
cmovge S2, P3
cmovge P3, P2
cmp P1, S0
mov S1, P1
