# n=5 model=out iset=I1 prefix14_class=2506
mov S1, P3
cmp P0, P3
cmovl P3, P0
cmovle P0, S1
mov S2, P2
cmp P1, P2
mov S0, P0
cmovge S2, P1
cmovge P1, P2
cmp S0, S2
cmovl S0, S2
cmovl S2, P0
cmp P1, P3
cmovge S0, P1
