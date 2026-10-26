# n=5 model=out iset=I1 prefix14_class=10593
cmp P2, P3
mov S0, P2
mov S2, P1
cmovge P2, P3
cmovge P3, S0
cmp P0, P1
cmovl S2, P0
cmovge P1, P0
cmp P1, P3
cmovl P0, P1
cmovle P1, P3
cmovl P3, P0
cmp S2, P2
cmovge S1, P2
