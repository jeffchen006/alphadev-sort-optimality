# n=5 model=out iset=I1 prefix14_class=5994
cmp P3, P0
cmovle S1, P3
cmovge S1, P0
mov S0, P2
cmovge P0, P3
cmp P1, P2
cmovle P2, P1
cmovge S0, P1
mov S2, S0
cmp P0, S2
cmovge S2, P0
cmovg P0, S0
mov S2, P2
cmp S1, P2
