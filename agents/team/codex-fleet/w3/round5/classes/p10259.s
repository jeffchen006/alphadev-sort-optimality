# n=5 model=out iset=I1 prefix14_class=10259
mov S0, P3
cmp P1, P2
cmovge S1, P2
cmovle S1, P1
cmovl P1, P2
cmp P3, P0
cmovle P3, P0
cmovge S0, P0
cmp P1, P3
mov P0, S1
cmovl P2, P1
cmovle P1, P3
cmovl P3, P2
cmp S0, P0
