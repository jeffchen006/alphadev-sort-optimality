# n=5 model=out iset=I1 prefix14_class=4454
cmp P2, P3
cmovge S2, P3
cmovg P3, P2
cmovg P2, S2
cmp P0, P1
cmovle S0, P1
cmovg S0, P0
mov S1, S0
cmovle P1, P0
cmp S1, P3
cmovl S0, P3
cmovl P3, S1
cmp P1, P2
cmovl S1, P1
