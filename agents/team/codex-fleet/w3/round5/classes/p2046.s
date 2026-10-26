# n=5 model=out iset=I1 prefix14_class=2046
cmp P2, P0
mov S1, P0
cmovl S1, P2
cmovge P0, P2
mov S0, P3
cmp S0, P1
cmovge P3, P1
cmovge P1, S0
mov S2, P1
cmp P1, P0
cmovl P1, P0
cmovg S2, P0
cmp P3, S1
cmovl P0, S2
