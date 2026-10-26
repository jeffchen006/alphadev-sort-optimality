# n=5 model=out iset=I1 prefix14_class=13740
cmp P3, P1
cmovge S0, P1
cmovle S0, P3
cmovle P3, P1
cmp P2, P0
cmovge S2, P0
cmovg P0, P2
mov S1, P3
cmovge P2, S2
cmp P3, P0
cmovg P3, P0
cmovge P0, S1
cmovge S1, P3
cmp S0, P2
