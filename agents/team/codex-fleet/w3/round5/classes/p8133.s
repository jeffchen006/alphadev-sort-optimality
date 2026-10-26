# n=5 model=out iset=I1 prefix14_class=8133
cmp P3, P0
mov S2, P0
cmovge P0, P3
cmovle S2, P3
cmp P1, P2
cmovg P3, P2
cmovge P2, P1
cmovg P1, P3
mov S0, P2
mov S1, S2
cmp S1, P1
cmovle S1, P1
cmovg S2, P1
mov S2, S1
