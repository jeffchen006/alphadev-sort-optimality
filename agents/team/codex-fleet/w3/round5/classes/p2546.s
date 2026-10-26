# n=5 model=out iset=I1 prefix14_class=2546
cmp P0, P1
mov S2, P1
cmovl P1, P0
cmovle P0, S2
cmp P3, P2
cmovl S0, P3
cmovl P3, P2
cmovl P2, S0
cmp P0, P3
cmovge S2, P3
mov S1, P1
cmovl S2, P0
cmovle P0, P3
cmp P2, S1
