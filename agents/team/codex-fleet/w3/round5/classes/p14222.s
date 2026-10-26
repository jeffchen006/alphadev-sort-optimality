# n=5 model=out iset=I1 prefix14_class=14222
mov S0, P1
cmp P0, S0
cmovl S0, P0
mov S2, P3
cmovl P0, P1
cmp P2, P3
cmovge P3, P2
cmovg P2, S2
cmp P3, P0
cmovl S1, P0
cmovl P0, P3
cmovl P3, S1
mov P3, P2
cmp P3, S0
