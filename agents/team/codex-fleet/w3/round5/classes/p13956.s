# n=5 model=out iset=I1 prefix14_class=13956
mov S0, P0
cmp P1, P3
cmovle S2, P1
cmovge S2, P3
cmovl P1, P3
cmp P2, S0
cmovle S0, P2
cmovge P0, P2
cmp P0, P1
cmovle P2, P1
cmovle P1, P0
cmovl P0, P2
cmp S0, S2
mov P0, P1
