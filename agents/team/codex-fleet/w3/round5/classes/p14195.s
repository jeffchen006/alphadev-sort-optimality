# n=5 model=out iset=I1 prefix14_class=14195
cmp P0, P1
cmovle S1, P1
cmovl P1, P0
cmovl P0, S1
cmp P2, P3
mov S2, P3
cmovge S2, P2
cmovg P2, P3
mov S0, S2
cmp S0, P0
cmovl S0, P0
cmovl P0, S2
mov S0, P1
cmp P1, P2
