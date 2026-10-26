# n=5 model=out iset=I1 prefix14_class=2184
cmp P0, P3
mov S0, P0
cmovle S0, P3
cmovge P0, P3
mov S2, P2
cmp S2, P1
cmovge S2, P1
cmovge P1, P2
cmovl P2, P1
cmp P2, S0
cmovl P2, S0
mov S1, P0
cmovl S0, P1
mov P2, S0
