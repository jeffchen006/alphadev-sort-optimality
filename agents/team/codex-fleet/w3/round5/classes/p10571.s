# n=5 model=out iset=I1 prefix14_class=10571
mov S0, P1
mov S1, P3
cmp S0, P2
cmovge S0, P2
cmovge P2, P1
cmp P0, P3
cmovge P3, P0
cmovge P0, S1
mov S2, P3
cmp P2, P3
cmovge S2, P2
cmovle P3, P2
cmp P0, S0
cmovl S2, P0
