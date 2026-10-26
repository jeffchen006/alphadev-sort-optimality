# n=5 model=out iset=I1 prefix14_class=10271
mov S1, P3
cmp P2, S1
mov S0, P1
cmovle P3, P2
cmovge S1, P2
cmp P1, P0
cmovl S0, P0
cmovge P1, P0
cmp S0, S1
cmovge P0, S1
cmovge S1, S0
cmovge S0, P0
mov S2, S0
cmp P3, P1
