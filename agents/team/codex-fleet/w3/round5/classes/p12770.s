# n=5 model=out iset=I1 prefix14_class=12770
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmovl P3, S1
cmp P0, P2
mov S0, P2
cmovl S0, P0
cmovle P0, P2
cmp P1, S0
mov S2, S0
cmovl S2, P1
cmovle P1, S0
cmp P0, P3
cmovge S0, P0
