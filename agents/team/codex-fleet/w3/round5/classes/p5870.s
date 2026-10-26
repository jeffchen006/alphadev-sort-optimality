# n=5 model=out iset=I1 prefix14_class=5870
cmp P1, P0
mov S0, P3
cmovle S1, P0
cmovge S1, P1
cmovge P1, P0
cmp P2, P3
mov S2, S1
cmovle S0, P2
cmovl P2, P3
cmp P2, S1
cmovg S1, P2
cmovl S2, P2
cmp S0, P1
cmovle P0, S0
