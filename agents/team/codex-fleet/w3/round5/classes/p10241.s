# n=5 model=out iset=I1 prefix14_class=10241
mov S1, P3
cmp P1, P2
cmovg S0, P1
cmovg P1, P2
cmovg P2, S0
cmp P0, P3
cmovge S1, P0
mov S2, S1
cmovge P0, P3
cmp S2, P2
cmovle S2, P2
cmovge S1, P2
mov P2, P1
cmp P0, P2
