# n=5 model=out iset=I1 prefix14_class=11733
mov S1, P2
cmp P0, S1
cmovle P2, P0
cmovg S1, P0
cmp P1, P3
cmovg P0, P1
cmovg P1, P3
mov S2, S1
cmovg P3, P0
cmp S2, P3
cmovg S2, P3
cmovl S1, P3
cmp P2, P1
cmovl P0, P1
