# n=5 model=out iset=I1 prefix14_class=9098
mov S2, P0
cmp S2, P1
mov S0, P2
cmovge S2, P1
cmovl P0, P1
cmp S0, P3
cmovl S0, P3
cmovge P2, P3
cmp P2, S2
cmovle P3, P2
mov S1, S0
cmovl P2, S2
cmovl S2, P3
cmp P0, S0
