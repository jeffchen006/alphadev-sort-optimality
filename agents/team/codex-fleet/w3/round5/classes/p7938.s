# n=5 model=out iset=I1 prefix14_class=7938
cmp P1, P2
cmovge S2, P1
cmovle S2, P2
cmovg P1, P2
mov S0, S2
mov S1, P3
cmp S1, P0
cmovg S1, P0
cmovge P0, P3
cmp P1, S1
cmovg P3, S1
cmovge S1, P1
cmovg P1, P3
cmp S0, P0
