# n=5 model=out iset=I1 prefix14_class=548
mov S1, P1
mov S0, P0
cmp P0, P3
cmovg P0, P3
cmovg P3, S0
cmp P1, P2
cmovl P1, P2
cmovge S1, P2
mov S2, S1
cmp P0, S1
cmovl S1, P0
cmovge S2, P0
cmp P3, P1
mov P0, S2
