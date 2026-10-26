# n=5 model=out iset=I1 prefix14_class=8053
cmp P3, P0
cmovge S2, P0
cmovle S2, P3
cmovl P3, P0
mov S1, P1
cmp S1, P2
cmovge S1, P2
cmovge P2, P1
mov S0, S2
cmp S2, S1
cmovle S2, S1
cmovge S0, S1
cmp P2, P3
mov S0, S2
