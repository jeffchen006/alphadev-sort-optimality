# n=5 model=out iset=I1 prefix14_class=6074
cmp P3, P2
cmovl S1, P2
cmovge S1, P3
cmovl P2, P3
cmp P1, P0
mov S2, S1
cmovle P3, P1
cmovg P3, P0
cmovl P1, P0
cmp S1, P1
cmovg S1, P1
cmovg P1, S2
cmp P2, P3
cmovge S0, P2
