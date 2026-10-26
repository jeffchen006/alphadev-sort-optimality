# n=5 model=out iset=I1 prefix14_class=9338
cmp P2, P3
mov S2, P3
cmovle S2, P2
cmovg P3, P2
cmp P1, P0
cmovl S1, P0
cmovle P0, P1
cmovl P1, S1
mov S0, P0
cmp S0, S2
cmovg S0, S2
cmovl P0, S2
cmovge S2, P0
cmp P3, P1
