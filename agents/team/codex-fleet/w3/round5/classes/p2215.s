# n=5 model=out iset=I1 prefix14_class=2215
mov S0, P3
mov S1, P0
cmp P2, S0
cmovge P3, P2
cmovge P2, S0
cmp P1, P0
cmovg P0, P1
cmovg P1, S1
mov S2, P0
cmp P0, P3
cmovl S2, P3
cmovl P3, P0
cmp P1, P2
cmovge S2, P2
