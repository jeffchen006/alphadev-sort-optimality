# n=5 model=out iset=I1 prefix14_class=7799
cmp P3, P2
cmovge S0, P2
cmovl S0, P3
cmovl P3, P2
cmp P1, P0
cmovge P2, P1
cmovge P1, P0
cmovg P0, P2
mov S1, P1
cmp S0, S1
mov S2, P3
cmovle P1, S0
cmovge S1, S0
cmp S2, P0
