# n=5 model=out iset=I1 prefix14_class=6975
mov S2, P1
cmp P0, P3
cmovg S0, P3
cmovge P3, P0
mov S1, P3
cmovg P0, S0
cmp P2, P1
cmovg S2, P2
cmovle P1, P2
cmp S1, S2
cmovge P3, S2
cmovle S1, S2
cmp P1, P0
cmovge S1, P0
