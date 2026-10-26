# n=5 model=out iset=I1 prefix14_class=805
mov S0, P0
cmp S0, P1
cmovle S0, P1
mov S1, P3
cmovg P0, P1
cmp P3, P2
cmovge P3, P2
cmovg P2, S1
cmp P2, S0
cmovg S2, P2
cmovge P2, S0
cmovg S0, S2
cmp P0, P3
mov S1, P0
