# n=5 model=out iset=I1 prefix14_class=12184
cmp P2, P1
mov S0, P2
cmovle S0, P1
cmovge P2, P1
cmp P3, P0
cmovge S1, P0
cmovle S1, P3
cmovg P0, P3
cmp S1, P2
cmovl S2, S1
cmovl S1, P2
cmovl P2, S2
cmp P0, S0
cmovl S2, S0
