# n=5 model=out iset=I1 prefix14_class=5614
cmp P0, P1
cmovl S0, P0
cmovle P0, P1
cmovge S0, P1
mov S2, P2
cmp P2, P3
mov S1, S0
cmovl P2, P3
cmovle P3, S2
cmp S1, P3
cmovge S1, P3
cmovge P3, S0
cmp P2, P0
cmovle P1, P2
