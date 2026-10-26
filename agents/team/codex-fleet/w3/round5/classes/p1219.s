# n=5 model=out iset=I1 prefix14_class=1219
cmp P1, P3
cmovle S0, P1
cmovl P1, P3
cmovl P3, S0
cmp P2, P0
mov S2, P2
cmovge P2, P0
cmovle S2, P0
cmp P1, S2
cmovge S1, P1
cmovge P1, S2
cmovg S2, S1
cmp P3, P2
cmovge S1, P3
