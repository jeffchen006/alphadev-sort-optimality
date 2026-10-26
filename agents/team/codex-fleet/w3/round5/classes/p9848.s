# n=5 model=out iset=I1 prefix14_class=9848
cmp P3, P2
cmovge S2, P3
cmovl S2, P2
cmovle P2, P3
cmp P0, P1
cmovge S0, P0
cmovge P0, P1
cmovg P1, S0
cmp S2, P1
cmovl S0, P1
cmovl P1, S2
cmovl S2, S0
cmp P2, P0
cmovl S0, P0
