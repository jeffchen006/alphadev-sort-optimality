# n=5 model=out iset=I1 prefix14_class=7761
mov S2, P0
cmp S2, P1
cmovg S2, P1
cmovle P0, P1
mov S0, P3
cmp S0, P2
cmovge P3, P2
cmovle S0, P2
cmp S2, P3
cmovg S1, P3
cmovg P3, S2
cmovg S2, S1
cmp S0, P0
cmovge S2, S0
