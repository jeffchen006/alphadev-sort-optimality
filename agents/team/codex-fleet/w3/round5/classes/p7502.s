# n=5 model=out iset=I1 prefix14_class=7502
mov S2, P3
cmp P1, P0
cmovg S0, P1
cmovge P1, P0
cmovg P0, S0
cmp S2, P2
cmovge P3, P2
cmovl S2, P2
cmp P1, P3
cmovl S1, P3
cmovl P3, P1
cmovge S1, P1
cmp P0, S2
cmovle P3, S2
