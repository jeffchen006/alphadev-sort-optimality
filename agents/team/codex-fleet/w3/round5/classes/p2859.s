# n=5 model=out iset=I1 prefix14_class=2859
cmp P1, P2
cmovge S0, P2
cmovle S0, P1
cmovge P2, P1
cmp P0, P3
mov S1, P0
cmovle S1, P3
mov S2, P2
cmovg P0, P3
cmp S1, S2
cmovg S2, S1
mov S2, S0
cmovge S1, P2
cmp S2, P0
