# n=5 model=out iset=I1 prefix14_class=2710
cmp P0, P1
cmovge S1, P0
cmovl S1, P1
cmovle P1, P0
cmp P2, P3
cmovle S0, P2
cmovl P2, P3
cmovl P3, S0
mov S2, P2
cmp S1, S2
cmovl P2, S1
cmovle S1, S2
mov P0, P2
cmp P1, P3
