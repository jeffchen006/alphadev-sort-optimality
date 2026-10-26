# n=5 model=out iset=I1 prefix14_class=3318
mov S2, P3
cmp P2, S2
cmovl P3, P2
cmovg S2, P2
cmp P0, P1
mov S0, P0
cmovge S0, P1
cmovg P1, P0
mov S1, S0
cmp P3, S1
cmovl S1, P3
cmovle P3, S0
cmp S2, P1
cmovg S1, P1
