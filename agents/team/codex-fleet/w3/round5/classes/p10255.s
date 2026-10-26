# n=5 model=out iset=I1 prefix14_class=10255
mov S0, P1
mov S1, P0
cmp P0, P3
cmovge S1, P3
cmovl P0, P3
cmp P1, P2
cmovg P1, P2
cmovl S0, P2
cmp P0, S0
mov S2, P1
cmovl P2, P0
cmovl P0, S0
cmovl S0, P2
cmp S1, P1
