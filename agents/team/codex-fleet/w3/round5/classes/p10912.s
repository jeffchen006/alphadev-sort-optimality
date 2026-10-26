# n=5 model=out iset=I1 prefix14_class=10912
cmp P1, P0
cmovle S2, P1
cmovle P1, P0
cmovl P0, S2
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
cmovge S2, P2
cmp S2, P1
cmovle S1, S2
cmovle S2, P1
cmovle P1, S1
cmp P0, P3
cmovle S1, P3
