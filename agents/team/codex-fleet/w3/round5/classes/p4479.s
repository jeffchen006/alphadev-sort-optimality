# n=5 model=out iset=I1 prefix14_class=4479
cmp P3, P1
cmovg S2, P3
cmovg P3, P1
cmovle S2, P1
cmp P2, P0
cmovle S1, P2
cmovl P2, P0
cmovge S1, P0
cmp P2, S2
cmovge S0, P2
cmovge P2, S2
cmovge S2, S0
cmp P3, S1
cmovge S2, P3
