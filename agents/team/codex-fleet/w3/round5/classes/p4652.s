# n=5 model=out iset=I1 prefix14_class=4652
mov S1, P0
mov S2, P1
cmp P0, P3
cmovge S1, P3
cmovge P3, P0
cmp P2, S2
cmovl P1, P2
cmovl P2, S2
mov S0, P3
cmp P3, P2
cmovg P3, P2
cmovl S0, P2
cmp P1, S1
cmovl P2, P1
