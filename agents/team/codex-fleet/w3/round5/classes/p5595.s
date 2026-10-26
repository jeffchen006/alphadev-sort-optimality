# n=5 model=out iset=I1 prefix14_class=5595
mov S1, P3
cmp P3, P0
cmovle P3, P0
cmovl P0, S1
mov S1, P0
cmp P2, P1
cmovl S0, P2
cmovle P2, P1
cmovl P1, S0
cmp P0, P1
cmovg S1, P1
cmovg P1, P0
mov S2, P2
cmp S2, P3
