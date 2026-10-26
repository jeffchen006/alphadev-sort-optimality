# n=5 model=out iset=I1 prefix14_class=314
mov S2, P2
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
cmovg P3, S1
cmp P0, S2
cmovge S2, P0
cmovl P2, P0
cmp P1, P2
cmovge P0, P2
cmovle P0, P1
cmovl P1, P2
cmp S2, P3
cmovle S0, S2
