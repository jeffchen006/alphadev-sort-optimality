# n=5 model=out iset=I1 prefix14_class=9252
mov S2, P2
mov S1, P1
cmp P1, P0
cmovge S1, P0
cmovle P1, P0
cmp P3, P2
cmovle S2, P3
cmovg P2, P3
cmp S2, S1
cmovle P3, S1
cmovle S1, S2
cmovl S2, P3
cmp P1, P2
cmovl P0, P1
