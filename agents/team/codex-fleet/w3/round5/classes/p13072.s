# n=5 model=out iset=I1 prefix14_class=13072
cmp P3, P0
cmovge S0, P3
cmovg P3, P0
cmovg P0, S0
cmp P1, P2
cmovl S1, P1
cmovle P1, P2
cmovge S1, P2
cmp S1, P3
mov S2, P0
cmovge S0, S1
cmovge S1, P3
cmovge P3, S0
cmp P1, S2
