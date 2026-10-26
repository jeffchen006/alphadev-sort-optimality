# n=5 model=out iset=I1 prefix14_class=5307
cmp P0, P1
cmovge S1, P0
cmovge P0, P1
cmovge P1, S1
mov S0, P2
cmp S0, P3
cmovle S0, P3
cmovge P2, P3
cmp P2, P0
cmovge S2, P2
cmovl S2, P0
cmovle P0, P2
cmp S0, P1
mov P0, S0
