# n=5 model=out iset=I1 prefix14_class=8674
cmp P1, P3
mov S1, P3
cmovge S1, P1
cmovge P1, P3
cmp P2, P0
mov S0, S1
cmovl P3, P0
cmovl P0, P2
cmovl P2, P3
cmp P2, S1
cmovge S0, P2
cmovg P2, S1
cmp P0, P1
cmovge S2, P1
