# n=5 model=out iset=I1 prefix14_class=13560
cmp P1, P2
mov S1, P1
cmovl P1, P2
cmovle P2, S1
cmp P3, P0
mov S0, P0
cmovl P0, P3
cmovl P3, S0
mov S2, P3
cmp P0, P2
cmovge S1, P2
cmovge P2, P0
cmovge P0, S1
cmp S2, P1
