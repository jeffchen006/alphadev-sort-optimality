# n=5 model=out iset=I1 prefix14_class=12397
mov S2, P3
cmp P2, P3
cmovge S2, P2
cmovl P3, P2
cmp P0, P1
cmovge P2, P1
cmovg P1, P0
cmovle P2, P0
cmp P3, P2
cmovle P0, P2
cmovle P2, P3
cmovle P3, P0
cmp P1, S2
mov S0, S2
