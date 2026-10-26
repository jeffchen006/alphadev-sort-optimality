# n=5 model=out iset=I1 prefix14_class=2870
mov S0, P2
cmp P2, P3
cmovl S0, P3
cmovle P3, P2
mov P2, P0
cmp P2, P1
cmovle P2, P1
cmovg P0, P1
cmp S0, P2
mov S2, P2
cmovl P2, S0
cmovl S0, S2
cmp P3, P0
cmovl S2, P3
