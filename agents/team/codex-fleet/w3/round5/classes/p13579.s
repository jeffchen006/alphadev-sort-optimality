# n=5 model=out iset=I1 prefix14_class=13579
mov S2, P1
cmp P1, P2
cmovg P1, P2
cmovl S2, P2
mov S0, P0
mov P2, S2
cmp S0, P3
cmovl S0, P3
cmovle P3, P0
cmp P1, P3
cmovl P0, P1
cmovl P1, P3
cmovl P3, P0
cmp S2, S0
