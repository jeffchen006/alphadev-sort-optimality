# n=5 model=out iset=I1 prefix14_class=3859
cmp P2, P0
cmovge S2, P2
cmovg P2, P0
mov S0, P2
cmovg P0, S2
mov S2, P1
cmp P1, P3
cmovl S2, P3
cmovle P3, P1
cmp P2, P3
cmovl P2, P3
cmovl P3, S0
cmp S2, P0
cmovl S0, S2
