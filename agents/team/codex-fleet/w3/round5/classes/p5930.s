# n=5 model=out iset=I1 prefix14_class=5930
mov S1, P1
cmp P1, P3
cmovg S1, P3
cmovle P1, P3
cmp P0, P2
mov S2, P2
cmovg P2, P0
cmovl S2, P0
cmp P2, P1
mov S0, S2
cmovle P0, P1
cmovle P1, P2
cmovl P2, P0
cmp S0, S1
