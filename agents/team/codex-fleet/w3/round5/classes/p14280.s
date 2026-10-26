# n=5 model=out iset=I1 prefix14_class=14280
cmp P1, P0
cmovle S1, P0
cmovle P0, P1
mov S0, P2
cmovl P1, S1
cmp P3, P2
cmovg S0, P3
cmovl P2, P3
cmovle P3, S0
cmp S0, P1
cmovl P3, P1
cmovle P1, S0
cmp P0, P2
cmovge S2, P2
