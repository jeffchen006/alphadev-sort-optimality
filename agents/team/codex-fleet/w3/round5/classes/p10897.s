# n=5 model=out iset=I1 prefix14_class=10897
cmp P2, P1
mov S2, P3
cmovl S1, P2
cmovl P2, P1
cmovl P1, S1
cmp S2, P0
cmovg S2, P0
cmovl P3, P0
cmp P3, P2
cmovg P0, P2
cmovg P2, P3
cmovle P0, P3
cmp P1, S2
cmovle P3, S2
