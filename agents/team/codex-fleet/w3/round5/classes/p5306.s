# n=5 model=out iset=I1 prefix14_class=5306
cmp P2, P1
cmovge S2, P2
cmovge P2, P1
cmovge P1, S2
mov S0, P0
cmp S0, P3
cmovle P0, P3
cmovge S0, P3
cmp S0, P2
cmovge S1, S0
cmovl S1, P2
cmovl P2, S0
cmp P1, P0
cmovg P2, P1
