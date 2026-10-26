# n=5 model=out iset=I1 prefix14_class=1554
mov S0, P3
mov S2, P1
cmp P0, P3
cmovg S0, P0
cmovg P0, P3
mov S1, P0
cmp S2, P2
cmovge P1, P2
cmovg P2, S2
cmovle S2, P2
cmp S1, P1
cmovg S1, P1
cmovge P1, P0
cmp S0, P2
