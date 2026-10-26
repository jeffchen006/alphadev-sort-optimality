# n=5 model=out iset=I1 prefix14_class=7490
mov S1, P2
cmp S1, P0
cmovg P2, P0
mov S0, P1
mov S2, P2
cmovl S1, P0
cmp S0, P3
cmovge S0, P3
cmovle P1, P3
cmp S0, S2
cmovl P2, S0
cmovg S2, S0
cmp S1, P1
cmovl P0, P1
