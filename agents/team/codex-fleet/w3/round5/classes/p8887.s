# n=5 model=out iset=I1 prefix14_class=8887
cmp P1, P0
cmovge S0, P1
cmovle S0, P0
cmovge P1, P0
cmp P3, P2
mov S1, P3
cmovg S1, P2
mov S2, S1
cmovge P2, P3
cmp S0, P2
cmovge P0, P2
cmovg P2, S0
cmovge S0, P0
cmp S1, P1
