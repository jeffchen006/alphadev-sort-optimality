# n=5 model=out iset=I1 prefix14_class=13490
cmp P3, P1
mov S1, P1
cmovl P1, P3
cmovge S1, P3
cmp P0, P2
cmovle S2, P2
cmovl P2, P0
cmovl P0, S2
mov P3, P2
cmp P3, P1
cmovle P2, P1
cmovl P1, P3
cmp S1, P0
cmovle S2, S1
