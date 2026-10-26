# n=5 model=out iset=I1 prefix14_class=1086
cmp P0, P2
mov S1, P0
cmovl S1, P2
cmovle P2, P0
cmp P1, P3
cmovge S2, P3
cmovl S2, P1
cmovle P1, P3
cmp S1, P1
mov P3, P1
cmovg P1, S1
mov P1, P2
cmovle P3, S1
cmp S2, P1
