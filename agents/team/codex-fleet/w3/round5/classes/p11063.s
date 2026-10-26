# n=5 model=out iset=I1 prefix14_class=11063
mov S2, P2
cmp S2, P3
cmovge S2, P3
cmovge P3, P2
cmp P1, P0
cmovge P2, P1
cmovle P2, P0
cmovle P0, P1
cmovl P1, P2
cmp P3, P1
cmovge P2, P3
cmovle P1, P3
cmp S2, P0
cmovge P3, P0
