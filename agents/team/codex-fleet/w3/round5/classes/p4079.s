# n=5 model=out iset=I1 prefix14_class=4079
mov S1, P2
cmp P2, P1
cmovl P2, P1
cmovl P1, S1
cmp P3, P0
cmovge S1, P0
cmovg P0, P3
cmovge P3, S1
cmp P3, P1
mov S2, P3
cmovle P3, P1
cmovge S2, P1
mov S2, P0
cmp S2, P2
