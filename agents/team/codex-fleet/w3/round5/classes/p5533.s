# n=5 model=out iset=I1 prefix14_class=5533
cmp P0, P3
cmovle S2, P0
mov S1, P2
cmovle P0, P3
cmovl P3, S2
mov S0, P3
cmp S1, P1
cmovl P2, P1
cmovge S1, P1
cmp P3, S1
cmovl P3, S1
cmovge S0, S1
cmp P2, P0
cmovle S1, P2
