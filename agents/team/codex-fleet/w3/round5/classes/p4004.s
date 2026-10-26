# n=5 model=out iset=I1 prefix14_class=4004
cmp P2, P3
cmovle S2, P2
mov S0, P0
cmovg S2, P3
cmovl P2, P3
mov S1, S2
cmp S0, P1
cmovge S0, P1
cmovge P1, P0
cmp S2, S0
cmovge S1, S0
cmovge S0, S2
cmp P1, P2
cmovle P3, P1
