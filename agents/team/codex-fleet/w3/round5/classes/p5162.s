# n=5 model=out iset=I1 prefix14_class=5162
mov S0, P2
cmp P3, P0
cmovl S1, P3
cmovle P3, P0
cmovl P0, S1
cmp P1, P2
cmovl S0, P1
mov S2, S0
cmovle P1, P2
cmp S0, P0
cmovg S0, P0
cmovg P0, S2
cmp P1, P3
cmovg P2, P3
