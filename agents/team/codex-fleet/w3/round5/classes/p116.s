# n=5 model=out iset=I1 prefix14_class=116
mov S2, P3
cmp P0, P3
cmovge S2, P0
cmovge P0, P3
mov S1, P1
cmp P2, S1
cmovge S1, P2
cmovl P1, P2
cmp P1, P0
cmovl P3, P0
cmovle P0, P1
cmovl P1, P3
cmp S1, S2
cmovg P0, S1
