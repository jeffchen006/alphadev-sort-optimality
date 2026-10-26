# n=5 model=out iset=I1 prefix14_class=13452
cmp P1, P3
cmovge S1, P1
cmovl S1, P3
cmovle P3, P1
cmp P0, P2
cmovl S0, P0
cmovle P0, P2
cmovl P2, S0
mov S2, P2
cmp S2, P3
cmovle P2, P3
cmovg S2, P3
cmovge P3, P2
cmp P0, S1
