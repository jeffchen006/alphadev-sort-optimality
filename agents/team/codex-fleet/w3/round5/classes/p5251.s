# n=5 model=out iset=I1 prefix14_class=5251
cmp P0, P1
cmovg S1, P0
cmovge P0, P1
cmovg P1, S1
cmp P3, P2
cmovl S0, P2
cmovle P2, P3
cmovl P3, S0
cmp P0, P2
cmovge S1, P2
cmovge P2, P0
cmovl S1, P0
cmp P3, P1
cmovle S2, P1
