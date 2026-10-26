# n=5 model=out iset=I1 prefix14_class=802
mov S0, P0
cmp S0, P1
cmovge P0, P1
cmovle S0, P1
mov S2, P2
cmp P2, P3
cmovge P2, P3
cmovg P3, S2
cmp P3, S0
cmovg S1, P3
cmovge P3, S0
mov S2, P2
cmovg S0, S1
cmp P2, P0
