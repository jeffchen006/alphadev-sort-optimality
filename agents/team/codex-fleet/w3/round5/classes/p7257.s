# n=5 model=out iset=I1 prefix14_class=7257
cmp P0, P2
cmovle S2, P0
mov S1, P3
cmovl P0, P2
cmovle P2, S2
cmp P1, S1
cmovle P3, P1
mov S0, P2
cmovl P1, S1
cmp S0, P3
cmovge S0, P3
cmovle P2, P3
cmp P1, P0
cmovle P3, P0
