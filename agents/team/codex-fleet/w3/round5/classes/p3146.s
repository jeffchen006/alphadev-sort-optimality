# n=5 model=out iset=I1 prefix14_class=3146
mov S0, P3
cmp P2, P3
mov S2, P1
cmovle S0, P2
cmovge P3, P2
cmp P0, P1
cmovg S2, P0
cmovle P1, P0
cmp S0, P1
cmovge P0, S0
cmovge S0, P1
cmovle P0, P1
cmp P3, S2
cmovge P2, S2
