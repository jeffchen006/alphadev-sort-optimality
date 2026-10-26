# n=5 model=out iset=I1 prefix14_class=3199
cmp P0, P3
cmovge S0, P3
cmovl S0, P0
cmovg P3, P0
cmp P1, P2
cmovge S1, P2
cmovge P2, P1
cmovle S1, P1
cmp S1, S0
cmovle P1, S0
cmovg P1, S1
cmovge S1, S0
cmp P2, P3
cmovle S2, P3
