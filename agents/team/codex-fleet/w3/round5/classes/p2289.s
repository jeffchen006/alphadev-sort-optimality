# n=5 model=out iset=I1 prefix14_class=2289
mov S0, P2
cmp P0, P3
cmovle S2, P0
cmovge S2, P3
cmovl P0, P3
cmp P2, P1
cmovl P2, P1
mov S1, P0
cmovle P1, S0
cmp P2, P0
cmovle S1, P2
cmovg P0, P2
mov P0, S1
mov P3, P1
