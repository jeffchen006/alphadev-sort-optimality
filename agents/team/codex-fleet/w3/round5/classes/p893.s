# n=5 model=out iset=I1 prefix14_class=893
cmp P0, P2
cmovl S0, P2
cmovge S0, P0
cmovl P2, P0
cmovl P0, S0
cmp P1, P3
cmovle S1, P1
cmovge S1, P3
cmovge P3, P1
cmp P3, S0
cmovg S0, P3
cmovle P0, P3
cmp S1, P2
cmovle S2, S1
