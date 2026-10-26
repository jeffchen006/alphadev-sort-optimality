# n=5 model=out iset=I1 prefix14_class=5730
mov S1, P1
cmp P1, P3
cmovge P1, P3
cmovg P3, S1
mov S0, P0
cmp P2, P0
cmovg S0, P2
cmovge P2, P0
mov S2, P1
cmp S2, P2
cmovg S2, P2
cmovg P2, P1
cmp S0, P3
cmovle S2, S0
