# n=5 model=out iset=I1 prefix14_class=13653
cmp P1, P3
cmovl S1, P3
cmovge S1, P1
cmovle P3, P1
cmp P2, P0
cmovle S2, P2
cmovle P2, P0
cmovl P0, S2
cmp S1, P2
cmovle S0, S1
cmovl S1, P2
cmovg S0, P2
cmp P0, P3
cmovl S1, P0
