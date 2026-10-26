# n=5 model=out iset=I1 prefix14_class=13483
mov S1, P2
cmp P2, P1
cmovl S1, P1
cmovl P1, P2
cmp P0, P3
cmovle S0, P0
cmovge S0, P3
cmovl P0, P3
cmp P1, S0
cmovg P3, S0
cmovge S0, P1
cmovg P1, P3
cmp S1, P0
cmovle P1, S1
