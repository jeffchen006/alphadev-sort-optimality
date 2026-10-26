# n=5 model=out iset=I1 prefix14_class=9920
cmp P3, P0
cmovge S2, P3
cmovl S2, P0
cmovg P3, P0
cmp P2, P1
mov S1, P1
cmovge S1, P2
cmovle P1, P2
cmp S2, S1
cmovge S0, S2
cmovge S2, S1
cmovl S0, S1
cmp P1, P3
cmovle P2, P3
