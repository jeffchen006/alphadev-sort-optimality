# n=5 model=out iset=I1 prefix14_class=5286
cmp P0, P3
mov S1, P2
cmovge S2, P0
cmovg P0, P3
cmovl S2, P3
cmp P1, S1
cmovle S1, P1
cmovl P1, P2
mov S0, P1
cmp P0, S1
cmovle P2, S1
cmovl S1, P0
cmovl P0, P2
cmp S2, S0
