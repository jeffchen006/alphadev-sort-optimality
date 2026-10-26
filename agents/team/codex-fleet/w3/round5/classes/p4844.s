# n=5 model=out iset=I1 prefix14_class=4844
mov S2, P2
cmp P3, S2
cmovle P2, P3
cmovge S2, P3
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
cmovg P0, S1
cmp P2, P1
mov P3, P1
cmovg P3, P2
cmovl P1, P2
cmp P0, S2
cmovle S0, S2
