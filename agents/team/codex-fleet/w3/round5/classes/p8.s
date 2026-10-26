# n=5 model=out iset=I1 prefix14_class=8
mov S1, P0
cmp P1, S1
cmovl S1, P1
cmovl P1, P0
cmp P2, P3
cmovl S2, P2
cmovge S2, P3
cmovg P3, P2
cmp S1, S2
cmovge P0, S1
cmovge S1, S2
cmovle P0, S2
cmp P3, P1
cmovl P2, P3
