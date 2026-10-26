# n=5 model=out iset=I1 prefix14_class=4306
mov S2, P1
mov S0, P3
cmp S2, P2
cmovg P1, P2
cmovl S2, P2
cmp P3, P0
cmovl P3, P0
cmovge S0, P0
cmp S0, P1
cmovle S1, S0
cmovle S0, P1
cmovl P1, S1
mov P2, S2
cmp P3, S2
