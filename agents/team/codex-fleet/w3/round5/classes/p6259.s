# n=5 model=out iset=I1 prefix14_class=6259
mov S2, P3
cmp P0, S2
cmovge S2, P0
cmovle P3, P0
mov S1, P2
cmp P1, S1
cmovg P2, P1
cmovle S1, P1
cmp P2, S2
cmovl S0, S2
mov P0, P3
cmovle S2, P2
cmovl P2, S0
cmp P0, S1
