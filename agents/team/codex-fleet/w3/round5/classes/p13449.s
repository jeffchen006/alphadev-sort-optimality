# n=5 model=out iset=I1 prefix14_class=13449
cmp P0, P1
cmovge S2, P0
cmovl S2, P1
cmovl P1, P0
cmp P3, P2
mov S0, P1
cmovle S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P1, P2
cmovle P1, P2
cmovge S0, P2
cmp S2, P3
cmovle P2, S2
