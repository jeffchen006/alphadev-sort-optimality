# n=5 model=out iset=I1 prefix14_class=7483
cmp P1, P2
cmovge S1, P2
cmovle S1, P1
cmovl P1, P2
cmp P3, P0
cmovl S2, P3
cmovl P3, P0
cmovge S2, P0
cmp S2, S1
cmovle P2, S2
mov S0, P3
cmovle S2, S1
cmovl S1, P2
cmp P3, P1
