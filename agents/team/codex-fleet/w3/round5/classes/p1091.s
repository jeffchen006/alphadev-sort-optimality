# n=5 model=out iset=I1 prefix14_class=1091
cmp P3, P0
cmovle S1, P3
cmovl P3, P0
cmovl P0, S1
mov S2, P3
mov S0, P1
cmp S0, P2
cmovge S0, P2
cmovle P1, P2
cmp S2, P1
cmovle P3, P1
cmovle P1, S2
cmp S0, P0
cmovle P2, P0
