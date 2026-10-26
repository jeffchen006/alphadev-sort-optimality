# n=5 model=out iset=I1 prefix14_class=5197
mov S1, P1
cmp S1, P2
cmovle P1, P2
cmovl P2, S1
cmp P3, P0
cmovl S2, P0
cmovl P0, P3
cmovl P3, S2
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
cmovg P0, S1
cmp P1, P3
mov P2, P3
