# n=5 model=out iset=I1 prefix14_class=1967
cmp P2, P3
cmovl S0, P2
cmovge S0, P3
mov S2, P0
cmovle P2, P3
cmp P1, P0
cmovl S2, P1
cmovge P0, P1
cmp P2, P0
cmovl P1, P0
cmovge P1, P2
cmovl P0, P2
cmp S2, S0
cmovl P2, S2
