# n=5 model=out iset=I1 prefix14_class=13950
cmp P3, P1
cmovle S2, P3
cmovg S2, P1
cmovl P3, P1
cmp P0, P2
cmovl S1, P0
cmovge S1, P2
cmovge P2, P0
cmp P2, P3
cmovl S0, P3
cmovle P3, P2
cmovl P2, S0
cmp S2, S1
cmovle P2, S2
