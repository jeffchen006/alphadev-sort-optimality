# n=5 model=out iset=I1 prefix14_class=7454
cmp P3, P0
mov S1, P3
cmovge S1, P0
cmovge P0, P3
mov S2, P2
cmp S2, P1
cmovge S2, P1
cmovle P2, P1
mov S0, P0
cmp S1, S2
cmovg P1, S2
cmovge S2, S1
cmovg S1, P1
cmp P0, P2
