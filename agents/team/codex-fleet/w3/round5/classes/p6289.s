# n=5 model=out iset=I1 prefix14_class=6289
cmp P0, P1
mov S2, P3
cmovge S0, P1
cmovl S0, P0
cmovge P1, P0
cmp P2, S2
cmovge S2, P2
cmovge P2, P3
mov S1, P1
cmp S1, S2
cmovle P1, S2
cmovle S2, S1
cmp P2, S0
mov P1, S2
