# n=5 model=out iset=I1 prefix14_class=6701
mov S0, P3
cmp P2, P3
cmovle P3, P2
mov S2, P0
cmovl P2, S0
cmp P1, P0
cmovl S2, P1
cmovg P0, P1
cmp P2, P0
mov S1, P0
cmovg S1, P2
cmovl P0, P2
cmp S2, P3
cmovg P2, P3
