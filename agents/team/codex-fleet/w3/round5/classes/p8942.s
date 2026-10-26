# n=5 model=out iset=I1 prefix14_class=8942
cmp P0, P2
cmovl S2, P2
cmovge S2, P0
cmovge P0, P2
cmp P3, P1
cmovle S0, P3
cmovl P3, P1
cmovle P1, S0
cmp P3, S2
cmovg P2, P3
cmovle P2, S2
cmovg P3, S2
cmp P0, P1
cmovl S1, P1
