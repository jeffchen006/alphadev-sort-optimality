# n=5 model=out iset=I1 prefix14_class=4548
mov S1, P0
cmp S1, P2
cmovl P0, P2
cmovg S1, P2
mov S2, P1
cmp S2, P3
cmovg P1, P3
cmovl S2, P3
cmp S2, P0
cmovle P2, S1
cmovg P3, P0
cmovg P0, S2
cmovle P3, S2
cmp P1, S1
