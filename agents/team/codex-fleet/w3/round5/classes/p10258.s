# n=5 model=out iset=I1 prefix14_class=10258
cmp P0, P3
cmovle S1, P0
mov S2, P2
cmovge S1, P3
cmovl P0, P3
cmp S2, P1
cmovge S2, P1
cmovle P2, P1
cmp P0, P2
cmovle P1, P0
cmovl P0, P2
cmovle P2, P1
cmp S2, S1
cmovle P3, S1
