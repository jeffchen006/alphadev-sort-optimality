# n=5 model=out iset=I1 prefix14_class=7713
cmp P0, P3
mov S2, P0
cmovge S2, P3
cmovle P0, P3
mov S0, P2
cmp P1, P2
cmovg S0, P1
cmovg P1, P2
cmp S2, P1
cmovl S1, P1
cmovl P1, S2
mov P1, S0
cmovl S2, S1
cmp S0, P0
