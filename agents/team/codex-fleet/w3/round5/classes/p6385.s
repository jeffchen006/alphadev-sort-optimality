# n=5 model=out iset=I1 prefix14_class=6385
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
cmovg P3, S1
mov S0, P0
cmp P2, S0
cmovle P0, P2
cmovle P2, S0
cmp P3, P2
cmovle S2, P3
cmovge S2, P2
mov S0, P1
cmovg P2, P3
cmp S0, P0
