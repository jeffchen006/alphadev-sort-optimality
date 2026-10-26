# n=5 model=out iset=I1 prefix14_class=3713
cmp P0, P3
cmovle S1, P0
cmovge S1, P3
cmovl P0, P3
cmp P1, P2
cmovle S2, P1
cmovl P1, P2
cmovle P2, S2
mov S0, P1
cmp S1, P2
cmovle P3, P2
cmovl P2, S1
cmovle S1, P3
cmp P0, P1
