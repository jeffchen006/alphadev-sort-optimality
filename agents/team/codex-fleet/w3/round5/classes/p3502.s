# n=5 model=out iset=I1 prefix14_class=3502
cmp P3, P2
cmovge S1, P3
cmovl S1, P2
cmovg P3, P2
mov S0, P0
mov S2, P3
cmp P0, P1
cmovge S0, P1
cmovle P0, P1
cmp S0, P3
cmovg S2, S0
cmovg S0, P3
cmp S1, P0
cmovl P2, P0
