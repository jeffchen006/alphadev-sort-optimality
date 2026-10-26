# n=5 model=out iset=I1 prefix14_class=5308
cmp P0, P2
cmovge S1, P0
cmovge P0, P2
cmovge P2, S1
mov S0, P1
cmp S0, P3
cmovle S0, P3
cmovge P1, P3
cmp P1, P0
cmovge S2, P1
cmovl S2, P0
cmovle P0, P1
cmp S0, P2
mov P0, S0
