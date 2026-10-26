# n=5 model=out iset=I1 prefix14_class=4956
cmp P3, P2
mov S2, P2
cmovge S2, P3
cmovg P3, P2
mov S1, P0
cmp S1, P1
cmovle S1, P1
cmovle P1, P0
cmp P3, P1
cmovg P0, P3
cmovg P3, P1
cmovg P1, P0
cmp S1, S2
cmovl P2, S1
