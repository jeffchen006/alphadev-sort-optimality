# n=5 model=out iset=I1 prefix14_class=14119
mov S1, P2
cmp P1, P3
cmovle S2, P1
cmovge S2, P3
cmovge P3, P1
cmp P0, S1
cmovle S1, P0
cmovle P0, P2
cmp P3, P0
mov S0, S2
cmovle P2, P3
cmovl P3, P0
cmovl P0, P2
cmp S1, S2
