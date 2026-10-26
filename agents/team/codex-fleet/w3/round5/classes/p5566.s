# n=5 model=out iset=I1 prefix14_class=5566
cmp P1, P0
mov S2, P1
cmovle P1, P0
cmovg S2, P0
cmp P3, P2
mov P0, P3
cmovl P3, P2
cmovl P2, P0
mov P0, P2
cmp S2, P0
cmovl P2, S2
cmovg P0, S2
cmp P3, P1
cmovl S1, P3
