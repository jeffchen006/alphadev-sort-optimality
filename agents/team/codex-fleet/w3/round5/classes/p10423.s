# n=5 model=out iset=I1 prefix14_class=10423
mov S0, P1
cmp S0, P0
cmovg S0, P0
mov S2, S0
mov S1, P2
cmovle P1, P0
cmp P3, S1
cmovle S1, P3
cmovge P2, P3
cmp P1, P2
cmovge P0, P1
cmovg P1, P2
cmovge P2, P0
cmp S1, S2
