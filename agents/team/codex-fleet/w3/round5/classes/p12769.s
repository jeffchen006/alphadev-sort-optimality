# n=5 model=out iset=I1 prefix14_class=12769
cmp P3, P1
cmovl S2, P1
cmovle P1, P3
cmovl P3, S2
cmp P0, P2
cmovle S1, P0
cmovle P0, P2
mov S0, P1
cmovg S1, P2
cmp S1, P1
cmovle S0, S1
cmovle S1, P1
cmp P0, P3
cmovge S2, P0
