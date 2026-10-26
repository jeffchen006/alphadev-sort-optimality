# n=5 model=out iset=I1 prefix14_class=13802
mov S1, P2
mov S2, P3
cmp S2, P1
cmovge S2, P1
cmovle P3, P1
cmp P2, P0
cmovge S1, P0
cmovl P2, P0
cmp P2, P3
cmovle P1, P3
cmovl P3, P2
cmovle P2, P1
cmp S2, S1
cmovg P2, S2
