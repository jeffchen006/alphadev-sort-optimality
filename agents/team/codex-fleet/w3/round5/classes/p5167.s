# n=5 model=out iset=I1 prefix14_class=5167
mov S1, P0
cmp P0, P1
mov S0, P3
cmovle P0, P1
cmovle P1, S1
cmp P2, S0
cmovl S0, P2
cmovl P2, P3
cmp S0, P1
cmovge S2, S0
cmovg S0, P1
cmovg P1, S2
mov S0, P0
cmp P2, S0
