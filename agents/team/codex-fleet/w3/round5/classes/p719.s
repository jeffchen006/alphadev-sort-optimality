# n=5 model=out iset=I1 prefix14_class=719
cmp P1, P2
mov S2, P3
cmovl S0, P1
cmovge S0, P2
cmovle P1, P2
cmp P3, P0
cmovge S2, P0
cmovle P3, P0
cmp P1, P3
mov S1, P1
cmovl P1, P3
cmovle P3, S1
cmp S0, S2
cmovge P0, S0
