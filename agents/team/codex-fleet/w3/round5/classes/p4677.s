# n=5 model=out iset=I1 prefix14_class=4677
cmp P2, P3
mov S2, P3
cmovge P3, P2
cmovge P2, S2
mov S2, P0
cmp P1, S2
cmovle P0, P1
cmovge S2, P1
cmovle P1, S2
cmp S2, P3
cmovl P1, P3
cmovge S2, P3
cmp P2, P0
cmovle P3, P2
