# n=5 model=out iset=I1 prefix14_class=5709
mov S0, P0
cmp P0, P3
mov S2, P2
cmovge P0, P3
cmovg P3, S0
cmp P1, P2
cmovge S2, P1
cmovl P2, P1
cmp P2, P0
cmovl S0, P0
cmovl P0, P2
cmovl P2, S0
mov P0, P2
cmp P3, S2
