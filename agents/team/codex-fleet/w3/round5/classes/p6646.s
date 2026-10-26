# n=5 model=out iset=I1 prefix14_class=6646
cmp P3, P2
mov S1, P2
cmovge P2, P3
cmovge P3, S1
cmp P0, P1
cmovge S2, P1
cmovge P1, P0
mov S1, P2
cmovge P0, S2
cmp P2, P1
cmovge S1, P1
cmovle P2, P1
cmovle P1, S1
cmp P0, P3
