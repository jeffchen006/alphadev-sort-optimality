# n=5 model=out iset=I1 prefix14_class=5859
mov S2, P2
cmp S2, P1
cmovl P2, P1
cmovge S2, P1
cmp P0, P3
cmovle P1, P3
cmovle P3, P0
cmovle P0, P1
mov S0, P2
cmp P0, S0
cmovl P2, P0
mov S1, P3
cmovge S0, P0
cmp S1, S2
