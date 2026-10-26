# n=5 model=out iset=I1 prefix14_class=10448
cmp P1, P0
mov S0, P2
mov S2, P0
cmovg P0, P1
cmovl S2, P1
cmp S0, P3
cmovl S0, P3
cmovge P2, P3
cmp P0, S0
cmovl S1, P0
cmovle P0, S0
cmovl S0, S1
cmp P2, S2
cmovl P1, P2
