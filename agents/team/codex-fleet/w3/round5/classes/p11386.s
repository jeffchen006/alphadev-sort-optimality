# n=5 model=out iset=I1 prefix14_class=11386
cmp P0, P2
cmovl S0, P0
cmovge S0, P2
mov S2, P1
cmovle P0, P2
cmp P1, P3
cmovl P1, P3
cmovge S2, P3
cmp P1, P0
cmovle P2, P0
cmovle P0, P1
cmovle P1, P2
mov S1, S2
cmp S0, S2
