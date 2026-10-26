# n=5 model=out iset=I1 prefix14_class=3974
mov S1, P1
mov S0, P0
cmp S1, P3
cmovl S1, P3
cmovg P1, P3
cmp P2, P0
cmovge S0, P2
cmovle P0, P2
mov S2, P1
cmp P0, P1
cmovge S2, P0
cmovge P0, P1
cmp S1, S0
mov P0, S0
