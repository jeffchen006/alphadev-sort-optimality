# n=5 model=out iset=I1 prefix14_class=6483
mov S2, P0
cmp P0, P1
cmovle P0, P1
cmovle P1, S2
cmp P2, P3
mov S2, P3
cmovge S2, P2
cmovle P3, P2
cmp P0, S2
cmovl P2, P0
cmovge P2, S2
cmovle P0, S2
cmp P3, P1
cmovle P0, P3
