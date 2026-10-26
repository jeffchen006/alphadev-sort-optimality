# n=5 model=out iset=I1 prefix14_class=12822
mov S0, P0
cmp P1, P0
cmovge P0, P1
mov S2, P2
cmovle S0, P1
cmp S2, P3
cmovge S2, P3
cmovge P3, P2
cmp S0, S2
cmovge S1, S0
cmovg S0, S2
cmovg S2, S1
mov P1, P3
cmp P0, P1
