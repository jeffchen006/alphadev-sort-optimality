# n=5 model=out iset=I1 prefix14_class=13191
mov S2, P0
cmp P2, S2
cmovge S2, P2
cmovle P0, P2
cmp P1, P3
cmovle P2, P1
mov S1, P0
cmovle P1, P3
cmovl P3, P2
cmp S1, P3
cmovg P0, P3
cmovle S1, P3
cmp S2, P1
cmovl P2, P1
