# n=5 model=out iset=I1 prefix14_class=5183
mov S1, P2
cmp S1, P1
cmovle P2, P1
cmovle P1, S1
cmp P3, P0
cmovl S1, P0
cmovle P0, P3
cmovl P3, S1
cmp P0, P1
cmovg S1, P0
cmovg P0, P1
mov S2, P2
cmovg P1, S1
cmp P3, S2
