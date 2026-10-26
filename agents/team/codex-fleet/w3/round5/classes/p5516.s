# n=5 model=out iset=I1 prefix14_class=5516
mov S0, P2
mov S2, P1
cmp P3, S0
cmovl P2, P3
cmovle P3, S0
cmp S2, P0
cmovle P1, P0
cmovge S2, P0
cmp S2, P2
cmovge S1, S2
cmovl S1, P2
cmovge S2, P2
mov S2, S1
cmp P3, P1
