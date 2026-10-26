# n=5 model=out iset=I1 prefix14_class=710
cmp P1, P2
cmovge S0, P2
cmovle S0, P1
mov S2, P0
cmovl P1, P2
cmp P0, P3
mov S1, P1
cmovge S2, P3
cmovle P0, P3
cmp S1, P0
cmovle S1, P0
cmovl P0, P1
mov S1, S2
cmp S2, S0
