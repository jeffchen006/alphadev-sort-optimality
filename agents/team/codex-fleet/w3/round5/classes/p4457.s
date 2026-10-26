# n=5 model=out iset=I1 prefix14_class=4457
cmp P2, P3
cmovg S0, P3
cmovg P3, P2
cmovg P2, S0
mov S1, P0
cmp P1, P0
cmovg S1, P1
cmovle P0, P1
mov S2, S1
cmp S1, P3
cmovl S1, P3
cmovl P3, S2
mov S2, P0
cmp S2, P2
