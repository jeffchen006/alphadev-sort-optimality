# n=5 model=out iset=I1 prefix14_class=9475
mov S2, P3
cmp P2, P1
cmovge S1, P2
cmovl S1, P1
cmovl P1, P2
cmp S2, P0
cmovge S2, P0
cmovg P0, P3
cmp S2, P1
cmovle P3, P1
cmovle P1, S2
cmovl S2, P3
cmp P0, S1
cmovl P1, P0
