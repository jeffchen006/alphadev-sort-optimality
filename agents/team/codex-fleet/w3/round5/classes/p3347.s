# n=5 model=out iset=I1 prefix14_class=3347
cmp P3, P1
cmovle S1, P1
cmovl P1, P3
cmovg S1, P3
cmp P2, P0
mov S0, P1
cmovle S2, P2
cmovge S2, P0
cmovge P0, P2
cmp P1, S2
cmovge S0, S2
mov S0, P0
cmovg S2, P1
cmp P0, S1
