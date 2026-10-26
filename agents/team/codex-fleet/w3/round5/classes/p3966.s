# n=5 model=out iset=I1 prefix14_class=3966
mov S0, P1
cmp S0, P0
cmovl S0, P0
cmovl P0, P1
mov S1, P3
cmp P3, P2
mov S2, P0
cmovl S1, P2
cmovl P2, P3
cmp P2, S2
cmovle S2, P2
cmovg P0, P2
cmp S1, S0
cmovge S2, S0
