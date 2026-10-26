# n=5 model=out iset=I1 prefix14_class=7377
mov S2, P1
cmp S2, P3
cmovl P1, P3
mov S0, P0
cmovl P3, S2
mov S1, P3
cmp P2, P0
cmovg P0, P2
cmovle S0, P2
cmp P3, S0
cmovg P3, S0
cmovle S1, S0
cmp P1, P0
cmovl S0, P0
