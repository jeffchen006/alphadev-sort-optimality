# n=5 model=out iset=I1 prefix14_class=4472
cmp P2, P0
cmovl S1, P2
cmovge S1, P0
cmovl P2, P0
cmp P1, P3
cmovg S0, P1
cmovle S0, P3
cmovl P3, P1
cmp P2, S0
cmovg S2, S0
cmovge S0, P2
cmovle S2, P2
cmp P3, S1
cmovg S0, P3
