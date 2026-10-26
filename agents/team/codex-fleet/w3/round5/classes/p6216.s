# n=5 model=out iset=I1 prefix14_class=6216
mov S0, P3
cmp P0, P2
cmovle S1, P0
cmovl P0, P2
cmovge S1, P2
cmp P1, P3
cmovl S0, P1
cmovg P3, P1
cmp P0, P3
cmovle S2, P0
cmovl P0, P3
cmovl P3, S2
mov S2, P3
cmp S0, S1
