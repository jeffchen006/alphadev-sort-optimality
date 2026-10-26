# n=5 model=out iset=I1 prefix14_class=13297
cmp P3, P0
cmovl S0, P3
cmovl P3, P0
cmovl P0, S0
cmp P2, P1
cmovle S0, P1
cmovle P1, P2
mov S1, P3
cmovl P2, S0
mov S2, P0
cmp S2, P1
cmovge S2, P1
cmovg P1, P0
cmp P3, P2
