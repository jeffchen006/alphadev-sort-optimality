# n=5 model=out iset=I1 prefix14_class=8308
mov S0, P2
cmp P1, P0
cmovg S1, P1
cmovle S1, P0
cmovl P0, P1
cmp P2, P3
cmovge P2, P3
cmovle S0, P3
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
cmovge S2, P2
cmp S1, S0
cmovg P2, S1
