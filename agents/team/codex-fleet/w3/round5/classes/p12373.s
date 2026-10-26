# n=5 model=out iset=I1 prefix14_class=12373
mov S2, P0
cmp P2, P0
cmovl P0, P2
cmovle P2, S2
cmp P1, P3
cmovge S0, P3
cmovle S0, P1
cmovl P1, P3
cmp S0, P0
cmovle S1, P0
cmovl P0, S0
cmovle S0, S1
cmp P1, P2
cmovge S2, P2
