# n=5 model=out iset=I1 prefix14_class=14231
cmp P0, P2
cmovge S2, P0
cmovg P0, P2
mov S1, P1
cmovge P2, S2
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
mov S0, P2
cmp P2, S1
cmovge P2, S1
cmovg S1, S0
cmp P0, P3
cmovle S2, P0
