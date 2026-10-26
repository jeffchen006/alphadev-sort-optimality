# n=5 model=out iset=I1 prefix14_class=3895
mov S0, P2
cmp S0, P3
cmovg P2, P3
cmovg P3, S0
mov S1, P2
cmp P1, P0
cmovl S0, P1
cmovle P1, P0
cmovl P0, S0
cmp P2, P0
cmovl P2, P0
cmovl P0, S1
mov S1, P1
mov P0, P2
