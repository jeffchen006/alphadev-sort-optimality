# n=5 model=out iset=I1 prefix14_class=3367
cmp P3, P1
mov S0, P1
cmovge S0, P3
cmovl P1, P3
mov S2, P0
cmp P2, P0
cmovle S2, P2
cmovge P0, P2
cmp P1, S2
cmovg S1, P1
cmovge P1, S2
cmovg S2, S1
cmp P0, S0
cmovl S1, S0
