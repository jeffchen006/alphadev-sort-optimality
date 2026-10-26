# n=5 model=out iset=I1 prefix14_class=7482
cmp P1, P2
cmovge S1, P2
cmovl S1, P1
cmovl P1, P2
cmp P3, P0
cmovl S2, P3
cmovle P3, P0
cmovge S2, P0
cmp S2, S1
cmovle S0, S2
cmovle S2, S1
cmovle S1, S0
cmp P1, P3
mov P2, P1
