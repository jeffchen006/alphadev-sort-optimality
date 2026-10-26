# n=5 model=out iset=I1 prefix14_class=8285
mov S1, P0
cmp P2, S1
mov S0, P3
cmovl P0, P2
cmovge S1, P2
cmp P1, P3
cmovge S0, P1
cmovl P3, P1
mov S2, P0
cmp S2, P3
cmovle P0, P3
cmovge S2, P3
cmp S0, S1
cmovle P3, S1
