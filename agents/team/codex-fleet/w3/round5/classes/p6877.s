# n=5 model=out iset=I1 prefix14_class=6877
mov S0, P2
cmp P1, S0
cmovle P2, P1
cmovl P1, S0
mov S2, P0
cmp S2, P3
mov S1, P1
cmovle P0, P3
cmovle P3, S2
cmp P0, P1
cmovge S1, P0
cmovl P1, P0
cmp P3, P2
cmovge S1, P3
