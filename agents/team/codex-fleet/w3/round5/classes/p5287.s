# n=5 model=out iset=I1 prefix14_class=5287
mov S1, P3
cmp P3, P2
cmovge S1, P2
cmovl P3, P2
cmp P0, P1
mov S0, P0
cmovg S0, P1
cmovle P0, P1
cmp S0, S1
cmovge S2, S1
cmovg S1, S0
cmovl S2, S0
cmp P0, P3
cmovl S0, S1
