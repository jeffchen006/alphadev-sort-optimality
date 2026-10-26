# n=5 model=out iset=I1 prefix14_class=10911
cmp P2, P0
cmovl S2, P2
cmovle P2, P0
cmovl P0, S2
cmp P1, P3
cmovl S2, P3
cmovle P3, P1
cmovge S2, P1
cmp S2, P2
cmovle S0, S2
cmovl S2, P2
cmovle P2, S0
cmp P0, P3
cmovle S0, P3
