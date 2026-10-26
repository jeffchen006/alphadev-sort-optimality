# n=5 model=out iset=I1 prefix14_class=13219
mov S2, P1
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
cmovg P0, S0
cmp S2, P2
cmovg P1, P2
cmovl S2, P2
mov S1, P0
cmp P1, S1
cmovg P0, P1
cmovl S1, P1
cmp S2, P3
cmovle P2, S2
