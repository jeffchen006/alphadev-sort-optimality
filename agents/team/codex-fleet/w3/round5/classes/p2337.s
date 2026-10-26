# n=5 model=out iset=I1 prefix14_class=2337
cmp P3, P0
cmovle S2, P3
cmovle P3, P0
mov S0, P2
cmovl P0, S2
cmp S0, P1
cmovl S0, P1
cmovg P2, P1
cmovg P1, S0
cmp P3, S0
cmovl P1, P3
cmovge S0, P3
cmp P2, P0
cmovge S2, P2
