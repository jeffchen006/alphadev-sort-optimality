# n=5 model=out iset=I1 prefix14_class=3722
mov S2, P3
cmp S2, P2
cmovle P3, P2
cmovl P2, S2
cmp P0, P1
cmovge S2, P0
cmovl S2, P1
cmovl P1, P0
cmovg P0, P1
cmp P2, P1
cmovle P1, P2
cmovg P0, P2
cmp P3, S2
cmovge S1, S2
