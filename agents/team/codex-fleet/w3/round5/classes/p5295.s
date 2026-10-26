# n=5 model=out iset=I1 prefix14_class=5295
cmp P1, P2
mov S2, P1
mov S1, P0
cmovge P1, P2
cmovge P2, S2
cmp P0, P3
cmovge S1, P3
cmovle P0, P3
mov S0, S1
cmp S1, P1
cmovl S0, P1
cmovle P1, S1
mov P1, S0
cmp P0, P2
