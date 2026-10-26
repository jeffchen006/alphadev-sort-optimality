# n=5 model=out iset=I1 prefix14_class=3528
cmp P1, P2
mov S0, P0
mov S2, P2
cmovg P2, P1
cmovge P1, S2
cmp P0, P3
cmovl P0, P3
cmovl P3, S0
mov S1, P1
cmp P3, P1
cmovl S1, P3
mov S1, P2
cmovg P1, P3
cmp P0, S1
