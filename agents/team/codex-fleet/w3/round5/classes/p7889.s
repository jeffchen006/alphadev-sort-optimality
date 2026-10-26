# n=5 model=out iset=I1 prefix14_class=7889
mov S0, P1
cmp S0, P0
cmovge S0, P0
cmovge P0, P1
cmp P3, P2
cmovle P1, P3
cmovg P1, P2
cmovle P3, P2
cmp P1, S0
cmovge S2, P1
cmovg P1, S0
cmovg S0, S2
cmp P3, P0
cmovge P2, P3
