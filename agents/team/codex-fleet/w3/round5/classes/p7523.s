# n=5 model=out iset=I1 prefix14_class=7523
mov S0, P1
mov S1, P0
cmp P2, S0
cmovle P1, P2
cmovge S0, P2
mov S2, P1
cmp P3, P0
cmovge P0, P3
cmovg P3, S1
cmp S2, P3
cmovle S2, P3
cmovle P3, P1
cmp S0, P0
cmovge P3, P0
