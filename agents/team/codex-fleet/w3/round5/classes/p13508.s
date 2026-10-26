# n=5 model=out iset=I1 prefix14_class=13508
cmp P3, P1
cmovge S2, P1
cmovl S2, P3
mov S0, P2
cmovle P3, P1
cmp P0, S0
cmovle S0, P0
cmovg P2, P0
mov S1, P2
cmp S2, S0
cmovl P1, S2
cmovle S2, S0
cmovl S0, P1
cmp P3, P2
