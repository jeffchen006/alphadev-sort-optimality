# n=5 model=out iset=I1 prefix14_class=2802
cmp P1, P3
mov S1, P0
cmovge S2, P1
cmovge P1, P3
cmovge P3, S2
cmp P2, P0
cmovle P0, P2
mov S2, P0
cmovl P2, S1
cmp P2, P3
cmovge S1, P3
cmovge P3, P2
cmovge P2, S1
cmp P0, P1
