# n=5 model=out iset=I1 prefix14_class=2296
mov S1, P3
cmp P3, P0
mov S0, P2
cmovl P3, P0
cmovge S1, P0
cmp P2, P1
cmovl S0, P1
cmovge P2, P1
cmp S0, P3
cmovle P1, P3
cmovle P3, S0
cmovg P1, S0
cmp S1, P2
cmovle P1, S1
