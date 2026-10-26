# n=5 model=out iset=I1 prefix14_class=11951
cmp P2, P3
cmovge S1, P2
cmovle S1, P3
mov S2, P1
cmovl P3, P2
cmp S2, P0
cmovl S2, P0
cmovle P0, P1
cmp S1, S2
cmovge S0, S1
cmovge S1, S2
cmovge S2, S0
cmp P0, P3
cmovle P1, P0
