# n=5 model=out iset=I1 prefix14_class=9126
mov S0, P2
cmp P2, P3
cmovl P2, P3
cmovge S0, P3
cmp P0, P1
cmovge S2, P0
mov P3, S0
cmovge P0, P1
cmovg P1, S2
cmp P0, P3
cmovl S0, P0
cmovg P3, P0
cmp P2, P1
cmovl S1, P1
