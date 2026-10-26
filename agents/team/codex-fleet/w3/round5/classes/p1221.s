# n=5 model=out iset=I1 prefix14_class=1221
cmp P1, P3
cmovle S2, P1
cmovle P1, P3
cmovl P3, S2
cmp P0, P2
cmovge S0, P0
cmovge P0, P2
cmovl S0, P2
cmp P1, S0
cmovge S1, P1
cmovge P1, S0
cmovge S0, S1
cmp P3, P0
mov S1, P3
