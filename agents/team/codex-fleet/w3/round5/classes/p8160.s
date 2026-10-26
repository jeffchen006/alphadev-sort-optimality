# n=5 model=out iset=I1 prefix14_class=8160
cmp P3, P0
cmovge S2, P3
cmovle S2, P0
cmovle P0, P3
cmp P2, P1
cmovg S1, P2
cmovge P2, P1
cmovg P1, S1
cmp P0, P2
mov S0, P0
cmovge S0, P2
cmovg P2, P0
cmp S2, P1
cmovge S0, P1
