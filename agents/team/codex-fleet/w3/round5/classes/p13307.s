# n=5 model=out iset=I1 prefix14_class=13307
cmp P1, P3
cmovge S2, P1
cmovl S2, P3
cmovl P3, P1
cmp P0, P2
cmovle S1, P2
cmovl P2, P0
cmovle P0, S1
cmp P3, P2
cmovge S1, P3
mov S0, S2
cmovge P3, P2
cmovge P2, S1
cmp S0, P0
