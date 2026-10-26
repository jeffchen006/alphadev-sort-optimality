# n=5 model=out iset=I1 prefix14_class=14178
mov S0, P2
mov S1, P1
cmp P0, P1
cmovg S1, P0
cmovle P1, P0
cmp P2, P3
cmovl S0, P3
cmovg P2, P3
cmp S0, S1
cmovg S2, S0
cmovg S0, S1
cmovg S1, S2
cmp P1, P2
cmovl P3, P2
