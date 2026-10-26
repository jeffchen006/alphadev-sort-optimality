# n=5 model=out iset=I1 prefix14_class=4033
cmp P1, P2
cmovge S1, P1
cmovge P1, P2
cmovge P2, S1
mov S2, P0
cmp P3, P0
cmovge S2, P3
cmovle P0, P3
mov S0, P0
cmp P1, P0
cmovl P0, P1
cmovge S0, P1
cmp S2, P2
cmovge P3, P2
