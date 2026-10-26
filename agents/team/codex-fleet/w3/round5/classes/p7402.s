# n=5 model=out iset=I1 prefix14_class=7402
mov S0, P3
cmp P1, P2
cmovl S2, P1
cmovl P1, P2
cmovl P2, S2
mov S1, P2
cmp P3, P0
cmovg P3, P0
cmovge P0, S0
cmp P3, P2
cmovge S1, P3
cmovg P3, P2
cmp P0, P1
cmovl S0, P1
