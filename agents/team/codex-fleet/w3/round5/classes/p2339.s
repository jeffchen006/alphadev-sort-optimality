# n=5 model=out iset=I1 prefix14_class=2339
cmp P3, P0
cmovle S2, P3
cmovle P3, P0
cmovle P0, S2
mov S1, P2
cmp S1, P1
cmovl S1, P1
cmovg P2, P1
cmovge P1, S1
cmp P3, S1
cmovl P1, P3
cmovge S1, P3
cmp P2, P0
cmovle S0, P0
