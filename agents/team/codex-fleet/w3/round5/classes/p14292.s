# n=5 model=out iset=I1 prefix14_class=14292
cmp P3, P0
cmovge S0, P0
cmovg P0, P3
mov S1, P1
cmovge P3, S0
cmp S1, P2
cmovl S1, P2
cmovge P1, P2
mov S2, P3
cmp P1, S2
cmovge S2, P1
cmovl P3, P1
cmp P0, S1
cmovle P1, S1
