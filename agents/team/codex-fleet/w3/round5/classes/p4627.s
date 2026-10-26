# n=5 model=out iset=I1 prefix14_class=4627
mov S1, P3
cmp P0, P3
cmovle P3, P0
cmovge S1, P0
cmp P2, P1
mov S0, P1
cmovle P1, P2
cmovl P2, S0
cmp P2, S1
cmovge S2, P2
cmovl S2, S1
cmovge P2, S1
cmp P1, P3
cmovle P0, P3
