# n=5 model=out iset=I1 prefix14_class=10905
cmp P3, P1
cmovl S1, P3
mov S2, P2
cmovl P3, P1
cmovl P1, S1
cmp P0, S2
cmovle P2, P0
cmovle P0, S2
cmovg S2, P0
cmp S2, P3
cmovl P0, P3
cmovle P3, S2
cmp P1, P2
cmovl S2, P2
