# n=5 model=out iset=I1 prefix14_class=7190
cmp P1, P2
mov S0, P2
cmovge S0, P1
cmovg P1, P2
cmp P3, P0
cmovge S2, P0
cmovge P0, P3
cmovl S2, P3
mov S1, S2
cmp S1, P1
cmovl S2, P1
cmovg S1, P1
cmovle P3, P0
cmp S0, P0
