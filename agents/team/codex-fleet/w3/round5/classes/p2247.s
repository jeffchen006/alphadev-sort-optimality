# n=5 model=out iset=I1 prefix14_class=2247
cmp P1, P2
cmovg S1, P1
mov S0, P3
cmovle S1, P2
cmovge P1, P2
cmp P0, S0
cmovge S0, P0
mov S2, S0
cmovge P0, P3
cmp S0, S1
cmovle S0, S1
cmovle S1, S2
cmp P0, P1
cmovl P2, P0
