# n=5 model=out iset=I1 prefix14_class=7183
cmp P2, P0
mov S0, P1
cmovge S2, P0
cmovg P0, P2
cmovg P2, S2
cmp P1, P3
cmovl S0, P3
cmovl P3, P1
cmp P2, P3
mov P1, P3
cmovg P3, P2
cmovge P2, P1
mov S1, P0
cmovge P1, P3
