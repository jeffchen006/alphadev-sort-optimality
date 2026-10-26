# n=5 model=out iset=I1 prefix14_class=4827
mov S2, P0
cmp P1, P2
cmovle S0, P2
cmovle P2, P1
cmovg S0, P1
cmp S2, P3
mov S1, P2
cmovge S2, P3
cmovge P3, P0
cmp S2, P2
cmovle S1, S2
cmovg P2, S2
cmp S0, P3
cmovge S2, P2
