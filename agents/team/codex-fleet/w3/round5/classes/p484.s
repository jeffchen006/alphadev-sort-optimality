# n=5 model=out iset=I1 prefix14_class=484
mov S1, P0
cmp P2, P3
cmovle S0, P3
cmovl P3, P2
cmovge S0, P2
cmp S1, P1
cmovge S1, P1
cmovge P1, P0
cmp P3, S1
cmovle P0, S1
cmovle S1, P3
cmovl P3, P0
cmp S0, P1
cmovge S2, S0
