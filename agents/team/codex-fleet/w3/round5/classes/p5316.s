# n=5 model=out iset=I1 prefix14_class=5316
cmp P1, P3
cmovg S2, P3
cmovle S2, P1
cmovge P3, P1
mov S1, P2
cmp P2, P0
cmovl P2, P0
cmovg S1, P0
mov S0, S1
cmp S1, S2
cmovle S0, S2
cmovle S2, S1
cmp P2, P3
cmovle S1, P3
