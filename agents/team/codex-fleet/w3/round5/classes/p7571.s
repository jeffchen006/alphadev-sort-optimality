# n=5 model=out iset=I1 prefix14_class=7571
cmp P0, P2
cmovge S0, P2
cmovg P2, P0
cmovl S0, P0
mov S1, P1
cmp P1, P3
cmovl S1, P3
cmovge P1, P3
cmp P1, S0
cmovle P3, P1
cmovle P1, S0
cmovle S0, P3
cmp S1, P2
cmovl P0, S1
