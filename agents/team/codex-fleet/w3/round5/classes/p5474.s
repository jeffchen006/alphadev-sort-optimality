# n=5 model=out iset=I1 prefix14_class=5474
mov S2, P0
mov S1, P1
cmp S2, P2
cmovg P0, P2
cmovl S2, P2
cmovl P2, P0
cmp P1, P3
cmovle P1, P3
cmovg S1, P3
cmp P0, S1
cmovl P0, S1
cmovg P2, S1
cmp S2, P1
cmovl P2, P1
