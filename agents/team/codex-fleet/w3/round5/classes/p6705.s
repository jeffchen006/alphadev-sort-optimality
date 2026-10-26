# n=5 model=out iset=I1 prefix14_class=6705
mov S1, P2
cmp S1, P3
cmovle P2, P3
cmovge S1, P3
mov P3, P0
cmp P1, P0
cmovl P0, P1
cmovle P1, P3
mov P3, P1
cmp P2, P3
cmovl P3, P2
cmovge P1, P2
cmp P0, S1
cmovl S2, P0
