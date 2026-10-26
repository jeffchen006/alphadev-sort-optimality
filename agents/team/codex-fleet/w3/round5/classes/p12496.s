# n=5 model=out iset=I1 prefix14_class=12496
mov S1, P0
cmp P1, P3
cmovle S0, P3
cmovle P3, P1
cmovle P1, S0
cmp P2, P0
cmovl P0, P2
mov S2, P0
cmovge S1, P2
cmp P0, P3
cmovle S2, P3
cmovg P0, P3
cmp P1, S1
cmovle P0, S1
