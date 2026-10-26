# n=5 model=out iset=I1 prefix14_class=5247
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
cmovge P1, S0
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
cmovl P2, S1
cmp P3, P0
cmovge S2, P0
cmovl S2, P3
cmovg P0, P3
cmp P2, P1
cmovle S0, P1
