# n=5 model=out iset=I1 prefix14_class=3549
cmp P2, P0
cmovl S0, P2
cmovl P2, P0
cmovl P0, S0
mov S2, P1
mov S1, P0
cmp S2, P3
cmovl S2, P3
cmovle P3, P1
cmp P3, P0
cmovl S1, P3
cmovge P0, P3
cmp P2, S2
cmovge P3, P0
