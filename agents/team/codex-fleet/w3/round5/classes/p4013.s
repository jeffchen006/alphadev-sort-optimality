# n=5 model=out iset=I1 prefix14_class=4013
cmp P3, P1
mov S0, P0
cmovle S2, P3
cmovge S2, P1
cmovl P3, P1
cmp P0, P2
cmovge S0, P2
mov S1, S2
cmovge P2, P0
cmp S2, S0
cmovg S2, S0
cmovge S0, S1
cmp P3, P2
cmovle S1, P2
