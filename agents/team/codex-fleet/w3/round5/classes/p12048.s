# n=5 model=out iset=I1 prefix14_class=12048
cmp P0, P3
cmovle S0, P0
cmovge S0, P3
cmovg P3, P0
mov S2, S0
cmp P1, P2
cmovl S1, P1
cmovl P1, P2
cmovl P2, S1
cmp S2, P2
cmovg S2, P2
cmovl S0, P2
cmp P3, P1
cmovle P0, P3
