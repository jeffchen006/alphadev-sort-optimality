# n=5 model=out iset=I1 prefix14_class=2149
mov S1, P1
cmp S1, P2
cmovge S1, P2
cmovle P1, P2
cmp P3, P0
cmovl P2, P0
cmovle P0, P3
cmovl P3, P2
cmp P3, P1
cmovge P2, P1
cmovl P2, P3
cmovge P1, P3
cmp P0, S1
cmovle P3, P0
