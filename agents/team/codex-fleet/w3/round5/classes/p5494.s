# n=5 model=out iset=I1 prefix14_class=5494
mov S2, P3
cmp P1, S2
mov S1, P2
cmovge S2, P1
cmovle P3, P1
cmp S1, P0
cmovg P2, P0
cmovl S1, P0
mov P0, P2
cmp P0, P3
cmovle P2, P3
cmovle P3, P0
cmp S2, S1
cmovle P3, S2
