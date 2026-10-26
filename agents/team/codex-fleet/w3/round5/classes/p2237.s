# n=5 model=out iset=I1 prefix14_class=2237
cmp P3, P1
mov S0, P1
cmovg P1, P3
cmovg P3, S0
cmp P2, P0
mov S0, P0
cmovg S0, P2
cmovg P2, P0
mov S2, S0
cmp S2, P1
cmovl S0, P1
cmovle P1, S2
cmp P3, P2
cmovl S2, P3
