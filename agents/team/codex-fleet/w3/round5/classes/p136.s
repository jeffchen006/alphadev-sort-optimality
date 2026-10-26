# n=5 model=out iset=I1 prefix14_class=136
mov S1, P3
mov S0, P2
cmp S1, P0
cmovg S1, P0
cmovle P3, P0
cmp P1, S0
cmovg S0, P1
cmovl P2, P1
cmp P2, S1
mov S2, S1
cmovl S2, P2
cmovle P2, S1
mov S2, S0
cmp P3, S2
