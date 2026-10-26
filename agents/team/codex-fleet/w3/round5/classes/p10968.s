# n=5 model=out iset=I1 prefix14_class=10968
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P0, P2
mov S0, P0
cmovg P0, P2
cmovg P2, S0
cmp P2, P3
mov S2, P3
cmovle P3, P2
cmovge S2, P2
cmp P1, P0
cmovle P2, P0
