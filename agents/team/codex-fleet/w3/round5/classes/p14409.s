# n=5 model=out iset=I1 prefix14_class=14409
mov S1, P0
cmp P2, P0
cmovg P0, P2
cmovle S1, P2
mov S0, P3
cmp P1, S0
cmovge P3, P1
cmovge P1, S0
cmp S1, P1
cmovge S0, S1
cmovg S1, P1
cmovg P1, S0
cmp P0, P3
cmovge S2, P0
