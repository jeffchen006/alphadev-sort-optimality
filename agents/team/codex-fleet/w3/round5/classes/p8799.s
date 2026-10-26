# n=5 model=out iset=I1 prefix14_class=8799
cmp P0, P2
cmovge S0, P2
mov S1, P3
cmovl S0, P0
cmovle P0, P2
cmp S1, P1
cmovl P3, P1
cmovge S1, P1
cmovl P1, S1
cmp P0, P3
cmovge S2, P0
cmovge P0, P3
cmovg P3, S2
cmp S1, S0
