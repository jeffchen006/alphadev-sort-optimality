# n=5 model=out iset=I1 prefix14_class=8951
cmp P1, P2
cmovge S1, P1
cmovle S1, P2
cmovge P1, P2
cmp P3, P0
cmovle S0, P3
cmovl P3, P0
cmovle P0, S0
cmp P3, S1
cmovge S2, P3
cmovg P3, S1
cmovl S2, S1
cmp P1, P0
cmovge S1, P1
