# n=5 model=out iset=I1 prefix14_class=12132
cmp P3, P0
cmovge S1, P0
cmovg P0, P3
cmovle S1, P3
mov S2, P1
cmp P2, P1
cmovg P1, P2
cmovle S2, P2
cmp S2, S1
cmovge P2, S1
cmovge S1, S2
mov S0, P0
cmovge S2, P2
cmp P0, P1
