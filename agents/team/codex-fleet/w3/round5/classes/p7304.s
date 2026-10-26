# n=5 model=out iset=I1 prefix14_class=7304
cmp P0, P1
cmovl S0, P1
cmovle P1, P0
mov S1, P2
cmovl P0, S0
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmp P1, S1
cmovge S2, P1
cmovg P1, S1
cmovge S1, S2
mov P1, P0
cmp P3, P0
