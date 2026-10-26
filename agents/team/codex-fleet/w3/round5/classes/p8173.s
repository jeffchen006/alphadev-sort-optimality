# n=5 model=out iset=I1 prefix14_class=8173
cmp P0, P2
mov S1, P0
cmovl P0, P2
cmovle P2, S1
mov S0, P1
cmp P3, S0
cmovge S0, P3
cmovl P1, P3
cmp P2, P1
cmovge P3, P2
cmovge P2, P1
mov S2, S0
cmovge P1, P3
cmp S2, P0
