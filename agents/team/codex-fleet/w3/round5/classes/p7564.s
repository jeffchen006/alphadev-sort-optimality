# n=5 model=out iset=I1 prefix14_class=7564
mov S0, P0
cmp P0, P2
cmovge S0, P2
mov S2, P3
cmovge P2, P0
cmp S2, P1
cmovle S2, P1
cmovg P3, P1
cmp S0, P3
cmovle P1, S0
cmovle S0, P3
cmovle P3, P1
cmp P2, S2
cmovge P1, S2
