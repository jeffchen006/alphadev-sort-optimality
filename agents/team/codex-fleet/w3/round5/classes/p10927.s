# n=5 model=out iset=I1 prefix14_class=10927
mov S1, P0
cmp P2, S1
cmovle P0, P2
cmovle P2, S1
cmp P1, P3
cmovl S2, P1
cmovle P1, P3
cmovl P3, S2
mov S0, P2
cmp P1, S0
cmovge S0, P1
cmovl P2, P1
cmp P0, P3
cmovle P1, P3
