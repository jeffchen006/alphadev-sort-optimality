# n=5 model=out iset=I1 prefix14_class=7290
cmp P2, P0
mov S2, P0
cmovge S2, P2
cmovl P0, P2
cmp P3, P1
cmovl S0, P1
cmovle P1, P3
mov S1, P1
cmovl P3, S0
cmp S1, P0
cmovge S1, P0
cmovg P0, P1
cmp S2, P3
cmovg S1, S2
