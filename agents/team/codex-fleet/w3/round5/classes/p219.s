# n=5 model=out iset=I1 prefix14_class=219
cmp P0, P2
cmovle S1, P2
cmovle P2, P0
cmovge S1, P0
cmp P1, P3
cmovge S0, P1
cmovg P1, P3
cmovge P3, S0
cmp P1, P2
mov S2, P1
cmovl P1, P2
cmovle P2, S2
cmovl S2, P1
cmp P3, S1
