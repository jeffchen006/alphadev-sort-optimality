# n=5 model=out iset=I1 prefix14_class=9199
mov S2, P1
cmp P3, S2
cmovg S2, P3
mov S0, P0
cmovge P3, P1
cmp P2, P0
cmovg S0, P2
cmovle P0, P2
cmp P3, P0
cmovge P2, P0
cmovg P0, P3
mov S1, S0
cmovge P3, P2
cmp S0, S2
