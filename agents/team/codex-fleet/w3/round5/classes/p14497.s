# n=5 model=out iset=I1 prefix14_class=14497
mov S2, P2
cmp S2, P3
cmovg P2, P3
cmovg P3, S2
cmp P0, P1
mov S0, P1
cmovle P1, P0
cmovl P0, S0
cmp P1, P2
cmovl S2, P1
cmovle P1, P2
mov S1, P3
cmovl P2, S2
cmp S1, P0
