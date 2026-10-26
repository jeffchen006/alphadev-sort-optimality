# n=5 model=out iset=I1 prefix14_class=8376
mov S2, P0
mov S1, P1
cmp P0, P2
cmovle P0, P2
cmovl P2, S2
cmp S1, P3
cmovg S1, P3
cmovge P3, P1
cmp P0, P3
cmovl S2, P0
cmovl P0, P3
cmovl P3, S2
cmp P2, S1
cmovle P1, P2
