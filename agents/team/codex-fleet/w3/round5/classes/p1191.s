# n=5 model=out iset=I1 prefix14_class=1191
cmp P1, P3
mov S1, P1
mov S0, P2
cmovle P1, P3
cmovl P3, S1
cmp S0, P0
cmovg P2, P0
cmovl S0, P0
mov S2, P1
cmp S2, S0
mov S1, P2
cmovg P1, S0
cmovg S0, S2
cmp S1, P3
