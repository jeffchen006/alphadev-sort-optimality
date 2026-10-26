# n=5 model=out iset=I1 prefix14_class=4438
cmp P1, P3
cmovg S1, P3
cmovge P3, P1
cmovg P1, S1
cmp P2, P0
cmovg S2, P2
mov S0, P3
cmovge P2, P0
cmovle S2, P0
cmp S0, S2
cmovle S0, S2
mov S0, P1
cmovg P3, S2
mov P0, P3
