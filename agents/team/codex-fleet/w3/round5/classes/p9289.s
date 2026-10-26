# n=5 model=out iset=I1 prefix14_class=9289
cmp P1, P0
cmovg S2, P0
cmovle S2, P1
cmovge P0, P1
cmp P2, P3
cmovle S0, P3
cmovl P3, P2
mov S1, S2
cmovl P2, S0
cmp P3, S2
cmovle S2, P3
cmovge S1, P3
cmp P0, P2
cmovge P3, P2
