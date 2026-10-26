# n=5 model=out iset=I1 prefix14_class=8106
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
mov S1, P3
cmovge S0, P2
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
mov S2, S1
cmp S0, S1
cmovle S1, S0
cmovle S0, S2
cmp P0, P1
cmovge S2, P0
