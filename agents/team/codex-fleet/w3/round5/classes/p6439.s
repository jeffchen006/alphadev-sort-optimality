# n=5 model=out iset=I1 prefix14_class=6439
cmp P1, P3
mov S2, P2
cmovge S1, P3
cmovl S1, P1
cmovge P3, P1
cmp P0, S2
cmovge S2, P0
cmovl P2, P0
mov S0, S2
cmp P3, S2
cmovge S2, P3
cmovl S0, P3
cmp S1, P2
cmovle P3, P2
