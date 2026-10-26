# n=5 model=out iset=I1 prefix14_class=7285
mov S2, P3
cmp P1, P3
mov S1, P0
cmovge S2, P1
cmovl P3, P1
cmp P2, S1
cmovl P0, P2
cmovle P2, S1
cmp P0, P3
cmovge P1, P0
cmovge P0, P3
cmovge P3, P1
cmp S2, P2
cmovl P1, S2
