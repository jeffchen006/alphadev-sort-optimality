# n=5 model=out iset=I1 prefix14_class=10997
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovge S1, P2
cmp P0, P1
cmovle S2, P0
cmovle P0, P1
cmovl P1, S2
mov S0, P0
cmp S0, P3
cmovle S0, P3
cmovle P3, P0
cmp S1, P1
cmovle P0, P1
