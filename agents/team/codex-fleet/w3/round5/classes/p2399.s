# n=5 model=out iset=I1 prefix14_class=2399
cmp P3, P2
cmovge S1, P3
cmovl S1, P2
mov S0, P1
cmovge P3, P2
mov S2, S1
cmp P1, P0
cmovle P1, P0
cmovle P0, S0
cmp S1, P1
cmovl S1, P1
cmovl P1, S2
mov S2, P1
cmp P3, P0
