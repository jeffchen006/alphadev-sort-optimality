# n=5 model=out iset=I1 prefix14_class=7448
mov S2, P0
cmp S2, P2
cmovge P0, P2
mov S1, P1
cmovge P2, S2
cmp P1, P3
cmovge S1, P3
cmovl P1, P3
cmovle P3, S1
cmp P0, S1
cmovg S1, P0
cmovl P3, P0
cmp P1, P2
cmovle P3, P1
