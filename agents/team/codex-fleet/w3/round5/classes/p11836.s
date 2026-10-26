# n=5 model=out iset=I1 prefix14_class=11836
cmp P0, P1
cmovl S0, P0
cmovle P0, P1
mov S2, P0
cmovl P1, S0
mov S1, P2
cmp P2, P3
cmovl P2, P3
cmovl P3, S1
cmp P2, S2
cmovge S2, P2
cmovle P0, P2
cmp P1, P3
cmovg S0, P3
