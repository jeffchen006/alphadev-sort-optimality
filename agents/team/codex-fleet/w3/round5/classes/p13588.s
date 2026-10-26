# n=5 model=out iset=I1 prefix14_class=13588
cmp P2, P3
cmovge S1, P2
mov S0, P0
cmovge P2, P3
cmovge P3, S1
cmp P1, S0
cmovl P0, P1
cmovl P1, S0
cmp P2, P0
cmovg S2, P0
cmovle S2, P2
cmovl P2, P0
cmp P1, P3
cmovle S2, P3
