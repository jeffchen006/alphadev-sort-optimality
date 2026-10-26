# n=5 model=out iset=I1 prefix14_class=3420
mov S1, P1
cmp S1, P3
cmovle P1, P3
cmovl P3, S1
cmp P0, P2
cmovge S2, P0
cmovg P0, P2
cmovl S2, P2
cmp P0, P3
cmovge P2, P0
cmovl P2, P3
cmovle P3, P0
cmp P1, S2
cmovle P0, S2
