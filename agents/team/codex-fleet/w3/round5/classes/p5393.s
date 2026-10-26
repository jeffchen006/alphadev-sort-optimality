# n=5 model=out iset=I1 prefix14_class=5393
cmp P0, P1
cmovge S1, P1
mov S0, P2
cmovl S1, P0
cmovle P0, P1
cmp S0, P3
cmovle P2, P3
cmovge S0, P3
cmp S1, S0
cmovge P3, S0
cmovl P3, S1
cmovge S0, S1
cmp P2, P0
cmovle S2, P0
