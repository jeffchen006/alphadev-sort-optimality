# n=5 model=out iset=I1 prefix14_class=14468
cmp P3, P0
cmovge S0, P3
cmovge P3, P0
cmovge P0, S0
cmp P1, P2
mov S2, P1
cmovl P1, P2
cmovg S2, P2
cmp S2, P3
cmovle S1, P3
cmovge S1, S2
cmovl P3, S2
cmp P1, P0
cmovl P2, P1
