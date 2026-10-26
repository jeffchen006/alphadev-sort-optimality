# n=5 model=out iset=I1 prefix14_class=6959
cmp P1, P0
mov S1, P2
cmovge S2, P1
cmovg P1, P0
cmovge P0, S2
cmp P3, S1
cmovle P2, P3
cmovge S1, P3
cmp P0, S1
cmovge S2, P0
cmovge P0, S1
cmovg S1, S2
cmp P2, P1
cmovle P3, P1
