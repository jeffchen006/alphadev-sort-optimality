# n=5 model=out iset=I1 prefix14_class=8451
cmp P3, P1
cmovge S0, P3
cmovle S0, P1
mov S1, P2
cmovg P3, P1
cmp P0, P2
cmovge S1, P0
cmovge P0, P2
mov P2, P3
cmp S0, S1
cmovge S2, S1
cmovge S1, S0
cmovg S0, S2
cmp P3, P0
