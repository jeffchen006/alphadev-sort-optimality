# n=5 model=out iset=I1 prefix14_class=14421
cmp P2, P1
cmovle S0, P2
cmovl P2, P1
cmovg S0, P1
cmp P0, P3
cmovle S2, P3
cmovg S2, P0
cmovle P3, P0
cmp P3, S0
cmovge S1, P3
cmovge P3, S0
cmovge S0, S1
cmp S2, P2
cmovle P0, S2
