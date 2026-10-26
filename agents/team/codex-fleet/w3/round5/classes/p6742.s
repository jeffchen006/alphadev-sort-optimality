# n=5 model=out iset=I1 prefix14_class=6742
mov S1, P0
cmp P1, S1
mov S2, P3
cmovge S1, P1
cmovg P1, P0
cmp S2, P2
cmovge S2, P2
cmovle P3, P2
cmp S1, P3
cmovge P2, S1
cmovg S1, P3
cmovge P3, P2
cmp S2, P1
cmovle S0, P1
