# n=5 model=out iset=I1 prefix14_class=6296
cmp P0, P1
cmovge S1, P0
cmovle S1, P1
cmovl P1, P0
cmovl P0, S1
mov S2, P2
cmp P2, P3
cmovg P2, P3
cmovge P3, S2
cmp P3, S1
cmovle P0, P3
cmovg S1, P3
cmp P1, P2
cmovge S0, P2
