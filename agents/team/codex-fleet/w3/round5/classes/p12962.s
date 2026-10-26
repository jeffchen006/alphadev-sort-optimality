# n=5 model=out iset=I1 prefix14_class=12962
mov S2, P1
cmp S2, P3
cmovl S2, P3
cmovl P3, P1
mov P1, P0
cmp P2, P1
cmovg P0, P2
cmovl P1, P2
cmovg P2, P1
cmp P2, P3
cmovl P2, P3
cmovg P1, P3
cmp P0, S2
cmovle P1, S2
