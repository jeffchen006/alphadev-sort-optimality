# n=5 model=out iset=I1 prefix14_class=2986
cmp P2, P0
cmovle S1, P0
cmovge S1, P2
cmovl P0, P2
cmp P1, P3
cmovge S2, P1
cmovge P1, P3
cmovge P3, S2
cmp S1, P3
cmovle S0, S1
cmovge S0, P3
cmovge P3, S1
cmp P0, P1
cmovg S2, P0
