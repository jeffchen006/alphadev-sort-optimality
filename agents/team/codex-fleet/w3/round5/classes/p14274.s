# n=5 model=out iset=I1 prefix14_class=14274
cmp P1, P3
mov S2, P2
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P0, S2
cmovg S2, P0
cmovle P2, P0
mov P0, S2
cmp P0, P1
cmovl P0, P1
cmovle P1, S2
cmp P2, P3
cmovge S2, P3
