# n=5 model=out iset=I1 prefix14_class=1802
mov S1, P0
cmp P1, P3
mov S0, P3
cmovge S0, P1
cmovg P1, P3
cmp P2, P0
cmovg S1, P2
cmovge P2, P0
mov P0, S1
cmp S0, S1
cmovle S1, S0
cmovle S0, P0
cmp P1, P2
cmovge S0, P2
