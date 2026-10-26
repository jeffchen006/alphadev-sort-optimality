# n=5 model=out iset=I1 prefix14_class=1217
mov S0, P1
mov S2, P2
cmp S0, P3
cmovle P1, P3
cmovl P3, S0
cmp S2, P0
cmovg P2, P0
cmovl S2, P0
cmp P1, S2
cmovge S1, P1
cmovg P1, S2
cmovg S2, S1
mov S0, P3
cmp P3, P2
