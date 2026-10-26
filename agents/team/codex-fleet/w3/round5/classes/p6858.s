# n=5 model=out iset=I1 prefix14_class=6858
mov S2, P3
cmp P1, P2
cmovl S0, P2
cmovl P2, P1
cmovl P1, S0
cmp S2, P0
cmovl S2, P0
cmovle P0, P3
mov S0, P1
cmp S2, S0
cmovg P1, S2
cmovle S0, S2
cmp P0, P2
cmovg P1, P2
