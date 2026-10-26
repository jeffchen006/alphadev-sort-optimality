# n=5 model=out iset=I1 prefix14_class=12849
mov S1, P3
cmp P2, P1
cmovle S2, P1
cmovl P1, P2
mov S0, P1
cmovl P2, S2
cmp S1, P0
cmovl P3, P0
cmovle P0, S1
cmp P1, P0
cmovle S0, P0
cmovle P0, P1
cmp P2, P3
cmovge S1, P3
