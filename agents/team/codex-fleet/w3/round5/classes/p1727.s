# n=5 model=out iset=I1 prefix14_class=1727
cmp P1, P0
mov S2, P1
cmovl S2, P0
cmovl P0, P1
cmp P2, P3
cmovl S0, P3
mov P1, P0
cmovl P3, P2
cmovl P2, S0
cmp P3, P1
cmovle P1, P3
cmovg P0, P3
cmp S2, P2
cmovg S1, P2
