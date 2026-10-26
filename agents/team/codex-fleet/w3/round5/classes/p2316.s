# n=5 model=out iset=I1 prefix14_class=2316
mov S0, P3
cmp P3, P2
mov S1, P0
cmovg S0, P2
cmovl P3, P2
cmp P0, P1
cmovle S1, P1
cmovge P0, P1
cmp P3, S1
cmovg S2, P3
cmovle S2, S1
cmovl S1, P3
cmp S0, P0
cmovge S2, S0
