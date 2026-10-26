# n=5 model=out iset=I1 prefix14_class=7204
mov S0, P1
cmp S0, P3
cmovl P1, P3
cmovg S0, P3
mov S2, P0
cmp P2, P0
cmovle S2, P2
cmovg P0, P2
cmp S2, S0
mov S1, S2
cmovg S1, S0
cmovl S2, S0
cmp P0, P1
cmovl S0, P0
