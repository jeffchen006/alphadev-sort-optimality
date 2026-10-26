# n=5 model=out iset=I1 prefix14_class=5429
mov S0, P3
cmp P0, S0
cmovge P3, P0
cmovge P0, S0
mov S2, P1
cmp S2, P2
cmovle P1, P2
cmovge S2, P2
cmp S2, P0
cmovge S1, P0
cmovl S1, S2
cmovg P0, S2
cmp P3, P1
cmovl S0, P3
