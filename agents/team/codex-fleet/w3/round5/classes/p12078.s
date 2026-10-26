# n=5 model=out iset=I1 prefix14_class=12078
mov S2, P2
cmp S2, P3
cmovge S2, P3
mov S1, P0
cmovge P3, P2
cmp P0, P1
cmovge P0, P1
cmovl S1, P1
cmp S2, P0
mov S0, P0
cmovl P0, S2
cmovge S0, S2
cmp P3, S1
cmovle S2, S0
