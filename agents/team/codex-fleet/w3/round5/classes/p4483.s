# n=5 model=out iset=I1 prefix14_class=4483
cmp P3, P2
cmovg S2, P3
cmovg P3, P2
cmovle S2, P2
cmp P1, P0
cmovle S0, P1
cmovl P1, P0
cmovg S0, P0
cmp P1, S2
cmovge S1, P1
cmovge P1, S2
cmovg S2, S1
cmp S0, P3
cmovg S2, S0
