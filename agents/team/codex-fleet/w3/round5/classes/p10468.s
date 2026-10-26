# n=5 model=out iset=I1 prefix14_class=10468
cmp P2, P1
cmovl S2, P1
mov S1, P0
cmovle P1, P2
cmovl P2, S2
cmp P3, P0
cmovg S1, P3
cmovle P0, P3
mov P3, P0
cmp S1, P2
cmovg S0, S1
cmovg S1, P2
cmovg P2, S0
cmp P1, P3
