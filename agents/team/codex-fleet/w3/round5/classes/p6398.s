# n=5 model=out iset=I1 prefix14_class=6398
cmp P2, P1
cmovg S2, P2
cmovg P2, P1
cmovg P1, S2
mov S0, P0
cmp P3, P0
cmovg P0, P3
cmovl S0, P3
cmovl P3, P0
cmp P1, P3
cmovg P0, P1
cmovl P3, P1
cmp S0, P2
cmovle P1, P3
