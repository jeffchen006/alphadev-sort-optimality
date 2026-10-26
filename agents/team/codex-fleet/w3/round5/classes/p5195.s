# n=5 model=out iset=I1 prefix14_class=5195
mov S1, P2
cmp S1, P1
cmovle P2, P1
cmovle P1, S1
cmp P3, P0
mov S2, P0
cmovl P0, P3
cmovl P3, S2
cmp P1, P0
cmovge S0, P1
cmovge P1, P0
cmovge P0, S0
cmp P2, P3
mov S2, P3
