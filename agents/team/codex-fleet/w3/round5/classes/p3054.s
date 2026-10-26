# n=5 model=out iset=I1 prefix14_class=3054
mov S1, P2
cmp P0, P2
cmovge P2, P0
cmovge P0, S1
mov S1, P1
cmp P3, S1
cmovle P1, P3
cmovle P3, S1
mov S1, P0
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmp P2, P3
mov P0, S1
