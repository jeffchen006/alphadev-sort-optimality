# n=5 model=out iset=I1 prefix14_class=3227
cmp P3, P1
cmovg S1, P1
cmovle S1, P3
mov S0, P0
cmovge P1, P3
cmp P2, S0
cmovge P0, P2
cmovle S0, P2
mov P2, P1
cmp S1, S0
cmovge P3, S0
cmovg S0, S1
cmovge S1, P3
cmp P0, P1
