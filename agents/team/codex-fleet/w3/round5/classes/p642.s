# n=5 model=out iset=I1 prefix14_class=642
cmp P3, P2
mov S1, P2
cmovl S1, P3
mov S2, P1
cmovl P3, P2
cmp S2, P0
cmovg S2, P0
cmovl P1, P0
cmovg P0, P1
cmp P0, P3
cmovle P0, P3
cmovle P3, P1
cmp S2, S1
cmovg P1, S1
