# n=5 model=out iset=I1 prefix14_class=293
cmp P3, P1
mov S2, P0
cmovge S1, P3
cmovg P3, P1
cmovge P1, S1
cmp P2, P0
cmovge S2, P2
cmovl P0, P2
cmp P3, P0
cmovle S1, P0
cmovle P0, P3
cmovl P3, S1
cmp S2, P1
mov S0, P1
