# n=5 model=out iset=I1 prefix14_class=6379
mov S2, P2
cmp P0, P3
mov S0, P3
cmovge S0, P0
cmovle P3, P0
cmp P1, S2
cmovl S2, P1
cmovge P2, P1
mov P1, P2
cmp S0, P2
cmovge P2, S0
cmovle P1, S0
cmp S2, P3
cmovge S0, S2
