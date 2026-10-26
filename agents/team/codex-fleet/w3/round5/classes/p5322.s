# n=5 model=out iset=I1 prefix14_class=5322
mov S0, P1
cmp P0, P3
mov S1, P0
cmovl S1, P3
cmovl P3, P0
cmp P1, P2
cmovge S0, P2
cmovle P1, P2
cmp S0, P3
mov P2, P3
cmovge P2, S0
cmovl P3, S0
cmp P1, S1
cmovl S2, P1
