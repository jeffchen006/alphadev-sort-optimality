# n=5 model=out iset=I1 prefix14_class=9366
mov S2, P0
cmp S2, P3
cmovle P0, P3
cmovl P3, S2
cmp P1, P2
cmovl S2, P2
cmovl P2, P1
mov S1, P3
cmovl P1, S2
cmp P2, P3
cmovg P3, P2
cmovge P2, S1
cmovge S1, P3
mov P2, P0
