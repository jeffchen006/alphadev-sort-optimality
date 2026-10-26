# n=5 model=out iset=I1 prefix14_class=8651
mov S2, P2
cmp S2, P0
cmovge S2, P0
cmovl P2, P0
cmp P3, P1
mov S0, P2
cmovle S1, P1
cmovle P1, P3
cmovl P3, S1
cmp S0, P3
cmovge S0, P3
cmovge P3, P2
cmp P1, S2
cmovle P2, P1
