# n=5 model=out iset=I1 prefix14_class=1754
cmp P2, P1
cmovge S0, P1
cmovge P1, P2
cmovge P2, S0
cmp P0, P3
cmovl S0, P3
cmovle P3, P0
mov S2, P2
cmovl P0, S0
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmovl S1, P0
cmp S2, P3
