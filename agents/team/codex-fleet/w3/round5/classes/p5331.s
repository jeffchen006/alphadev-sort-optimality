# n=5 model=out iset=I1 prefix14_class=5331
cmp P2, P3
cmovge S0, P3
cmovge P3, P2
mov S1, P1
cmovl S0, P2
cmp P1, P0
cmovge P1, P0
cmovl S1, P0
cmp S0, P1
cmovl S2, P1
cmovge S2, S0
cmovle P1, S0
cmp S1, P3
cmovle S0, P3
