# n=5 model=out iset=I1 prefix14_class=7521
mov S0, P0
cmp P2, S0
cmovl P0, P2
cmovg S0, P2
cmp P3, P1
cmovge S2, P1
mov S1, P0
cmovg P1, P3
cmovg P3, S2
cmp P0, P3
cmovle P0, P3
cmovl P3, S1
cmp S0, P1
cmovle P3, S0
