# n=5 model=out iset=I1 prefix14_class=2334
cmp P3, P2
cmovl S2, P3
cmovl P3, P2
mov S0, P0
cmovl P2, S2
cmp S0, P1
cmovle S0, P1
cmovg P0, P1
cmp S0, P3
cmovg P1, P3
cmovle P1, S0
cmovge P3, S0
cmp P2, P0
cmovge S2, P2
