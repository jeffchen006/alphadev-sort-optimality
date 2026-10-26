# n=5 model=out iset=I1 prefix14_class=9322
cmp P1, P3
cmovl S2, P1
cmovle P1, P3
cmovl P3, S2
cmp P2, P0
mov S1, P0
cmovl S1, P2
cmovle P2, P0
cmp P3, S1
cmovge S0, S1
cmovge S1, P3
cmovl S0, P3
cmp P2, P1
cmovge P3, P2
