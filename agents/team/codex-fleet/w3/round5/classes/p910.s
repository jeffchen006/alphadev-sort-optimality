# n=5 model=out iset=I1 prefix14_class=910
mov S1, P3
cmp P3, P0
cmovl S1, P0
mov S2, P1
cmovle P0, P3
cmovle P3, S1
cmp S2, P2
cmovg P1, P2
cmovg P2, S2
cmp P2, P3
cmovl P3, P2
cmovge S1, P2
cmp P0, P1
mov P2, P3
