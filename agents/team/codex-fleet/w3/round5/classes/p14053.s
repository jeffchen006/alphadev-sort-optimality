# n=5 model=out iset=I1 prefix14_class=14053
cmp P3, P2
mov S2, P2
cmovg P2, P3
cmovle S2, P3
cmp P1, P0
mov S1, P1
cmovge P1, P0
cmovle S1, P0
mov S0, S1
cmp S1, P2
cmovg S1, P2
cmovg P2, S0
cmp S2, P1
cmovge P3, P1
