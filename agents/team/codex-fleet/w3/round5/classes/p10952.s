# n=5 model=out iset=I1 prefix14_class=10952
cmp P1, P3
cmovl S2, P1
mov S1, P0
cmovle P1, P3
cmovl P3, S2
cmp S1, P2
cmovge P0, P2
cmovge P2, S1
cmp P2, P1
mov S0, P1
cmovle P1, P2
cmovge S0, P2
cmp P3, P0
cmovl P2, P0
