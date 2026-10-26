# n=5 model=out iset=I1 prefix14_class=5389
cmp P1, P0
mov S2, P0
cmovl P0, P1
mov S0, P3
cmovl P1, S2
cmp P3, P2
cmovge P3, P2
cmovl S0, P2
cmp P3, P0
mov P2, P0
cmovl P2, P3
cmovg P0, P3
cmp P1, S0
cmovl S2, S0
