# n=5 model=out iset=I1 prefix14_class=13231
mov S2, P0
cmp P3, P1
cmovle S0, P1
cmovle P1, P3
cmovle P3, S0
cmp P0, P2
cmovle P0, P2
cmovge S2, P2
cmp P1, S2
cmovle S0, S2
cmovl S2, P1
mov S1, P0
cmovl P1, S0
cmp S1, P3
