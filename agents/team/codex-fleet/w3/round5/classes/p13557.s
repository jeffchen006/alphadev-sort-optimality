# n=5 model=out iset=I1 prefix14_class=13557
cmp P1, P3
cmovle S0, P1
cmovle P1, P3
cmovge S0, P3
cmp P2, P0
cmovle P3, P0
cmovl P0, P2
cmovl P2, P3
cmp P0, S0
cmovle S1, S0
cmovge S1, P0
cmovg P0, S0
cmp P1, P2
cmovge S2, P2
