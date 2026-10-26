# n=5 model=out iset=I1 prefix14_class=12378
mov S0, P2
cmp S0, P3
cmovg S0, P3
mov S2, S0
cmovl P2, P3
cmp P1, P0
cmovle P3, P0
cmovl P0, P1
cmovle P1, P3
cmp P0, S0
cmovge S0, P0
cmovl S2, P0
cmp P1, P2
cmovge S1, P1
