# n=5 model=out iset=I1 prefix14_class=6286
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmovl S0, P0
cmp P1, P3
mov P0, S0
cmovge S2, P3
cmovge P3, P1
cmovg P1, S2
mov S1, P3
cmp S1, P2
cmovl S1, P2
cmovle P2, P3
cmp S0, P1
