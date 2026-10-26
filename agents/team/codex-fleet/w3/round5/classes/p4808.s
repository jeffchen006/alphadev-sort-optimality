# n=5 model=out iset=I1 prefix14_class=4808
mov S2, P3
cmp P1, P3
cmovl P3, P1
cmovge S2, P1
cmp P2, P0
cmovge P1, P2
cmovge P2, P0
cmovg P0, P1
cmp P3, P2
mov S1, P2
cmovle P2, P3
cmovge S1, P3
cmp S2, P0
cmovle P3, P0
