# n=5 model=out iset=I1 prefix14_class=6137
mov S1, P3
cmp S1, P1
cmovle P3, P1
cmovl P1, S1
cmp P2, P0
cmovge S1, P0
mov S2, P1
cmovge P0, P2
mov S0, P3
cmovge P2, S1
cmp P3, P0
cmovge S0, P0
cmovl P3, P0
cmp P2, P1
