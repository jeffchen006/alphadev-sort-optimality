# n=5 model=out iset=I1 prefix14_class=6576
cmp P0, P2
mov S1, P0
mov S0, P3
cmovle P0, P2
mov S2, P0
cmovge S1, P2
cmp P3, P1
cmovl P3, P1
cmovl P1, S0
cmp S2, P3
cmovle P0, P3
cmovle P3, S2
cmp P1, S1
cmovge S0, P1
