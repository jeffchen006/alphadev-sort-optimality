# n=5 model=out iset=I1 prefix14_class=2340
cmp P1, P0
cmovle S2, P1
cmovle P1, P0
cmovl P0, S2
mov S1, P2
cmp S1, P3
cmovl S1, P3
cmovg P2, P3
cmovge P3, S1
cmp P1, S1
cmovle P3, P1
cmovge S1, P1
cmp P2, P0
cmovle S0, P0
