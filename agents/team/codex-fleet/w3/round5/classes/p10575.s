# n=5 model=out iset=I1 prefix14_class=10575
cmp P3, P0
cmovg S1, P0
cmovle S1, P3
mov S0, P1
cmovge P0, P3
cmp S0, P2
cmovg P1, P2
mov S2, P0
cmovge P2, S0
cmp P2, P0
cmovge P0, P2
cmovle S2, P2
cmp S1, P1
cmovg P3, S1
