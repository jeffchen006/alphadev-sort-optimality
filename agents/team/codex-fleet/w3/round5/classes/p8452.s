# n=5 model=out iset=I1 prefix14_class=8452
cmp P3, P1
mov S0, P0
mov S1, P3
cmovle S1, P1
cmovge P3, P1
cmp P2, P0
cmovge S0, P2
cmovg P2, P0
mov P0, P3
cmp S0, S1
cmovge S2, S1
cmovge S1, S0
cmovg S0, S2
cmp P0, P2
