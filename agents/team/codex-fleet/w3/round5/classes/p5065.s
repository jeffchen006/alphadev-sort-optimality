# n=5 model=out iset=I1 prefix14_class=5065
mov S1, P0
cmp S1, P3
mov S2, P2
cmovl S1, P3
cmovl P3, P0
cmovg P0, P3
cmp P1, P2
cmovge S2, P1
cmovl P2, P1
cmp P3, P2
cmovge P0, P2
cmovle P3, P2
cmp S1, S2
cmovl P2, S1
