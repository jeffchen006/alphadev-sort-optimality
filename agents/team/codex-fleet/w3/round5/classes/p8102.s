# n=5 model=out iset=I1 prefix14_class=8102
cmp P2, P3
cmovge S1, P3
cmovl S1, P2
mov S2, P1
cmovl P2, P3
mov S0, P2
cmp P0, S2
cmovge S2, P0
cmovg P0, P1
cmp P0, S1
cmovle P3, S1
cmovl S1, P0
cmovle P0, P3
cmp P2, S2
