# n=5 model=out iset=I1 prefix14_class=2133
mov S0, P3
cmp P3, P0
mov S2, P1
cmovle S0, P0
cmovle P0, P3
cmp S2, P2
mov P3, S0
cmovle P1, P2
cmovge S2, P2
cmp S0, P1
cmovl P3, P1
cmovle P1, S0
cmp S2, P0
cmovle S1, S2
