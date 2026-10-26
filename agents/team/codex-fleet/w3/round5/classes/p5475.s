# n=5 model=out iset=I1 prefix14_class=5475
mov S2, P0
cmp S2, P3
cmovg P0, P3
cmovl S2, P3
cmovle P3, P0
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
cmovg S1, P2
cmp P0, S1
cmovg P3, S1
cmovl P0, S1
cmp S2, P1
cmovl P3, P1
