# n=5 model=out iset=I1 prefix14_class=13146
cmp P3, P1
cmovge S1, P1
cmovl S1, P3
cmovl P3, P1
cmp P2, P0
mov S0, P2
cmovle P2, P0
cmovge S0, P0
cmp S0, S1
cmovg P0, S0
cmovge S0, S1
cmovg S1, P0
cmp P3, P2
cmovge S0, P3
