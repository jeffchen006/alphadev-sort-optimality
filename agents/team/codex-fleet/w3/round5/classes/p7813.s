# n=5 model=out iset=I1 prefix14_class=7813
mov S0, P3
cmp S0, P1
cmovg P3, P1
cmovle S0, P1
cmp P0, P2
cmovge S2, P0
cmovge P0, P2
cmovge P2, S2
cmp P3, P0
cmovge P1, P0
cmovle P1, P3
cmovg P0, P3
cmp S0, P2
cmovle P3, S0
