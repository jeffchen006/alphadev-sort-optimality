# n=5 model=out iset=I1 prefix14_class=119
cmp P0, P3
mov S2, P3
cmovg S2, P0
cmovge P0, P3
mov S1, P1
cmp P2, S1
cmovge S1, P2
cmovl P1, P2
cmp P1, P0
cmovle P3, P0
cmovle P0, P1
cmovl P1, P3
cmp S1, S2
cmovle P2, S2
