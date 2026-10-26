# n=5 model=out iset=I1 prefix14_class=3752
mov S2, P1
cmp P3, P2
cmovle S1, P3
cmovge S1, P2
cmovge P2, P3
cmp P0, P1
mov S0, S1
cmovg S2, P0
cmovg P0, P1
cmp P0, S1
cmovge S0, P0
cmovle S1, P0
mov S1, P2
cmp S1, S2
