# n=5 model=out iset=I1 prefix14_class=8362
cmp P0, P2
cmovl S1, P0
mov S0, P1
cmovle P0, P2
cmovl P2, S1
cmp P3, P1
cmovl P1, P3
cmovge S0, P3
cmp P1, P2
cmovge P3, P2
mov S2, S0
cmovg P2, P1
cmovge P1, P3
cmp S2, P0
