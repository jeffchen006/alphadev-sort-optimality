# n=5 model=out iset=I1 prefix14_class=6579
cmp P0, P1
cmovl S1, P0
cmovl P0, P1
mov S2, P3
mov S0, P0
cmovge S1, P1
cmp S2, P2
cmovle P3, P2
cmovl P2, S2
cmp S0, P3
cmovle P0, P3
cmovle P3, S0
cmp S1, P2
cmovge S2, S1
