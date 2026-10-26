# n=5 model=out iset=I1 prefix14_class=1920
mov S2, P3
cmp P0, P3
cmovl S2, P0
cmovl P0, P3
cmp P2, P1
cmovl S1, P1
cmovge S1, P2
cmovle P1, P2
cmp P0, S1
cmovle P2, P0
cmovle P0, S1
cmovg P2, S1
mov P0, P2
cmp S2, P1
