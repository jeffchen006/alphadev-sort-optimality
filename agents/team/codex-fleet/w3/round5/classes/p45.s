# n=5 model=out iset=I1 prefix14_class=45
mov S0, P2
mov S1, P0
cmp P3, S0
cmovle P2, P3
cmovle P3, S0
cmp P1, S1
cmovge S1, P1
mov S0, P2
cmovl P0, P1
cmp S0, P0
mov S2, P3
cmovge S0, P0
cmovl P2, P0
cmp P3, S1
