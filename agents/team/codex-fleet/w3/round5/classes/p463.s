# n=5 model=out iset=I1 prefix14_class=463
mov S0, P2
mov S2, P0
cmp P0, P1
cmovle P0, P1
cmovl P1, S2
cmp S0, P3
cmovg P2, P3
cmovg P3, S0
mov S2, P3
cmp P1, P2
mov S1, P2
cmovl P2, P1
cmovle P1, S1
cmp P3, P0
