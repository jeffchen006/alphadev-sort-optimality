# n=5 model=out iset=I1 prefix14_class=12228
cmp P0, P3
cmovle S1, P0
mov S2, P2
cmovle P0, P3
cmovle P3, S1
cmp P1, S2
cmovl S2, P1
cmovge P2, P1
cmp P3, S2
cmovle S0, S2
cmovge S0, P3
cmovl S2, P3
cmp P2, P0
cmovle S1, P0
