# n=5 model=out iset=I1 prefix14_class=851
cmp P0, P3
cmovge S2, P0
cmovle S2, P3
mov S1, P1
cmovg P0, P3
cmp S1, P2
cmovge S1, P2
cmovg P2, P1
mov P3, P2
cmp S2, P2
cmovge P2, S2
cmovg S2, P3
cmp P0, S1
mov S0, S1
