# n=5 model=out iset=I1 prefix14_class=9022
cmp P0, P1
cmovl S2, P0
cmovge S2, P1
mov S0, P2
cmovle P0, P1
cmp P3, S0
cmovl P2, P3
cmovle P3, S0
cmp P0, P3
cmovge S1, P3
cmovg P3, P0
cmovg P0, S1
cmp S2, P2
cmovl P3, P2
