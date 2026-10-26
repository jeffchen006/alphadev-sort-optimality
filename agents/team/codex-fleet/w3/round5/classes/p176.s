# n=5 model=out iset=I1 prefix14_class=176
cmp P1, P2
cmovge S1, P1
cmovg P1, P2
cmovl S1, P2
mov S0, P0
cmp P3, S0
cmovle P0, P3
cmovl P3, S0
cmovl S0, P0
cmp P1, S0
cmovge P0, P1
cmovge P1, S0
cmp S1, P3
cmovge S2, S1
