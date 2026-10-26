# n=5 model=out iset=I1 prefix14_class=7137
cmp P1, P0
mov S0, P2
mov S2, P0
cmovl S2, P1
cmovl P1, P0
cmp P2, P3
cmovge S0, P3
mov S1, S2
cmovle P2, P3
cmp S2, S0
cmovg S1, S0
cmovl S2, S0
cmp P2, P1
cmovl S0, P1
