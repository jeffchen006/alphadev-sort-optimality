# n=5 model=out iset=I1 prefix14_class=5544
mov S2, P2
cmp P2, P3
cmovle S2, P3
cmovg P2, P3
cmp P0, P1
mov S1, P0
cmovle P0, P1
cmovle P1, S1
mov S1, P2
cmp P1, P2
cmovge S1, P1
cmovl P2, P1
cmp S2, P0
cmovl P1, S2
