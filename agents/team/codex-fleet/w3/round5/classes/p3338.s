# n=5 model=out iset=I1 prefix14_class=3338
cmp P0, P3
mov S1, P1
mov S0, P0
cmovge S0, P3
cmovge P3, P0
cmp P2, S1
mov S2, S0
cmovle S1, P2
cmovg P1, P2
cmp S2, S1
cmovg S0, S1
cmovg S1, S2
cmp P3, P1
mov S0, P3
