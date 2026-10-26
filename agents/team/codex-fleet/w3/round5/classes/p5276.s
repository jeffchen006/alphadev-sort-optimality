# n=5 model=out iset=I1 prefix14_class=5276
cmp P2, P3
mov S2, P2
cmovge P2, P3
cmovl S2, P3
mov P3, P1
cmp P1, P0
cmovl P3, P0
cmovge P1, P0
cmovle P0, P1
cmp P2, P0
cmovle P0, P2
cmovl P2, P1
cmp S2, P3
cmovle P1, P3
