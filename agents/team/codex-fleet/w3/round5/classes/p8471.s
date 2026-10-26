# n=5 model=out iset=I1 prefix14_class=8471
cmp P2, P0
cmovle S0, P2
cmovl P2, P0
mov S1, P1
cmovge S0, P0
cmp P1, P3
cmovle P1, P3
cmovle P3, S1
cmp P1, P2
cmovle S1, P2
cmovl P2, P1
mov S2, P2
cmovl P1, S1
cmp S0, P3
