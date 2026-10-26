# n=5 model=out iset=I1 prefix14_class=5535
mov S1, P2
cmp P0, P1
cmovle S2, P0
cmovle P0, P1
cmovle P1, S2
mov S0, P1
cmp P2, P3
cmovle P2, P3
cmovge S1, P3
cmp P1, S1
cmovl P1, S1
cmovge S0, S1
cmp P0, P2
cmovl S1, P0
