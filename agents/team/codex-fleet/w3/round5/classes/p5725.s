# n=5 model=out iset=I1 prefix14_class=5725
cmp P0, P1
cmovg S1, P1
cmovg P1, P0
cmovle S1, P0
mov S0, P3
cmp P2, P3
cmovg S0, P2
cmovg P2, P3
cmp P2, S1
mov P0, P1
cmovge S2, P2
cmovge P2, S1
cmovge S1, S2
cmp S0, P0
