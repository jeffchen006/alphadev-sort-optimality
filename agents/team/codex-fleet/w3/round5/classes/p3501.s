# n=5 model=out iset=I1 prefix14_class=3501
cmp P2, P3
cmovge S1, P2
cmovge P2, P3
cmovl S1, P3
cmp P0, P1
mov S0, P2
cmovge S2, P1
cmovl S2, P0
cmovl P0, P1
cmp S2, S0
cmovg P2, S2
cmovge S2, S0
cmp S1, P0
cmovle P1, P0
