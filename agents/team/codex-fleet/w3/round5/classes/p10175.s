# n=5 model=out iset=I1 prefix14_class=10175
cmp P1, P0
cmovl S1, P1
cmovle P1, P0
mov S0, P2
cmovl P0, S1
cmp P2, P3
cmovge S0, P3
cmovg P3, P2
cmp P3, P1
cmovg S2, P3
cmovg P3, P1
cmovg P1, S2
cmp S0, P0
mov P2, S0
