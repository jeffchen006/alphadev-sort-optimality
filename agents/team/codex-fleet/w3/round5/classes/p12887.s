# n=5 model=out iset=I1 prefix14_class=12887
cmp P1, P2
cmovl S1, P1
cmovl P1, P2
cmovge S1, P2
cmp P3, P0
cmovl P2, P0
cmovle P0, P3
cmovl P3, P2
mov S2, P1
cmp P0, S1
cmovl S0, P0
cmovge S0, S1
cmovle P0, S1
cmp P3, P1
