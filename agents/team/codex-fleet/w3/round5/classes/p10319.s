# n=5 model=out iset=I1 prefix14_class=10319
mov S0, P2
cmp P1, P3
cmovl S2, P3
cmovge S2, P1
cmovle P3, P1
cmp P0, S0
cmovl P2, P0
cmovge S0, P0
cmp S0, S2
cmovg P0, S2
cmovge S2, S0
cmovg S0, P0
cmp P2, P3
cmovl P1, P3
