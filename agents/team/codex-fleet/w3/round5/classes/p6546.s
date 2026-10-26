# n=5 model=out iset=I1 prefix14_class=6546
cmp P3, P2
mov S1, P1
cmovl S2, P2
cmovge S2, P3
cmovle P2, P3
cmp P1, P0
cmovl P1, P0
cmovle P0, S1
mov S0, P1
cmp P1, S2
cmovl P1, S2
cmovg S0, S2
cmp P0, P2
cmovge S1, P0
