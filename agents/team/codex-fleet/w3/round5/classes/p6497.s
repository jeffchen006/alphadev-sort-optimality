# n=5 model=out iset=I1 prefix14_class=6497
mov S1, P0
cmp P2, P0
cmovle S1, P2
cmovg P0, P2
cmp P3, P1
cmovle S2, P1
cmovl P1, P3
cmovge S2, P3
cmp S2, P0
cmovle P3, P0
cmovl P0, S2
cmovle S2, P3
cmp P1, S1
mov P2, P0
