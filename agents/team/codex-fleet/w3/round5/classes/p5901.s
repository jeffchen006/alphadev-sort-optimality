# n=5 model=out iset=I1 prefix14_class=5901
cmp P1, P2
cmovge S2, P1
cmovl S2, P2
cmovg P1, P2
cmp P0, P3
mov S0, P3
cmovge P3, P0
cmovge P0, S0
cmp P3, S2
cmovl S1, P3
cmovl P3, S2
mov P2, P0
cmovl S2, S1
cmp P2, P1
