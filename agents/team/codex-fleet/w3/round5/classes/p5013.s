# n=5 model=out iset=I1 prefix14_class=5013
cmp P2, P0
cmovle S1, P2
mov S2, P3
cmovl P2, P0
cmovl P0, S1
cmp P1, P3
cmovg P3, P1
cmovl S2, P1
cmp S2, P0
cmovl P1, P0
cmovl P0, S2
mov S0, P3
cmovl S2, P1
cmp S0, P2
