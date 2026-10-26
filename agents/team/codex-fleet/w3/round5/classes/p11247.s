# n=5 model=out iset=I1 prefix14_class=11247
mov S1, P2
mov S0, P1
cmp S0, P3
cmovle S0, P3
cmovg P1, P3
cmp S1, P0
cmovle S1, P0
cmovge P2, P0
cmp S1, S0
cmovge P0, S0
cmovg S0, S1
cmovg S1, P0
cmp P2, P1
cmovge S2, P2
