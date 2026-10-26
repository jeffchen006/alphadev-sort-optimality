# n=5 model=out iset=I1 prefix14_class=13348
cmp P0, P1
cmovl S1, P0
cmovle P0, P1
mov S0, P2
cmovl P1, S1
cmp P3, P2
cmovle P2, P3
mov S2, P1
cmovge S0, P3
cmp P2, P1
cmovg S2, P2
cmovl P1, P2
cmp P0, S0
cmovl S1, S0
