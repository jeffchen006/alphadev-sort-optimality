# n=5 model=out iset=I1 prefix14_class=9377
mov S1, P2
cmp P2, P3
cmovl S1, P3
cmovl P3, P2
cmp P0, P1
cmovle P2, P1
cmovl P1, P0
cmovl P0, P2
cmp P1, P3
mov S0, P3
cmovg S0, P1
cmovg P1, P3
mov S2, P0
cmp S1, S2
