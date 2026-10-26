# n=5 model=out iset=I1 prefix14_class=7593
mov S1, P1
cmp P2, P1
mov S2, P0
cmovge S1, P2
cmovl P1, P2
cmp P3, S2
mov S0, P1
cmovl S2, P3
cmovle P3, P0
cmp S0, S2
cmovle P1, S2
cmovge S0, S2
cmp S1, P3
cmovge S2, S1
