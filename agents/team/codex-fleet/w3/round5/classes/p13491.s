# n=5 model=out iset=I1 prefix14_class=13491
cmp P3, P1
cmovle S1, P1
cmovl P1, P3
cmovge S1, P3
cmp P0, P2
cmovle P3, P2
cmovl P2, P0
cmovl P0, P3
mov S2, P2
cmp S2, P1
cmovl P2, P1
cmovl P1, S2
cmp S1, P0
cmovle P3, S1
