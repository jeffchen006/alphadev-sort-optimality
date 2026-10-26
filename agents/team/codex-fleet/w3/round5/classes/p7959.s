# n=5 model=out iset=I1 prefix14_class=7959
cmp P3, P1
cmovle S0, P1
cmovg S0, P3
mov S1, P0
cmovge P3, P1
cmp S1, P2
cmovge P0, P2
cmovge P2, S1
cmp P0, P3
cmovge S2, P3
cmovg P3, P0
cmovg P0, S2
cmp P2, S0
mov P1, P2
