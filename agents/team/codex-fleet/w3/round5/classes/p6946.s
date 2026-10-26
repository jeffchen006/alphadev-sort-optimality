# n=5 model=out iset=I1 prefix14_class=6946
cmp P2, P0
mov S1, P2
cmovg P2, P0
mov S2, P3
cmovge P0, S1
cmp P1, S2
cmovge S2, P1
cmovle P3, P1
cmp P0, S2
mov S1, P0
cmovg P0, S2
cmovg S2, S1
cmp P3, P2
cmovge P1, P3
