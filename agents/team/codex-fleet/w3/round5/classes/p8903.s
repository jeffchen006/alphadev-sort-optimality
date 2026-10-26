# n=5 model=out iset=I1 prefix14_class=8903
cmp P3, P0
cmovl S0, P3
cmovge S0, P0
cmovl P3, P0
cmp P2, P1
cmovle S1, P2
cmovg S1, P1
cmovl P2, P1
cmp P3, P2
cmovl S2, P2
cmovge S2, P3
cmovle P2, P3
cmp S0, S1
cmovle P0, S1
