# n=5 model=out iset=I1 prefix14_class=892
mov S1, P2
cmp P1, P2
cmovle P2, P1
cmovge S1, P1
cmovle P1, S1
cmp P0, P3
cmovge S2, P3
cmovg P3, P0
cmovl S2, P0
cmp P3, S1
cmovge S1, P3
cmovl P1, P3
mov S0, S2
cmp S2, P2
