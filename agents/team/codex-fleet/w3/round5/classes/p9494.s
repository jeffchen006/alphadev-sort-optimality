# n=5 model=out iset=I1 prefix14_class=9494
cmp P1, P0
mov S1, P0
cmovl P0, P1
cmovge S1, P1
cmp P3, P2
cmovge S2, P3
cmovge P3, P2
cmovge P2, S2
cmp P0, P3
cmovge P1, P3
cmovle P1, P0
cmovle P0, P3
cmp P2, S1
cmovl P3, P2
