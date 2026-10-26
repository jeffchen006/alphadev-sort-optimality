# n=5 model=out iset=I1 prefix14_class=8468
cmp P3, P0
cmovle S0, P3
cmovge S0, P0
mov S1, P1
cmovle P3, P0
cmp P1, P2
cmovle P1, P2
cmovle P2, S1
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
mov S2, P3
cmovl P1, S1
cmp S0, P2
