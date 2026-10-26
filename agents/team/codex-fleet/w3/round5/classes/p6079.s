# n=5 model=out iset=I1 prefix14_class=6079
cmp P3, P0
cmovl S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P1, P2
mov S0, P1
cmovle P1, P2
cmovge S0, P2
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
cmovg P3, S1
cmp S0, P0
cmovge S2, S0
