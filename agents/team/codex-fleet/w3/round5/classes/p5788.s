# n=5 model=out iset=I1 prefix14_class=5788
cmp P1, P3
mov S0, P3
cmovle P3, P1
cmovg S0, P1
cmovge P1, P3
cmp P2, P0
cmovg S1, P2
cmovge P2, P0
cmovg P0, S1
cmp P1, P2
cmovle P1, P2
cmovle P2, P3
cmp P0, S0
mov P2, P0
