# n=5 model=out iset=I1 prefix14_class=9241
cmp P0, P2
cmovle S1, P2
cmovge S1, P0
mov S2, P1
cmovl P2, P0
cmp P3, S2
cmovge S2, P3
cmovl P1, P3
cmp P1, P2
cmovle S0, P2
cmovle P2, P1
cmovle P1, S0
mov P2, S2
cmp S1, P2
