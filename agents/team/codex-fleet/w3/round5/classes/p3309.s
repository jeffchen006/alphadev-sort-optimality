# n=5 model=out iset=I1 prefix14_class=3309
mov S1, P1
cmp P2, S1
cmovg S1, P2
cmovl P1, P2
cmp P3, P0
cmovge S2, P0
cmovle S2, P3
cmovge P0, P3
cmp P1, S2
mov S0, P1
cmovl P1, S2
cmovg S0, S2
cmp P0, S1
cmovge P3, S1
