# n=5 model=out iset=I1 prefix14_class=13590
cmp P2, P0
cmovge S0, P0
cmovge P0, P2
mov S2, P3
cmovl S0, P2
cmp P1, S2
cmovle P3, P1
cmovl P1, S2
mov S1, S0
cmp S1, P3
cmovge S1, P3
cmovl S0, P3
cmp P1, P0
cmovge P3, P0
