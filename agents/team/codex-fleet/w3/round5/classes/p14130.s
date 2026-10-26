# n=5 model=out iset=I1 prefix14_class=14130
cmp P3, P0
mov S2, P3
cmovg P3, P0
cmovl S2, P0
cmp P1, P2
cmovg S1, P1
cmovg P1, P2
cmovg P2, S1
cmp S2, P2
cmovle P0, P2
cmovl P2, S2
cmovg P0, S2
mov P0, P3
cmp P0, P1
