# n=5 model=out iset=I1 prefix14_class=7468
mov S1, P1
cmp P2, P0
cmovl S0, P0
cmovle P0, P2
cmovge S0, P2
cmp P3, S1
cmovle P1, P3
cmovle P3, S1
cmp P0, P1
cmovl S1, P0
cmovle P0, P1
mov S2, S0
cmovl P1, S1
cmp P3, S2
