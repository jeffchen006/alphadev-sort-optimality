# n=5 model=out iset=I1 prefix14_class=12047
cmp P0, P3
cmovle S0, P0
cmovge S0, P3
cmovg P3, P0
mov S2, S0
cmp P2, P1
cmovl S1, P2
cmovl P2, P1
cmovl P1, S1
cmp S2, P1
cmovge S2, P1
cmovl S0, P1
cmp P3, P2
cmovle P0, P3
